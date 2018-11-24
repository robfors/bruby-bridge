BRubyBridge.RbError = class extends Error
{
  
  constructor(rb_value)
  {
    var message = rb_value.send("message").to_string();
    super(message);
    this._rb_error = rb_value;
  }

  get rb_value()
  {
    return this._rb_error;
  }

};