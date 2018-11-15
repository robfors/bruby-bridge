BRubyBridge.RbError = class extends Error
{
  
  constructor(rb_error)
  {
    var message = rb_error.send("message").to_string();
    super(message);
    this._rb_error = rb_error;
  }

  get rb_value()
  {
    return this._rb_error;
  }

};