module BRubyBridge
  class RbValue

    
    def self.send(object_rb, method_name_rb, *arguments_rb)
      begin
        arguments_rb.map! do |argument_rb|
          argument_rb.is_a?(JSInterface) ? JSValue.new(argument_rb) :  argument_rb
        end

        return_value = object_rb.__send__(method_name_rb, *arguments_rb)

        return_value = return_value.interface if return_value.is_a?(JSValue)

        if return_value.is_a?(RbError)
          raise TypeError, "can not reutrn a RbError"
        end
        return_value
      rescue StandardError => error_rb
        return_value = RbError.new(error_rb)
      end
    end


    def self.eval(code)
      BRubyBridge.main_object.instance_eval { eval(code) }
    end


  end
end