BRubyBridge.JSError = class
{


  constructor(error_js)
  {
    if (!(error_js instanceof Error))
      throw new TypeError;
    this.error_js = error_js;
  }
  
  
};