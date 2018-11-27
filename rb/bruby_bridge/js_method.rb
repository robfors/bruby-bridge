module BRubyBridge
  module JSMethod


    def define_singleton_js_method(name, code, options = {})
      options[:receiver] = singleton_class
      define_js_method(name, code, options)
    end


    def define_js_method(method_name, code, options = {})
      raise TypeError unless method_name.is_a?(Symbol) || method_name.is_a?(String)
      method_name = method_name.to_s
      
      raise TypeError unless code.is_a?(String)
      code = code.to_s

      argument_table = options[:arguments] || {}
      raise TypeError, "arguments option must be a Hash" unless argument_table.is_a?(Hash)
      supported_argument_types = ['key', 'any']
      argument_table = argument_table.map { |name, type| [name.to_s, type.to_s] }.to_h
      argument_table.each.with_index do |name_and_type, index|
        name, type = name_and_type

        if name[0] == '*'
          is_last_argument_type = (index + 1 == argument_table.length)
          raise ArgumentError, 'a splat argument must come last' unless is_last_argument_type
        end

        supported_argument_types.include?(type)
      end

      return_type = options[:return] || :any
      return_type = return_type.to_s
      supported_return_types = ['any', 'string', 'boolean']
      unless supported_return_types.include?(return_type)
        raise ArgumentError, 'return type not supported'
      end

      klass = self
      singleton_klass = klass.singleton_class

      definition_receiver = options[:receiver] || klass

      definition_receiver_js = case
      when definition_receiver == klass
        js_class_interface.get(JSInterface.string("prototype"))
      when definition_receiver == singleton_klass
        js_class_interface
      else
        raise
      end
      
      method_proc = Proc.new do |*arguments|
        
        parsed_arguments = []
        argument_table.each do |name, type|
          
          parse_next_argument = lambda do
            argument = arguments.shift
            case type
            when 'key'
              parsed_arguments << klass.convert_key(argument)
            when 'any'
              parsed_arguments << argument
            else
              raise
            end
          end
          
          if name[0] == '*'
            name = "...#{name[1..-1]}"
            parse_next_argument.call until arguments.empty?
          else
            raise ArgumentError, "missing argument '#{name}'" if arguments.empty?
            parse_next_argument.call
          end

        end
        unless arguments.empty?
          raise ArgumentError, "too many arguments, only expected #{argument_table.length}"
        end

        call_receiver = self

        method_name_js = JSInterface.string(method_name)
        
        parsed_arguments.map! { |argument| argument.instance_of?(klass) ? argument.interface : argument }
        parsed_arguments.insert(0, @interface) if call_receiver.instance_of?(klass)
        arguments_js = klass.interface_array(parsed_arguments)
        return_value = klass.call_js_method(definition_receiver_js, method_name_js, arguments_js)

        return_value = klass.new(return_value) if return_value.instance_of?(JSInterface)
        return_value = case return_type
        when 'any'
          return_value
        when 'string'
          unless return_value.is_a?(JSValue)
            raise TypeError, "value returned is not a JSValue, can not convert to string"
          end
          return_value.to_string
        when 'boolean'
          unless return_value.is_a?(JSValue)
            raise TypeError, "value returned is not a JSValue, can not convert to boolean"
          end
          return_value.to_boolean
        else
          raise
        end
        return_value
      end

      definition_receiver.define_method(method_name, &method_proc)
      
      key_js = JSInterface.string("define_js_method");
      method_name_js = JSInterface.string(method_name);
      code_js = JSInterface.string(code);
      argument_name_js_values = argument_table.keys.map do |name|
        name = "...#{name[1..-1]}" if name[0] == '*'
        JSInterface.string(name)
      end
      argument_name_js_values.insert(0, JSInterface.string('this_object')) if definition_receiver == klass
      argument_names_js = interface_array(argument_name_js_values)
      js_class_interface.call(key_js, definition_receiver_js, method_name_js, code_js, argument_names_js)

      nil
    end


    def define_binary_js_operator(method_name, options = {})
      method_name = method_name.to_s
      keyword = options[:keyword] || method_name
      keyword = keyword.to_s
      raise if options[:arguments]
      options[:arguments] = {:other => :any}
      define_js_method(method_name, "this_object #{keyword} other", options)
      nil
    end


    def define_unary_js_operator(keyword, options = {})
      keyword = keyword.to_s
      raise if options[:arguments]
      define_js_method(keyword, "#{keyword} this_object", options)
      nil
    end


    # private
    def call_js_method(definition_receiver_js, name_js, arguments_js)
      key_js = JSInterface.string("call_js_method")
      capture_exception do
        return_value = js_class_interface.call(key_js, definition_receiver_js, name_js, arguments_js)
      end
    end


    def capture_exception(&block)
      return_value = yield
      # avoid infinite loop by using JSInterface only (not JSValue)
      if js_class_interface.call(JSInterface.string("is_error"), return_value).to_boolean
        raise_js_exception(return_value.get(JSInterface.string("error_js")))
      end
      return_value
    end


    def raise_js_exception(error_js_interface)
      error_js = new(error_js_interface)
      error_rb = nil
      if error_js.instanceof(get("BRubyBridge.RbError"))
        error_rb = error_js.get("rb_value")
      else
        error_rb = JSError.new(error_js)
      end
      raise error_rb
    end


    def js_class_interface
      @js_class ||= JSInterface.global
        .get(JSInterface.string("BRubyBridge"))
        .get(JSInterface.string("JSValue"))
    end


    # private
    def convert_key(key_rb)
      key_js = case key_rb
      when Numeric
        number(key_rb)
      when String, Symbol
        string(key_rb)
      when self
        key_rb
      else
        raise TypeError, "key must be a Numeric, String, Symbol or JSValue"
      end
      key_js
    end

    
    def ensure_js_value(object)
      raise TypeError, "must be of type JSValue" unless object.is_a?(JSValue)
      nil
    end


    def interface_array(array_rb)
      array_js = JSInterface.global.call(JSInterface.string("Array"))
      array_rb.each { |item| array_js.call(JSInterface.string("push"), item) }
      array_js
    end


  end
end