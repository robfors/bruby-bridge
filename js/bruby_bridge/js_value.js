(function(){

  var JSError = BRubyBridge.JSError;

  BRubyBridge.JSValue = class
  {

    
    static define_js_method(definition_receiver, name, code, argument_names)
    {
      code = "return " + code + ";"
      definition_receiver[name] = new Function(...argument_names, code);
    }

    
    static call_js_method(definition_receiver, name, args)
    {
      var js_method = definition_receiver[name];
      if (js_method == undefined)
        throw new Error("js method '" + method_name + "' not found");
      //args = args.map( arg => arg instanceof BRubyBridge.RbInterface ? new BRubyBridge.RbValue(arg) : arg );
      var func = js_method.bind(undefined, ...args);
      var return_value = this.capture_exception(func)
      //if (return_value instanceof BRubyBridge.RbValue)
      //  return_value = return_value._interface;
      return return_value;
    }


    static capture_exception(func)
    {
      var return_value;
      //try
      //{
        return_value = func();
        if (typeof return_value == 'object' && return_value instanceof JSError)
          throw new TypeError("can not reutrn a JSError")
      //}
      //catch (error_js)
      //{
      //  return_value = new JSError(error_js);
      //}
      return return_value;
    }


    static is_error(return_value)
    {
      return return_value instanceof JSError;
    }


  };


})();