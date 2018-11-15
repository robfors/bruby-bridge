BRubyBridge.OutOfMemoryError = class extends Error
{
  
  constructor(message, ...args)
  {
    var message = message || "out of memory";
    super(message,...args);
    if (typeof Error.captureStackTrace === 'function')
      Error.captureStackTrace(this, this.constructor);
    else
      this.stack = (new Error(this.message)).stack;
  }
  
};




//throw new StaleRubyObjectReference();
