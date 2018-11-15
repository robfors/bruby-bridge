module BRubyBridge
  module Override

    
    def override_method(method_name, receiver: self, &block)
      raise AgumentError unless method_name.respond_to?(:to_s)
      method_name = method_name.to_s
      old_method = receiver.instance_method(method_name)
      new_method = Proc.new do |*arguments|
        self.instance_exec(*arguments, old_method: old_method.bind(self), &block)
      end
      receiver.define_method(method_name, new_method)
    end


    def override_singleton_method(method_name, &block)
      override_method(method_name, receiver: singleton_class, &block)
    end


  end
end