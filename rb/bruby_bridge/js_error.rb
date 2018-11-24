module BRubyBridge
  class JSError < StandardError

    attr_reader :js_value

    def initialize(js_value)
      message = nil
      case
      when js_value.typeof == "object" && js_value.has?("message")
        message = js_value["message"].to_string
      when js_value.string?
        message.to_string
      end
      super(message)
      @js_value = js_value
    end

  end
end