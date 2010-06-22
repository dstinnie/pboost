################################################################################
#
# Copyright (C) 2006 Peter J Jones (pjones@pmade.com)
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
################################################################################

class PDF::Reader
  ################################################################################
  # An internal PDF::Reader class that represents the Xref table in a PDF file
  # An Xref table is a map of object identifiers and byte offsets. Any time a particular
  # object needs to be found, the Xref table is used to find where it is stored in the
  # file.
  class XRef
    ################################################################################
    # create a new Xref table based on the contents of the supplied PDF::Reader::Buffer object
    def initialize (io)
      @io = io
      @xref = {}
    end
    def size
      @xref.size
    end
    ################################################################################
    # returns the PDF version of the current document. Technically this isn't part of the XRef
    # table, but it is one of the lowest level data items in the file, so we've lumped it in
    # with the cross reference code.
    def pdf_version
      @io.seek(0)
      m, version = *@io.read(8).match(/%PDF-(\d.\d)/)
      raise MalformedPDFError, 'invalid PDF version' if version.nil?
      return version.to_f
    end
    ################################################################################
    # Read the xref table from the underlying buffer. If offset is specified the table
    # will be loaded from there, otherwise the default offset will be located and used.
    #
    # Will fail silently if there is no xref table at the requested offset.
    def load (offset = nil)
      offset ||= new_buffer.find_first_xref_offset

      buf = new_buffer(offset)
      token = buf.token

      if token == "xref" || token == "ref"
        load_xref_table(buf)
      elsif token.to_i >= 0 && buf.token.to_i >= 0 && buf.token == "obj"
        raise PDF::Reader::UnsupportedFeatureError, "XRef streams are not supported in PDF::Reader yet"
      else
        raise PDF::Reader::MalformedPDFError, "xref table not found at offset #{offset} (#{token} != xref)"
      end
    end
    ################################################################################
    # Return a string containing the contents of an entire PDF object. The object is requested
    # by specifying a PDF::Reader::Reference object that contains the objects ID and revision
    # number
    #
    # If the object is a stream, that is returned as well
    def object (ref)
      return ref unless ref.kind_of?(Reference)
      buf = new_buffer(offset_for(ref))
      obj = Parser.new(buf, self).object(ref.id, ref.gen)
      return obj
    end
    # returns the type of object a ref points to
    def obj_type(ref)
      obj = object(ref)
      obj.class.to_s.to_sym
    end
    # returns true if the supplied references points to an object with a stream
    def stream?(ref)
      obj, stream = @xref.object(ref)
      stream ? true : false
    end
    ################################################################################
    # returns the byte offset for the specified PDF object.
    #
    # ref - a PDF::Reader::Reference object containing an object ID and revision number
    def offset_for (ref)
      @xref[ref.id][ref.gen]
    rescue
      raise InvalidObjectError, "Object #{ref.id}, Generation #{ref.gen} is invalid"
    end
    ################################################################################
    # iterate over each object in the xref table
    def each(&block)
      ids = @xref.keys.sort
      ids.each do |id|
        gen = @xref[id].keys.sort[-1]
        ref = PDF::Reader::Reference.new(id, gen)
        yield ref, object(ref)
      end
    end
    ################################################################################
    # Stores an offset value for a particular PDF object ID and revision number
    def store (id, gen, offset)
      (@xref[id] ||= {})[gen] ||= offset
    end
    ################################################################################
    private
    ################################################################################
    # Assumes the underlying buffer is positioned at the start of an Xref table and
    # processes it into memory.
    def load_xref_table(buf)
      params = []

      while !params.include?("trailer") && !params.include?(nil)
        if params.size == 2
          objid, count = params[0].to_i, params[1].to_i
          count.times do
            offset = buf.token.to_i
            generation = buf.token.to_i
            state = buf.token

            store(objid, generation, offset) if state == "n"
            objid += 1
            params.clear
          end
        end
        params << buf.token
      end

      trailer = Parser.new(buf, self).parse_token

      raise MalformedPDFError, "PDF malformed, trailer should be a dictionary" unless trailer.kind_of?(Hash)

      load(trailer[:Prev].to_i) if trailer.has_key?(:Prev)

      trailer
    end

    def new_buffer(offset = 0)
      PDF::Reader::Buffer.new(@io, :seek => offset)
    end
  end
  ################################################################################
end
################################################################################
