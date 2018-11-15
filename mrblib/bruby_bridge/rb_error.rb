module BRubyBridge
  class RbError

    attr_reader :error_rb

    def initialize(error_rb)
      raise TypeError unless error_rb.is_a?(Exception)
      @error_rb = error_rb
    end

  end
end