(function(){

  var RbError = BRubyBridge.RbError;
  var RbInterface = BRubyBridge.RbInterface;
  var ArgumentError = BRubyBridge.ArgumentError;


  BRubyBridge.RbValue = class
  {


    static boolean(boolean_js)
    {
      if (arguments.length != 1)
        throw new ArgumentError('must pass one argument'); 
      boolean_js = !!boolean_js;
      return (boolean_js == true) ? this.true : this.false;
    }


    static eval(code)
    {
      return this.get('BRubyBridge::RbValue').send("eval", this.string(code));
    }


    static float(number_js)
    {
      if (arguments.length != 1)
        throw new ArgumentError('must pass one argument');
      var parsed_number_js = Number(number_js);
      if (Number.isNaN(parsed_number_js))
      {
        if (!Number.isNaN(number_js))
          throw new TypeError('argument must be parsable by Number()');
        return this.get('Float::NAN');
      }
      if (!isFinite(parsed_number_js))
        return this.get('Float::INFINITY');
      var float_interface = RbInterface.float(parsed_number_js);
      var float_rb = new this(float_interface);
      return float_rb;
    }


    static get(path)
    {
      if (arguments.length != 1)
        throw new ArgumentError('must pass one argument');
      if (typeof path != 'string')
        throw new TypeError('must pass path as string');
      var names = path.split('::');
      var rb_value = this.Object;
      names.forEach( name => rb_value = rb_value.send("const_get", this.string(name)) );
      return rb_value;
    }


    static _get_interface(code)
    {
      var names = 'BRubyBridge::RbValue'.split('::');
      var rb_interface = RbInterface.Object;
      names.forEach( name => rb_interface = rb_interface.send("const_get", RbInterface.string(name)) );
      var code_interface = BRubyBridge.RbInterface.string(code);
      return rb_interface.send("eval", code_interface);
    }


    static _get_value(code)
    {
      return new this(this._get_interface(code));
    }


    static integer(number_js)
    {
      if (arguments.length != 1)
        throw new ArgumentError('must pass one argument');
      var float_rb = this.float(number_js);
      var integer_rb = float_rb.send('to_i');
      return integer_rb;
    }

    
    static string(string_js)
    {
      if (arguments.length > 1)
        throw new ArgumentError('too many arguments');
      if (arguments.length == 0)
        string_js = '';
      if (typeof string_js == 'string')
        undefined; // take as is
      else if (string_js instanceof String || typeof string_js == 'number' || string_js instanceof Number)
        string_js = String(string_js);
      else
        throw new TypeError('must pass a string, String, number or Number');
      var string_interface = RbInterface.string(string_js);
      var string_rb = new this(string_interface);
      return string_rb;
    }


    static symbol(string_js)
    {
      if (arguments.length != 1)
        throw new ArgumentError('must pass one argument');
      var string_rb = this.string(string_js);
      var symbol_rb = string_rb.send('to_sym');
      return symbol_rb;
    }


    constructor(rb_interface)
    {
      if (arguments.length != 1)
        throw new Error('must pass one argument');
      if (!(rb_interface instanceof RbInterface))
        throw new TypeError('must pass a RbInterface');
      
      // check if backward reference exists
      var rb_value = rb_interface._rb_value;
      if (rb_value == undefined)
      {
        //this.active = true;
        rb_value = this;
        
        // setup forward reference
        rb_value._interface = rb_interface;
        // setup backward reference
        rb_interface._rb_value = rb_value;
      }
      
      return rb_value;
    }


    //ensure_active()
    //{
    //  if (!this.active)
    //    throw new BRubyBridge.StaleRubyObjectReference();
    //}


    // TODO: replace with js finalizer when available
    //forget()
    //{
    //  this.delete();
    //  //this.active = false;
    //};


    send(method_name, ...args)
    {
      if (arguments.length < 1)
        throw new ArgumentError("too few arguments given");
      if (method_name instanceof String)
        method_name = method_name.valueOf();
      if (typeof method_name != 'string')
        throw new TypeError("method_name must be a string or String");
      var args = args.map( arg => arg instanceof this.constructor ? arg._interface : arg );

      var _class_rb = this.constructor._class_rb;
      var method_name_rb = BRubyBridge.RbInterface.string(method_name);
      var return_value = _class_rb.send("send", this._interface, method_name_rb, ...args);
      
      if (return_value instanceof RbInterface)
      {
        return_value = new this.constructor(return_value);
        // call send on the interface to avoid an infinite loop
        if (return_value._interface.send("is_a?", this.constructor._rb_error_class_rb).to_boolean())
        {
          var error_rb = return_value.send("error_rb");
          this._throw_rb_error(error_rb);
        }
      }
      return return_value;
    }

    
    _throw_rb_error(error_rb)
    {
      var error_js;
      if (error_rb.send("is_a?", this.constructor.get("BRubyBridge::JSError")).to_boolean())
        error_js = error_rb.send("js_value");
      else
        error_js = new RbError(error_rb);
      throw error_js;
    }
    

    to_boolean()
    {
      return this._interface.to_boolean();
    }


    to_number()
    {
      var float_rb;
      try
      {
        float_rb = this.constructor.Object.send("Float", this);
      }
      catch(e)
      {
        throw new TypeError('can not convert that Ruby object to a JavaScript number');
      }
      if (float_rb.send('nan?').to_boolean())
        return NaN;
      if (float_rb.send('infinite?').to_boolean())
        return Infinity;
      return float_rb._interface.to_number();
    }


    to_string()
    {
      var string_rb;
      try
      {
        string_rb = this.constructor.Object.send("String", this);
      }
      catch(e)
      {
        throw new TypeError('can not convert that Ruby object to a JavaScript string');
      }
      return string_rb._interface.to_string();
    }


  };


  var RbValue = BRubyBridge.RbValue;

  RbValue._class_rb = RbValue._get_interface('BRubyBridge::RbValue');
  
  RbValue.false = RbValue._get_value('false');
  
  RbValue.Kernel = RbValue._get_value('Kernel');

  RbValue.nil = RbValue._get_value('nil');

  RbValue.Object = RbValue._get_value('Object');

  RbValue._rb_error_class_rb = RbValue._get_interface('BRubyBridge::RbError');
  
  RbValue.true = RbValue._get_value('true');


})();