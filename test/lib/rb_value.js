function test_rb_value()
{
  
  var RbValue = BRubyBridge.RbValue;
  var RbError = BRubyBridge.RbError;
  var ArgumentError = BRubyBridge.ArgumentError;


  console.log("start-rb_value");

  
  test("RbValue.boolean");
  // too few arguments
  ensure_raise(ArgumentError, () => RbValue.boolean() );
  //
  ensure_rb_result("v0 == true", RbValue.boolean(true));
  //
  ensure_rb_result("v0 == false", RbValue.boolean(false));
  //
  ensure_rb_result("v0 == false", RbValue.boolean(null));
  //
  ensure_rb_result("v0 == false", RbValue.boolean(undefined));
  //
  ensure_rb_result("v0 == false", RbValue.boolean(0));
  //
  ensure_rb_result("v0 == true", RbValue.boolean(1));
  //
  ensure_rb_result("v0 == true", RbValue.boolean('0'));
  //
  ensure_rb_result("v0 == true", RbValue.boolean({}));
  // too many arguments
  ensure_raise(ArgumentError, () => RbValue.boolean(true, rb_eval("false")) );
  

  test("RbValue.false");
  //
  ensure_rb_result("v0 == false", RbValue.false);
  //
  ensure_rb_result_not("v0 == true", RbValue.false);
  //
  ensure_rb_result_not("v0 == nil", RbValue.false);


  test("RbValue.float");
  // too few arguments
  ensure_raise(ArgumentError, () => RbValue.float() );
  //
  ensure_rb_result("v0 == 0", RbValue.float(0));
  //
  ensure_rb_result("v0 == 1", RbValue.float(1));
  //
  ensure_rb_result("v0 == 1", RbValue.float(1.0));
  //
  ensure_rb_result("v0 == 1.5", RbValue.float(1.5));
  //
  ensure_rb_result("v0 == -2.5", RbValue.float("-2.5"));
  //
  ensure_rb_result("v0.nan? == true", RbValue.float(NaN));
  //
  ensure_rb_result("v0 == Float::INFINITY", RbValue.float(Infinity));
  //
  ensure_rb_result("v0.nan? == true", RbValue.float("a"));
  // TODO: test for TypeError
  // too many arguments
  ensure_raise(ArgumentError, () => RbValue.float(1, rb_eval("3")) );


  // test("RbValue.get");
  // // too few arguments
  // //ensure_raise(BindingError, () => RbValue.get() );
  // // get top level constant
  // rb_eval("class A; end");
  // ensure_rb_result("v0 == A", RbValue.get("A"));
  // rb_eval("Object.send(:remove_const, :A)");
  // // get nested constant
  // rb_eval("class A; class B; end; end");
  // rb_eval("A::B::C = 3");
  // ensure_rb_result("v0 == A::B::C", RbValue.get("A::B::C"));
  // rb_eval("Object.send(:remove_const, :A)");
  // // get missing constant
  // A = RbValue.string("A")
  // RbValue.Object.send("const_get", A);
  // ensure_raise(RbError, () => RbValue.get("A") );
  // too many arguments
  //ensure_raise(BindingError, () => RbValue.float(1, rb_eval("3")) );


  test("RbValue.integer");
  // too few arguments
  ensure_raise(ArgumentError, () => RbValue.integer() );
  //
  ensure_rb_result("v0 == 0", RbValue.integer(0));
  //
  ensure_rb_result("v0 == 1", RbValue.integer(1));
  //
  ensure_rb_result("v0 == 1", RbValue.integer(1.0));
  //
  ensure_rb_result("v0 == 1", RbValue.integer(1.5));
  //
  ensure_rb_result("v0 == -2.0", RbValue.integer("-2.5"));
  // can't convert nan to integer
  //ensure_raise(RbError, () => RbValue.integer(NaN) );
  // can't convert infinity to integer
  //ensure_raise(RbError, () => RbValue.integer(Infinity) );
  // nan
  //ensure_raise(RbError, () => RbValue.integer("a") );
  //TODO: test for TypeError
  // too many arguments
  ensure_raise(ArgumentError, () => RbValue.integer(1, rb_eval("3")) );

  
  // test("RbValue.js_object");
  // // too few arguments
  // ensure_raise(ArgumentError, () => RbValue.js_object() );
  // // objects should be of type JSValue in rb environment
  // global.c = class {};
  // rb_eval("puts v0.inspect", RbValue.js_object(global.c));
  // ensure_rb_result("v0.is_a?(BRubyBridge::JSValue)", RbValue.js_object(global.c));
  // ensure_rb_result("v0.is_a?(BRubyBridge::JSValue)", RbValue.js_object(new global.c));
  // delete global.c;
  // // passed objects should be of correct js type
  // global.c = class {};
  // global.vc = RbValue.js_object(global.c);
  // global.vi = RbValue.js_object(new global.c);
  // ensure_rb_result("v0.instanceof(v1)", global.vi, global.vc);
  // delete global.c;
  // delete global.vc;
  // delete global.vi;
  // // passing same js object again should result in same JSValue
  // global.c = class {};
  // global.i = new c;
  // global.vi1 = RbValue.js_object(i);
  // global.vi2 = RbValue.js_object(i);
  // ensure_rb_result("v0.equal?(v1)", global.vi1, global.vi2);
  // ensure_rb_result("v0 == v1", global.vi1, global.vi2);
  // delete global.c;
  // delete global.i;
  // delete global.vi1;
  // delete global.vi2;
  // // passing different object sould result in different JSValue
  // global.c = class {};
  // global.i1 = RbValue.js_object(new global.c);
  // global.i2 = RbValue.js_object(new global.c);
  // ensure_rb_result_not("v0.equal?(v1)", global.i1, global.i2);
  // ensure_rb_result_not("v0 == v1", global.i1, global.i2);
  // delete global.c;
  // delete global.i1;
  // delete global.i2;
  // // call method of passed js object
  // global.c = class { constructor(n){ this.n = n; }; m(){ return n + 2; } };
  // global.i = RbValue.js_object(new global.c(3));
  // ensure_rb_result("v0.call(JSInterface.string('m')).to_float == 5", global.i);
  // delete global.c;
  // delete global.i;
  // // TODO: test for TypeError
  // // too many arguments
  // ensure_raise(ArgumentError, () => RbValue.js_object(rb_eval("3"), rb_eval("4")) );


  test("RbValue.Kernel");
  //
  ensure_rb_result("v0.equal?(Kernel)", RbValue.Kernel);


  test("RbValue.nil");
  //
  ensure_rb_result("v0 == nil", RbValue.nil);
  //
  ensure_rb_result_not("v0 == false", RbValue.nil);


  test("RbValue.Object");
  //
  ensure_rb_result("v0.equal?(Object)", RbValue.Object);
  //
  ensure_rb_result_not("v0 == Object.new", RbValue.Object);
  //
  ensure_rb_result_not("v0 == Kernel", RbValue.Object);

  
  test("RbValue.string");
  // no argument should make empty string
  ensure_rb_result("v0 == ''", RbValue.string());
  // pass empty string
  ensure_rb_result("v0 == ''", RbValue.string(''));
  // pass single character
  ensure_rb_result("v0 == 'a'", RbValue.string("a"));
  // pass multiple characters
  ensure_rb_result("v0 == 'abc'", RbValue.string("abc"));
  // 
  ensure_rb_result("v0 == '0'", RbValue.string("0"));
  // passing number should still result in string
  ensure_rb_result("v0 == '-2.5'", RbValue.string(-2.5));
  //
  ensure_raise(TypeError, () => RbValue.string(false) );
  //
  ensure_raise(TypeError, () => RbValue.string(null) );
  //
  ensure_raise(TypeError, () => RbValue.string(undefined) );
  //
  ensure_raise(TypeError, () => RbValue.string({}) );
  // too many arguments
  ensure_raise(ArgumentError, () => RbValue.string("a", rb_eval("'b'")) );


  test("RbValue.symbol");
  // too few arguments
  ensure_raise(ArgumentError, () => RbValue.symbol() );
  // pass empty string
  ensure_rb_result("v0 == :''", RbValue.symbol(''));
  // pass single character
  ensure_rb_result("v0 == :a", RbValue.symbol("a"));
  // pass multiple characters
  ensure_rb_result("v0 == :abc", RbValue.symbol("abc"));
  // 
  ensure_rb_result("v0 == :'0'", RbValue.symbol("0"));
  // passing number should still result in symbol
  ensure_rb_result("v0 == :'-2.5'", RbValue.symbol(-2.5));
  //
  ensure_raise(TypeError, () => RbValue.symbol(false) );
  //
  ensure_raise(TypeError, () => RbValue.symbol(null) );
  //
  ensure_raise(TypeError, () => RbValue.symbol(undefined) );
  //
  ensure_raise(TypeError, () => RbValue.symbol({}) );
  // too many arguments
  ensure_raise(ArgumentError, () => RbValue.symbol("a", rb_eval("'b'")) );


  test("RbValue.true");
  //
  ensure_rb_result("v0 == true", RbValue.true);
  //
  ensure_rb_result_not("v0 == false", RbValue.true);
  //
  ensure_rb_result_not("v0 == nil", RbValue.true);


  test("RbValue.prototype.send");
  // too few arguments
  ensure_raise(ArgumentError, () => rb_eval("Object").send() );
  // ensure passed arguments are valid
  global.a1 = rb_eval("2")
  global.a2 = rb_eval("{}")
  rb_eval("define_method(:m) { |a1, a2| $a1, $a2 = a1, a2; }");
  rb_eval("Object").send("m", global.a1, global.a2);
  ensure_rb_result("$a1.equal?(v0) && $a2.equal?(v1)", global.a1, global.a2);
  rb_eval("Object.undef_method(:m)");
  rb_eval("$a1, $a2 = nil");
  delete global.a1
  delete global.a2
  // ensure returned value is valid
  global.r = rb_eval("Object.new")
  rb_eval("define_method(:m) { v0; }", global.r);
  ensure_rb_result("v0.equal?(v1)", rb_eval("Object").send("m"), global.r)
  rb_eval("Object.undef_method(:m)");
  delete global.r
  // no arguments passed to rb method
  rb_eval("define_method(:m) { |*a| a; }");
  ensure_rb_result("v0 == []", rb_eval("Object").send("m"));
  rb_eval("Object.undef_method(:m)");
  // single argument passed to rb method
  global.a = rb_eval("2")
  rb_eval("define_method(:m) { |*a| a; }");
  ensure_rb_result("v0 == [v1]", rb_eval("Object").send("m", global.a), global.a);
  rb_eval("Object.undef_method(:m)");
  delete global.a
  // multiple arguments passed to rb method
  global.a1 = rb_eval("'2'")
  global.a2 = rb_eval("Object")
  global.a3 = rb_eval("Object.new")
  rb_eval("define_method(:m) { |*a| a; }");
  global.r = rb_eval("Object").send("m", global.a1, global.a2, global.a3)
  ensure_rb_result("v0 == [v1, v2, v3]", global.r, global.a1, global.a2, global.a3);
  rb_eval("Object.undef_method(:m)");
  delete global.a1
  delete global.a2
  delete global.a3
  delete global.r
  // second argument wrong type
  //ensure_raise(TypeError, () => rb_eval("Object").send("m", "a") );
  //ensure_raise(TypeError, () => rb_eval("Object").send("m", undefined) );
  //ensure_raise(TypeError, () => rb_eval("Object").send("m", []) );
  // ensure that passing the same RbValue again will result in the same rb object
  global.a = rb_eval("Object.new")
  rb_eval("$v = []")
  rb_eval("define_method(:m) { |a| $v << a; }");
  rb_eval("Object").send("m", global.a)
  rb_eval("Object").send("m", global.a)
  ensure_rb_result("$v[0].equal?($v[1])")
  rb_eval("$v = nil")
  rb_eval("Object.undef_method(:m)");
  delete global.a
  // ensure that passing a different RbValue will result in a different rb object
  rb_eval("$v = []")
  rb_eval("define_method(:m) { |a| $v << a; }");
  rb_eval("Object").send("m", rb_eval("Object.new"))
  rb_eval("Object").send("m", rb_eval("Object.new"))
  ensure_rb_result_not("$v[0].equal?($v[1])")
  ensure_rb_result_not("$v[0] == $v[1]")
  rb_eval("$v = nil")
  rb_eval("Object.undef_method(:m)");
  // ensure that returning the same rb object again will result in the same RbValue
  rb_eval("$r = Object.new")
  rb_eval("define_method(:m) { $r }");
  ensure_result( rb_eval("Object").send("m") === rb_eval("Object").send("m") )
  rb_eval("$r = nil")
  rb_eval("Object.undef_method(:m)");
  // ensure that returning a different rb object will result in a different RbValue
  rb_eval("define_method(:m) { Object.new }");
  ensure_result_not( rb_eval("Object").send("m") === rb_eval("Object").send("m") )
  ensure_result_not( rb_eval("Object").send("m") == rb_eval("Object").send("m") )
  rb_eval("Object.undef_method(:m)");
  // // catch rb error
  // rb_eval("define_method(:r) { raise }");
  // ensure_raise(RbError, () => rb_eval("Object").send("r") );
  // rb_eval("Object.undef_method(:r)");
  // // catch specific rb error class
  // rb_eval("define_method(:r) { raise ArgumentError }");
  // try
  // {
  //   rb_eval("Object").send("r");
  // }
  // catch (error)
  // {
  //   if (error instanceof JSError )
  //     pass();
  //   else
  //   {
  //     fail();
  //     throw error;
  //   }
  //   ensure_rb_result("v0 instanceof ArgumentError", error.rb_value)
  // }
  // rb_eval("Object.undef_method(:r)");
  // // catch specific rb error instance
  // e = rb_eval("new StandardError")
  // rb_eval("define_method(:r) { raise v0 }", e);
  // try
  // {
  //   rb_eval("Object").send("r");
  // }
  // catch (error)
  // {
  //   if (error instanceof JSError )
  //     pass();
  //   else
  //   {
  //     fail();
  //     throw error;
  //   }
  //   ensure_rb_result("v0.equal?(v1)", error.rb_value, e);
  // }
  // rb_eval("Object.undef_method(:r)");
  // // catch js error
  // t = function() { throw new Error; };
  // rb_eval("define_method(:r) { BRubyBridge.JSValue.global.call(BRubyBridge.JSValue.string('t')) }");
  // ensure_raise(Error, () => rb_eval('Object').send("r") );
  // delete t;
  // rb_eval("Object.undef_method(:r)");
  // // catch specific js error class
  // t = function() { throw new TypeError; };
  // rb_eval("define_method(:r) { BRubyBridge.JSValue.global.call(BRubyBridge.JSValue.string('t')) }");
  // ensure_raise(TypeError, () => rb_eval('Object').send("r") );
  // delete t;
  // rb_eval("Object.undef_method(:r)");
  // // catch same instance of js error
  // e = new TypeError;
  // t = function() { throw e; };
  // rb_eval("define_method(:r) { BRubyBridge.JSValue.global.call(BRubyBridge.JSValue.string('t')) }");
  // try
  // {
  //   rb_eval('Object').send("r");
  // }
  // catch (error)
  // {
  //   if (error instanceof TypeError )
  //     pass();
  //   else
  //   {
  //     fail();
  //     throw error;
  //   }
  //   ensure_rb_result("v0.equal?(v1)", error, e);
  // }
  // delete e;
  // delete t;
  // rb_eval("Object.undef_method(:r)");


  test("RbValue.prototype.to_boolean");
  //
  ensure_result( rb_eval("true").to_boolean() === true );
  //
  ensure_result_not( rb_eval("true").to_boolean() === 1 );
  //
  ensure_result_not( rb_eval("true").to_boolean() === false );
  //
  ensure_result( rb_eval("false").to_boolean() === false );
  //
  ensure_result( rb_eval("0").to_boolean() === true );
  //
  ensure_result( rb_eval("nil").to_boolean() === false );


  // test("RbValue.prototype.to_js_object");
  // // ensure returned value is valid
  // ensure_result( rb_eval("BRubyBridge::JSValue.global").to_js_object === global );
  // // ensure returned value is valid
  // global.o = rb_eval("BRubyBridge::JSValue['Number'].new(3)").to_js_object();
  // ensure_result( global.o.constructor === Number && global.o.valueOf() == 3 );
  // delete global.o;
  // // ensure valid returned value is consistent
  // global.v = rb_eval("BRubyBridge::JSValue['Number'].new(4)");
  // global.n1 = v.to_js_object();
  // global.n2 = v.to_js_object();
  // ensure_result( global.n1.constructor === Number && global.n1.valueOf() == 4 );
  // ensure_result( global.n1 === global.n2 );
  // delete global.v;
  // delete global.n1;
  // delete global.n2;
  //
  ensure_raise(TypeError, () => rb_eval("'0'").to_js_object() );
  //
  ensure_raise(TypeError, () => rb_eval("0").to_js_object() );
  //
  ensure_raise(TypeError, () => rb_eval("nil").to_js_object() );


  test("::to_number");
  //
  ensure_result( rb_eval("0").to_number() === 0 );
  //
  ensure_result( rb_eval("1").to_number() === 1 );
  //
  ensure_result( rb_eval("-1.5").to_number() === -1.5 );
  //
  ensure_result( isNaN(rb_eval("Float::NAN").to_number()) );
  //
  ensure_result( rb_eval("Float::INFINITY").to_number() === Infinity );
  //
  ensure_result( rb_eval("'2'").to_number() === 2 );
  //
  //ensure_raise(RbError, () => rb_eval("nil").to_number() );
  //
  //ensure_raise(RbError, () => rb_eval("true").to_number() );
  //
  //ensure_raise(RbError, () => rb_eval("[]").to_number() );
  

  test("::to_string");
  //
  ensure_result( rb_eval("''").to_string() === '' );
  //
  ensure_result( rb_eval("'a'").to_string() === 'a' );
  //
  ensure_result( rb_eval("'abc'").to_string() === 'abc' );
  //
  ensure_result( rb_eval("'0'").to_string() === '0' );
  //
  ensure_result( rb_eval("0").to_string() === '0' );
  //
  ensure_result( rb_eval("nil").to_string() === '' );
  //
  ensure_result( rb_eval("true").to_string() === 'true' );


  console.log("end-rb_value");
}