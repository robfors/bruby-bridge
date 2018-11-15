module BRubyBridge
  class RbValue

    
    def self.send(object_rb, method_name_rb, *arguments_rb)
      #begin
        #arguments_rb.map! do |argument_rb|
        #  argument_rb.is_a?(JSInterface) ? JSValue.new(argument_rb) :  argument_rb
        #end

        return_rb = object_rb.__send__(method_name_rb, *arguments_rb)

        #return_rb = return_rb.interface if return_rb.is_a?(JSValue)

        if return_rb.is_a?(RbError)
          raise TypeError, "can not reutrn a RbError"
        end
        return_rb
      #rescue StandardError => error_rb
      #  return_rb = RbError.new(error_rb)
      #end
    end


    def self.eval(code)
      BRubyBridge.main_object.instance_eval { eval(code) }
    end


  end
end