module BRubyBridge
  class JSValue
    extend JSMethod


    def self.array(array_rb = [])
      case
      when array_rb.is_a?(Array)
        array_rb = array_rb
      when array_rb.respond_to?(:to_ary)
        array_rb = array_rb.to_ary
      else
        raise TypeError, "argument must be an Array or respond to #to_ary"
      end
      array_js = global.call("Array")
      array_rb.each { |item| array_js.call("push", item) }
      array_js
    end


    def self.boolean(boolean_rb)
      boolean_rb = !!boolean_rb
      if boolean_rb == true
        self.true
      else
        self.false
      end
    end


    # to help you to avoid ever calling eval
    # will not serach global namespace
    def self.get(property_path)
      raise TypeError, "'property_path' must be a String" unless property_path.is_a?(String)
      raise ArgumentError, "'property_path' can not be empty" if property_path.empty?
      current_object = global
      property_path_names = property_path.split('.')
      property_path_names.each do |name|
        current_object = current_object[name]
      end
      current_object
    end
    alias_singleton_method :[], :get


    def self.global
      @global ||= new(JSInterface.global)
    end
    alias_singleton_method :window, :global


    def self.global_namespace(name)
      raise TypeError, "name must be a String" unless name.is_a?(String)
      begin
        eval(name)
      rescue JSError => error
        raise error unless error.js_value.instanceof(get('ReferenceError'))
        false
      end
    end


    # TODO: seprate gem
    #def self.eval(js_code)
    #  raise TypeError, "js code must be a String" unless js_code.is_a?(String)
    #  global.call("eval", string(js_code))
    #end
    

    define_singleton_js_method :false, "false"

    
    define_singleton_js_method :infinity, "Infinity"
    
    
    singleton_attr_reader :js_class

    
    define_singleton_js_method :nan, "NaN"


    def self.new(interface)
      raise TypeError unless  interface.is_a?(JSInterface)
      # check if backward reference exists
      js_value = interface.instance_variable_get(:@js_value)
      unless js_value
        js_value = super
        # setup forward reference
        js_value.instance_variable_set(:@interface, interface)
        # setup backward reference
        interface.instance_variable_set(:@js_value, js_value)
      end
      js_value
    end
    
    
    define_singleton_js_method :null, "null"
    

    def self.number(number_rb)
      ready_number_rb = nil
      begin
        ready_number_rb = Float(number_rb)
      rescue ArgumentError
      end
      if ready_number_rb == nil && number_rb.respond_to?(:to_int)
        number_rb = number_rb.to_int
        raise TypeError, "value returned from #to_int must be an Integer" unless number_rb.is_a?(Integer)
        ready_number_rb = number_rb.to_f
      end
      if ready_number_rb == nil
        raise TypeError, "argument must be parsable by Float() or respond to #to_int"
      end
      number_interface = JSInterface.number(ready_number_rb)
      number_js = new(number_interface)
    end
    

    def self.object(hash_rb = {})
      raise TypeError, "argument must respond to #to_h" unless hash_rb.respond_to?(:to_h)
      hash_rb = hash_rb.to_h
      keys = hash_rb.keys
      values = hash_rb.values
      keys.map! { |key| convert_key(key) }
      raise RuntimeError, "hash keys must be unique" unless keys.uniq?
      hash_rb = [keys, values].transpose.to_h
      object_js = global.call("Object")
      hash_rb.each { |k, v| object_js[k] = v }
      object_js
    end


    def self.string(string_rb = "")
      case
      when string_rb.is_a?(String)
        string_rb = string_rb
      when string_rb.respond_to?(:to_str)
        string_rb = string_rb.to_str
      when string_rb.is_a?(Symbol)
        string_rb = string_rb.to_s
      else
        raise TypeError, "argument must be a String, respond to #to_str or be of type Symbol"
      end
      string_interface = JSInterface.string(string_rb)
      string_js = new(string_interface)
    end


    define_singleton_js_method :true, "true"


    define_singleton_js_method :undefined, "undefined"


    define_binary_js_operator '+'
    

    define_binary_js_operator '-'
    

    define_binary_js_operator '*'
    

    define_binary_js_operator '/'
    

    define_binary_js_operator '%'
    
    
    define_js_method '**', "Math.pow(this_object, other)", arguments: {:other => :any}
    
    
    # define_js_method :_js_equal, "this_object == other", arguments: {:other => :any}, return: :boolean
    # def ==(other_object)
    #   if other_object.is_a?(JSValue)
    #     _js_equal.call(other_object)
    #   else
    #     false
    #   end
    # end
    # alias_method :eql?, :==

    
    # define_js_method :_js_not_equal, "this_object != other", arguments: {:other => :any}, return: :boolean
    # def !=(other_object)
    #   if other_object.is_a?(JSValue)
    #     _js_not_equal.call(other_object)
    #   else
    #     true
    #   end
    # end
    

    define_binary_js_operator '>', return: :boolean
    

    define_binary_js_operator '>=', return: :boolean
    

    define_binary_js_operator '<', return: :boolean
    

    define_binary_js_operator '<=', return: :boolean
    

    define_binary_js_operator '&'
    

    define_binary_js_operator '|'
    

    define_binary_js_operator '^'
    

    define_unary_js_operator '~'
    

    define_binary_js_operator '<<'
    

    define_binary_js_operator '>>'
    

    define_unary_js_operator '!', return: :boolean


    def boolean?
      typeof == "boolean"
    end


    define_js_method :call, "this_object[key](...args)", arguments: {:key => :key, '*args' => :any}

    
    define_js_method :delete, "delete this_object[key]", arguments: {:key => :key}, return: :boolean
    
    
    def false?
      strictly_equal?(self.class.false)
    end

    
    define_js_method :get, "this_object[key]", arguments: {:key => :key}
    alias_method :[], :get

    
    def has?(key)
      key = self.class.convert_key(key)
      key.in(self)
    end

    
    define_binary_js_operator :in, return: :boolean
    

    define_binary_js_operator :instanceof, return: :boolean


    attr_reader :interface


    define_js_method :nan?, "Number.isNaN(this_object)", return: :boolean


    define_js_method :new, "new this_object(...args)", arguments: {'*args' => :any}

    
    def null?
      strictly_equal?(self.class.null)
    end

    
    def number?
      typeof == "number"
    end


    # define_js_method :post_decrement, "this_object--"
    

    # define_js_method :post_increment, "this_object++"
    

    # define_js_method :pre_decrement, "--this_object"
    

    # define_js_method :pre_increment, "++this_object"
    

    def rb_object?
      instanceof(get("BRubyBridge.RbValue"))
    end


    define_js_method :set, "this_object[key] = value", arguments: {:key => :key, :value => :any}
    alias_method :[]=, :set

    
    define_binary_js_operator :strictly_equal?, keyword: '===', return: :boolean


    define_binary_js_operator :strictly_not_equal?, keyword: '!==', return: :boolean


    define_js_method :string?, "typeof this_object == 'string'", return: :boolean


    define_js_method :throw, "(function(){ throw this_object; })()"


    def to_boolean
      @interface.to_boolean
    end


    def to_float
      if number?
        number_rb = @interface.to_float
      else
        number_js = self.class.global.call("Number", self)
        number_rb = number_js.to_float
      end
    end

    
    def to_integer
      to_float.to_i
    end


    def to_string
      if string?
        string_rb = @interface.to_string
      else
        string_js = self.class.global.call('String', self)
        string_rb = string_js.to_string
      end
    end


    def true?
      strictly_equal?(self.class.true)
    end

    
    define_unary_js_operator :typeof, return: :string


    def undefined?
      strictly_equal?(self.class.undefined)
    end


  end
end