JSValue =  BRubyBridge::JSValue
JSError =  BRubyBridge::JSError


puts "start-js_value"


test("::[]")
#
ensure_raise(ArgumentError) { JSValue[] }
#
ensure_raise(TypeError) { JSValue[2] } # TODO: not an error
#
js_eval("global.a = 2")
ensure_js_result("v0 === 2", JSValue["a"])
js_eval("delete a")
#
js_eval("global.a = {}")
js_eval("global.a.b = {}")
js_eval("global.a.b['c'] = 3")
ensure_js_result("v0 === 3", JSValue["a.b.c"])
js_eval("delete a")


test("::array")
#
ensure_raise(TypeError) { JSValue.array({}) }
#
ensure_raise(TypeError) { JSValue.array(2) }
#
ensure_js_result("v0 instanceof Array && v0.length == 0", JSValue.array([]))
#
o = js_eval("({})")
a = JSValue.array([o])
ensure_js_result("v0 instanceof Array && v0[0] == v1 && v0.length == 1", a, o)
o, a = nil
#
o1 = js_eval("({})")
o2 = js_eval("null")
o3 = js_eval("[]")
a = JSValue.array([o1, o2, o3])
ensure_js_result("v0 instanceof Array && v0.length == 3", a)
ensure_js_result("v0[0] == v1 && v0[1] == v2 && v0[2] == v3", a, o1, o2, o3)
o1, o2, o3, a = nil


test("::boolean")
#
ensure_raise(ArgumentError) { JSValue.boolean }
#
ensure_js_result("v0 === true", JSValue.boolean(true))
#
ensure_js_result("v0 === false", JSValue.boolean(false))
#
ensure_js_result("v0 === false", JSValue.boolean(nil))
#
ensure_js_result("v0 === true", JSValue.boolean({}))


test("::global")
#
ensure_js_result("v0 === global", JSValue.global)
#
ensure_js_result_not("v0 == {}", JSValue.global)


# # test("::global_namespace")
# # #
# # ensure_raise(ArgumentError) { JSValue.global_namespace }
# # #
# # ensure_raise(TypeError) { JSValue.global_namespace(2) }
# # #
# # ensure_raise(TypeError) { JSValue.global_namespace(JSValue.string("a")) }
# # #
# # js_eval("global.a = 2")
# # ensure_js_result("v0 === global.a", JSValue.global_namespace("a"))
# # js_eval("delete global.a")
# # #
# # js_eval("const A = 3")
# # ensure_js_result("v0 === A", JSValue.global_namespace("A"))
# # ensure_js_result_not("v0 === A", JSValue.global["A"])


test("::false")
#
ensure_js_result("v0 === false", JSValue.false)
ensure_js_result_not("v0 == null", JSValue.false)
#
ensure_raise(ArgumentError) { JSValue.false(2) }


test("::infinity")
#
ensure_js_result("v0 === Infinity", JSValue.infinity)
#
ensure_raise(ArgumentError) { JSValue.infinity(2) }


test("::nan")
#
ensure_js_result("isNaN(v0) == true", JSValue.nan)
#
ensure_raise(ArgumentError) { JSValue.nan(2) }


test("::null")
#
ensure_js_result("v0 === null", JSValue.null)
#
ensure_raise(ArgumentError) { JSValue.null(2) }


test("::number")
#
ensure_raise(ArgumentError) { JSValue.number }
#
ensure_js_result("v0 === 0", JSValue.number(0))
ensure_js_result_not("v0 === '0'", JSValue.number(0))
#
ensure_js_result("v0 === 1", JSValue.number(1))
#
ensure_js_result("v0 === 1", JSValue.number(1.0))
#
ensure_js_result("v0 === 1.5", JSValue.number(1.5))
ensure_js_result_not("v0 === 1", JSValue.number(1.5))
ensure_js_result_not("v0 === 2", JSValue.number(1.5))
#
ensure_js_result("v0 === -2", JSValue.number(-2))
#
ensure_js_result("v0 === -2.5", JSValue.number(-2.5))
#
ensure_js_result("v0 === -2.5", JSValue.number("-2.5"))
#
ensure_js_result("isNaN(v0) == true", JSValue.number(Float::NAN))
#
ensure_js_result("isFinite(v0) == false", JSValue.number(Float::INFINITY))
#
ensure_raise(TypeError) { JSValue.number("h") }
#
ensure_raise(TypeError) { JSValue.number("1 2") }


test("::object")
#
ensure_raise(TypeError) { JSValue.array(2) }
#
ensure_raise(TypeError) { JSValue.array({a: 2}) }
#
ensure_raise(TypeError) { JSValue.array({[] => JSValue.number(2) }) }
#
ensure_js_result("v0 instanceof Object", JSValue.object)
#
ensure_js_result("v0 instanceof Object", JSValue.object([]) )
#
v0 = js_eval("2")
v1 = JSValue.object({a: v0})
ensure_js_result("v1 instanceof Object && v1.a == v0", v0, v1)
v0, v1 = nil
#
v0 = js_eval("'2'")
v1 = js_eval("null")
v2 = js_eval("[]")
v3 = JSValue.object({:a => v0, 3 => v1, 'b' => v2})
ensure_js_result("v3 instanceof Object && v3.a == v0 && v3[3] == v1 && v3['b'] == v2", v0, v1, v2, v3)
v0, v1, v2, v3 = nil


test("::string")
#
ensure_js_result("v0 === ''", JSValue.string)
#
ensure_js_result("v0 === ''", JSValue.string(""))
#
ensure_js_result("v0 === 'b'", JSValue.string("b"))
#
ensure_js_result("v0 === 'abc'", JSValue.string("abc"))
#
ensure_js_result("v0 === 'abcd'", JSValue.string(:abcd))
#
ensure_raise(TypeError) { JSValue.string(2) }
#
ensure_raise(TypeError) { JSValue.string(nil) }
#
ensure_raise(TypeError) { JSValue.string(true) }


test("::true")
#
ensure_js_result("v0 === true", JSValue.true)
ensure_js_result_not("v0 instanceof Object", JSValue.true)
#
ensure_raise(ArgumentError) { JSValue.true(2) }


test("::undefined")
#
ensure_js_result("v0 === undefined", JSValue.undefined)
#
ensure_js_result_not("v0 === null", JSValue.undefined)
#
ensure_raise(ArgumentError) { JSValue.undefined(2) }


test("::window")
#
ensure_js_result("v0 === window", JSValue.window)
#
ensure_js_result_not("v0 == {}", JSValue.window)


test("#[]")
# well tested in #get
# too few arguments
ensure_raise(ArgumentError) { js_eval("({})")[] }
# key is String
o = js_eval("({a: 3})")
ensure_js_result("v0 == 3", o.get('a'))
o = nil


test("#[]=")
# well tested in #set
# key is String
o = js_eval("({})")
ensure_js_result("v0 == 3", o.set('a', js_eval("3")))
ensure_js_result("v0.a == 3", o)
o = nil


test("#+")
#
ensure_js_result("v0 == 6", (js_eval("4") + js_eval("2")))


test("#-")
#
ensure_js_result("v0 == -2", (js_eval("2") - js_eval("4")))


test("#*")
#
ensure_js_result("v0 == 8", (js_eval("4") * js_eval("2")))


test("#%")
#
ensure_js_result("v0 == 1", (js_eval("3") % js_eval("2")))


test("#**")
#
ensure_js_result("v0 == 9", (js_eval("3") ** js_eval("2")))


# test("#==")
# #
# ensure_result( js_eval("3") == js_eval("3") )
# #
# o = js_eval("({})")
# ensure_result( o == o )
# #
# ensure_result_not( js_eval("3") == js_eval("2") )
# #
# ensure_result_not( js_eval("({})") == js_eval("({})") )
# #
# ensure_result_not( js_eval("3") == 3 )
# #
# ensure_result_not( 3 == js_eval("3") )
# #
# ensure_result( js_eval("2") == js_eval("'2'") )


# test("#!=")
# #
# ensure_result( js_eval("3") != js_eval("2") )
# #
# ensure_result( js_eval("({})") != js_eval("({})") )
# #
# ensure_result( js_eval("3") != 3 )
# #
# ensure_result( 3 != js_eval("3") )
# #
# ensure_result_not( js_eval("3") != js_eval("3") )
# #
# o = js_eval("({})")
# ensure_result_not( o != o )


test("#===")
#
ensure_result( js_eval("3") === js_eval("3") )
#
ensure_result_not( js_eval("2") === js_eval("3") )
#
ensure_result_not( js_eval("3") === js_eval("'3'") )


test("#>")
#
ensure_result( js_eval("3") > js_eval("2") )
#
ensure_result_not( js_eval("2") > js_eval("3") )
#
ensure_result_not( js_eval("3") > js_eval("3") )


test("#>=")
#
ensure_result( js_eval("3") >= js_eval("2") )
#
ensure_result_not( js_eval("2") >= js_eval("3") )
#
ensure_result( js_eval("3") >= js_eval("3") )


test("#<")
#
ensure_result_not( js_eval("3") < js_eval("2") )
#
ensure_result( js_eval("2") < js_eval("3") )
#
ensure_result_not( js_eval("3") < js_eval("3") )


test("#<=")
#
ensure_result_not( js_eval("3") <= js_eval("2") )
#
ensure_result( js_eval("2") <= js_eval("3") )
#
ensure_result( js_eval("3") <= js_eval("3") )


test("#&")
#
ensure_js_result("v0 == 33", (js_eval("35") & js_eval("57")))


test("#|")
#
ensure_js_result("v0 == 59", (js_eval("35") | js_eval("57")))


test("#^")
#
ensure_js_result("v0 == 26", (js_eval("35") ^ js_eval("57")))


test("#~")
#
ensure_js_result("v0 == -36", (~ js_eval("35")))


test("#<<")
#
ensure_js_result("v0 == 1174405120", (js_eval("35") << js_eval("57")))


test("#>>")
#
ensure_js_result("v0 == 7", (js_eval("57") >> js_eval("35")))


test("#!")
#
ensure_result( !js_eval("true") == false )
#
ensure_result( !js_eval("false") == true )
#
ensure_result( !js_eval("({})") == false )
#
ensure_result( !!js_eval("({})") == true )
#
ensure_result( !js_eval("undefined") == true )


test("#call")
# too few arguments
ensure_raise(ArgumentError) { js_eval('global').call }
# property not found should raise JSError
ensure_raise(JSError) { js_eval('global').call(2) }
# passing js argument should be valid
a1 = js_eval("2")
a2 = js_eval("({})")
js_eval("global.f = function(a1, a2) { global.a1 = a1; global.a2 = a2; }")
js_eval('global').call("f", a1, a2)
ensure_js_result("a1 === v0 && a2 === v1", a1, a2)
js_eval("delete global.f")
js_eval("delete global.a1")
js_eval("delete global.a2")
a1, a2 = nil
# ensure that passing the same JSValue again will result in the same js object
a = js_eval("({})")
js_eval("global.v = []")
js_eval("global.f = function(a) { global.v.push(a); }")
js_eval('global').call("f", a)
js_eval('global').call("f", a)
ensure_js_result("v[0] === v[1]")
js_eval("delete global.v")
js_eval("delete global.f")
a = nil
# ensure that passing a different JSValue will result in a different js object
js_eval("global.v = []")
js_eval("global.f = function(a) { global.v.push(a); }")
js_eval('global').call("f", js_eval("({})"))
js_eval('global').call("f", js_eval("({})"))
ensure_js_result_not("v[0] == v[1]")
js_eval("delete global.v")
js_eval("delete global.f")
# passing rb argument should of type RbValue in js
c = Class.new
js_eval("global.f = function(a1, a2) { global.a1 = a1; global.a2 = a2; }")
js_eval('global').call(js_eval("'f'"), c, c.new)
ensure_js_result("global.a1 instanceof BRubyBridge.RbValue")
ensure_js_result("global.a2 instanceof BRubyBridge.RbValue")
js_eval("delete global.f")
js_eval("delete global.a1")
js_eval("delete global.a2")
c = nil
# passing same rb argument again should result in same RbValue
i = Class.new.new
js_eval("global.f = function(a1, a2) { global.a1 = a1; global.a2 = a2; }")
js_eval('global').call(js_eval("'f'"), i, i)
ensure_js_result("global.a1 === global.a2")
js_eval("delete global.f")
js_eval("delete global.a1")
js_eval("delete global.a2")
i = nil
# passing different rb argument should result in different RbValue
c = Class.new
i1 = c.new
i2 = c.new
js_eval("global.f = function(a1, a2) { global.a1 = a1; global.a2 = a2; }")
js_eval('global').call(js_eval("'f'"), i1, i2)
ensure_js_result_not("global.a1 === global.a2")
ensure_js_result_not("global.a1 == global.a2")
js_eval("delete global.f")
js_eval("delete global.a1")
js_eval("delete global.a2")
c, i1, i2 = nil
# returning js value should be valid
r = js_eval("({})")
js_eval("global.f = function() { return v0; }", r)
ensure_js_result("v0 === v1", js_eval('global').call("f"), r)
js_eval("delete global.f")
r = nil
# ensure that returning the same js object again will result in the same JSValue
js_eval("global.o = {}")
js_eval("global.f = function() { return global.o; }")
ensure_result( js_eval('global').call("f").equal?(js_eval('global').call("f")) )
js_eval("delete global.o")
js_eval("delete global.f")
# ensure that returning a different js object will result in a different JSValue
js_eval("global.f = function() { return {}; }")
ensure_result_not( js_eval('global').call("f").equal?(js_eval('global').call("f")) )
js_eval("delete global.f")
# returning rb value should be valid
v = Object.new
js_eval("global.f = function() { return v0; }", v)
r = js_eval('global').call(js_eval("'f'"))
ensure_result( v.equal?(r) )
js_eval("delete global.f")
v, r = nil
# returning rb value should be valid type
js_eval("global.f = function() { return BRubyBridge.RbValue.Object; }", v)
ensure_result( js_eval('global').call(js_eval("'f'")).equal?(Object) )
js_eval("delete global.f")
# returning same RbValue again should result in same rb value
v = Object.new
js_eval("global.f = function() { return v0; }", v)
r1 = js_eval('global').call(js_eval("'f'"))
r2 = js_eval('global').call(js_eval("'f'"))
ensure_result( v.equal?(r1) )
ensure_result( r1.equal?(r2) )
js_eval("delete global.f")
v, r1, r2 = nil
# returning different RbValue should result in different rb value
v1 = Object.new
js_eval("global.f = function() { return v0; }", v1)
r1 = js_eval('global').call(js_eval("'f'"))
ensure_result( r1.equal?(v1) )
js_eval("delete global.f")
v2 = Object.new
js_eval("global.f = function() { return v0; }", v2)
r2 = js_eval('global').call(js_eval("'f'"))
ensure_result( r2.equal?(v2) )
js_eval("delete global.f")
ensure_result_not( r1.equal?(r2) )
ensure_result_not( r1 == r2 )
v1, v2, r1, r2 = nil
# no arguments to js function, key is a rb String
js_eval("global.e = function(...a) { return a; }")
ensure_js_result("v0 instanceof Array && v0.length == 0", js_eval('global').call("e"))
js_eval("delete global.e")
# key is a rb Symbol
js_eval("global.e = function(...a) { return a; }")
ensure_js_result("v0 instanceof Array && v0.length == 0", js_eval('global').call(:e))
js_eval("delete global.e")
# key is a rb Numeric
o = js_eval("({ 3: function(...a) { return a; } })")
ensure_js_result("v0 instanceof Array && v0.length == 0", o.call(3))
o = nil
# key is a js object
k = js_eval("Symbol()")
js_eval("global[v0] = function(...a) { return a; }", k)
ensure_js_result("v0 instanceof Array && v0.length == 0", js_eval('global').call(k))
js_eval("delete global[v0]", k)
k = nil
# single argument passed to js function
a = js_eval("2")
js_eval("global.e = function(...a) { return a; }")
r = js_eval('global').call("e", a)
ensure_js_result("v0 instanceof Array && v0.length == 1 && v0[0] === v1", r, a)
js_eval("delete global.e")
a, r = nil
# multiple arguments passed to js function
a1 = js_eval("2")
a2 = js_eval("'3'")
a3 = js_eval("({a: 2})")
js_eval("global.e = function(...a) { return a; }")
r = js_eval('global').call("e", a1, a2, a3)
ensure_js_result("v0 instanceof Array && v0.length == 3", r)
ensure_js_result("v0[0] === v1 && v0[1] === v2 && v0[2] == v3", r, a1, a2, a3)
js_eval("delete global.e")
a1, a2, a3, r = nil
#catch js error
js_eval("global.t = function() { throw new Error; }")
ensure_raise(JSError) { js_eval('global').call("t") }
js_eval("delete global.t")
# catch specific js error class
js_eval("global.t = function() { throw new TypeError; }")
begin
  js_eval('global').call("t")
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 instanceof TypeError", js_error.js_value)
else
  fail
end
js_eval("delete global.t")
# catch specific js error instance
e = js_eval("new Error")
js_eval("global.t = function() { throw v0; }", e)
begin
  JSValue.global.call(JSValue.string("t"))
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === v1", js_error.js_value, e)
else
  fail
end
js_eval("delete global.t")
#catch js error not an instance of Error
js_eval("global.e = 2")
js_eval("global.t = function() { throw global.e; }")
begin
  js_eval('global').call("t")
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === global.e", js_error.js_value)
else
  fail
end
js_eval("delete global.e")
js_eval("delete global.t")
# catch js error that is an object but not an instance of Error
js_eval("global.e = []")
js_eval("global.t = function() { throw global.e; }")
begin
  js_eval('global').call("t")
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === global.e", js_error.js_value)
else
  fail
end
js_eval("delete global.e")
js_eval("delete global.t")
# catch rb error
define_method(:r) { raise StandardError }
js_eval("global.r = function() { BRubyBridge.RbValue.Object.send('r'); }")
ensure_raise(StandardError) { js_eval('global').call("r") }
Object.undef_method(:r)
js_eval("delete global.r")
# catch specific rb error class
e = Class.new(StandardError)
define_method(:r) { raise e }
js_eval("global.r = function() { BRubyBridge.RbValue.Object.send('r'); }")
ensure_raise(e) { js_eval('global').call("r") }
Object.undef_method(:r)
js_eval("delete global.r")
e = nil
# catch same instance of rb error
ec = Class.new(StandardError)
$e = ec.new
define_method(:r) { raise $e }
js_eval("global.r = function() { BRubyBridge.RbValue.Object.send('r'); }")
begin
  js_eval('global').call("r")
rescue ec => rb_error
  ensure_result(rb_error.is_a?(ec))
  ensure_result(rb_error.equal?($e))
else
  fail
end
js_eval("delete global.r")
Object.undef_method(:r)


test("#delete")
#
ensure_raise(ArgumentError) { js_eval("({})").delete }
#
o = js_eval("({a: 2})")
ensure_js_result("'a' in v0 && v0.a == 2", o)
ensure_result( o.delete('a') == true )
ensure_js_result_not("'a' in v0", o)
o = nil
#
k = js_eval("Symbol()")
o = js_eval("({[v0]: 2})", k)
ensure_js_result("v1 in v0", o, k)
ensure_js_result("v0[v1] == 2", o, k)
ensure_js_result("v1 in v0 && v0[v1] == 2", o, k)
ensure_result( o.delete(k) == true )
ensure_js_result_not("v1 in v0", o, k)
o = nil
#
js_eval("global.a = 2")
ensure_js_result("global.a == 2")
ensure_result( JSValue.global.delete('a') )
ensure_js_result("global.a == undefined")
#
a = js_eval("[0,0,0,5]")
ensure_js_result("v0[3] == 5", a)
ensure_result( a.delete(3) == true )
ensure_js_result("v0[3] == undefined", a)
a = nil
#
ensure_raise(ArgumentError) { js_eval("({})").delete("a", "b") }


# test("#eql?")
# #
# ensure_result( js_eval("3").eql?(js_eval("3")) )
# #
# o = js_eval("({})")
# ensure_result( o == o )
# #
# ensure_result_not( js_eval("3").eql?(js_eval("2")) )
# #
# ensure_result_not( js_eval("({})").eql?(js_eval("({})")) )
# #
# ensure_result_not( js_eval("3").eql?(3) )
# #
# ensure_result_not( 3.eql?(js_eval("3")) )


test("#false?")
#
ensure_result( js_eval("false").false? )
#
ensure_result_not( js_eval("true").false? )
#
ensure_result_not( js_eval("({})").false? )
#
ensure_result_not( js_eval("2").false? )


test("#get")
#
ensure_raise(ArgumentError) { js_eval("({})").get }
# key is String
o = js_eval("({a: 3})")
ensure_js_result("v0 == 3", o.get('a'))
o = nil
# key is Symbol
o = js_eval("({a: 3})")
ensure_js_result("v0 == 3", o.get(:a))
o = nil
# key is js string
o = js_eval("({a: 3})")
ensure_js_result("v0 == 3", o.get(js_eval("'a'")))
o = nil
# key is Integer
o = js_eval("[0,0,5]")
ensure_js_result("v0 == 5", o.get(2))
o = nil
# key is JSValue
k = js_eval("Symbol()")
o = js_eval("({[v0]: 3})", k)
ensure_js_result("v0 == 3", o.get(k))
k, o = nil
# return null
o = js_eval("({a: null})")
ensure_js_result("v0 == null", o.get('a'))
o = nil
# return undefined
o = js_eval("({a: undefined})")
ensure_js_result("v0 == undefined", o.get('a'))
o = nil
# get non existent property
o = js_eval("({})")
ensure_js_result("v0 == undefined", o.get('a'))
o = nil
# passing two empty js objects should result in the same key
k1 = js_eval("({})")
k2 = js_eval("({})")
o = js_eval("({})")
js_eval("v0[v1] = 3", o, k1)
js_eval("v0[v1] = 5", o, k2)
ensure_js_result("v0 == 5", o.get(k1))
ensure_js_result("v0 == 5", o.get(k2))
k, o = nil
# ensure that passing the same JSValue again will result in the same js object
js_eval("global.k = Symbol()")
o = js_eval("({[global.k]: 3})")
k = js_eval("k")
ensure_js_result("v0 == 3", o.get(k))
ensure_js_result("v0 == 3", o.get(k))
js_eval("delete global.k")
k, o = nil
# ensure that passing a different JSValue will result in different js objects
js_eval("global.k1 = Symbol()")
js_eval("global.k2 = Symbol()")
o = js_eval("({[global.k1]: 3, [global.k2]: 5})")
k1 = js_eval("global.k1")
k2 = js_eval("global.k2")
ensure_js_result("v0 == 3", o.get(k1))
ensure_js_result("v0 == 5", o.get(k2))
js_eval("delete global.k1")
js_eval("delete global.k2")
k1, k2, o = nil
# ensure that returning the same js object again will result in the same JSValue
js_eval("global.p = {}")
o = js_eval("({a: global.p})")
p = js_eval("global.p")
ensure_js_result("v0 === global.p", p)
ensure_js_result("v0 === global.p", o.get('a'))
ensure_js_result("v0 === global.p", o.get('a'))
ensure_js_result("v0 === global.p", o.get('a'))
js_eval("delete global.p")
o, p = nil
# ensure that returning a different js object will result in different JSValues
js_eval("global.p1 = {}")
js_eval("global.p2 = {}")
o = js_eval("({a: global.p1, b: global.p2})")
ensure_js_result("v0 === global.p1", o.get('a'))
ensure_js_result("v0 === global.p2", o.get('b'))
js_eval("delete global.p1")
js_eval("delete global.p2")
o = nil
# returning same RbValue again should result in same rb value
v = Object.new
o = js_eval("({a: v0})", v)
ensure_result(o.get('a').equal?(v))
ensure_result(o.get('a').equal?(v))
v, o = nil
# returning different RbValue should result in different rb value
v1 = Object.new
v2 = Object.new
o = js_eval("({a: v0, b: v1})", v1, v2)
ensure_result_not(o.get('a').equal?(o.get('b')))
v1, v2, o = nil
# catch js error
o = js_eval("({ get p() { throw new Error; } })")
ensure_raise(JSError) { o.get('p') }
o = nil
# catch specific js error class
o = js_eval("({ get p() { throw new TypeError; } })")
begin
  o.get('p')
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 instanceof TypeError", js_error.js_value)
else
  fail
end
o = nil
# catch specific js error instance
e = js_eval("new Error")
o = js_eval("({ get p() { throw v0; } })", e)
begin
  o.get('p')
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === v1", js_error.js_value, e)
else
  fail
end
e, o = nil
# catch js error not an instance of Error
e = js_eval("2")
o = js_eval("({ get p() { throw v0; } })", e)
begin
  o.get('p')
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === v1", js_error.js_value, e)
else
  fail
end
e, o = nil
# catch js error that is an object but not an instance of Error
e = js_eval("({})")
o = js_eval("({ get p() { throw v0; } })", e)
begin
  o.get('p')
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === v1", js_error.js_value, e)
else
  fail
end
e, o = nil
#catch rb error
define_method(:m) { raise StandardError }
o = js_eval("({ get p() { BRubyBridge.RbValue.Object.send('m'); } })")
ensure_raise(StandardError) { o.get('p') }
Object.undef_method(:m)
o = nil
# catch specific rb error class
e = Class.new(StandardError)
define_method(:m) { raise e }
o = js_eval("({ get p() { BRubyBridge.RbValue.Object.send('m'); } })")
ensure_raise(e) { o.get('p') }
Object.undef_method(:m)
o, e = nil
# catch same instance of rb error
ec = Class.new(StandardError)
e = ec.new
define_method(:m) { raise e }
o = js_eval("({ get p() { BRubyBridge.RbValue.Object.send('m'); } })")
begin
  o.get('p')
rescue ec => rb_error
  ensure_result(rb_error.is_a?(ec))
  ensure_result(rb_error.equal?(e))
else
  fail
end
Object.undef_method(:m)
# too many arguments, second would definitely be wrong type
ensure_raise(ArgumentError) { js_eval("({})").get("a", "b") }
# too many arguments, second type could be could be accepted by error
ensure_raise(ArgumentError) { js_eval("({})").get("a", js_eval("2")) }


test("#has?")
# too few arguments
ensure_raise(ArgumentError) { js_eval("({})").has? }
# pass String as key
ensure_result( js_eval("({a: 2})").has?('a') == true )
ensure_result( js_eval("({a: 2})").has?('b') == false )
# pass Symbol as key
ensure_result( js_eval("({a: 2})").has?(:a) == true )
ensure_result( js_eval("({a: 2})").has?(:b) == false )
# pass Integer as key
ensure_result( js_eval("[0,0,5]").has?(2) == true )
ensure_result( js_eval("[0,0,5]").has?(3) == false )
# pass JSValue as key
k1 = js_eval("Symbol()")
k2 = js_eval("Symbol()")
o = js_eval("({[v0]: 5})", k1)
ensure_result( o.has?(k1) == true )
ensure_result( o.has?(k2) == false )
k1, k2, o = nil
# too many arguments
ensure_raise(ArgumentError) { js_eval("({})").has?("a", js_eval("'b'")) }


test("#in")
# too few arguments
ensure_raise(ArgumentError) { js_eval("'a'").in }
# pass String as key
ensure_result( js_eval("'a'").in(js_eval("({a: 2})")) == true )
ensure_result( js_eval("'b'").in(js_eval("({a: 2})")) == false )
# too many arguments
ensure_raise(ArgumentError) { js_eval("'a'").in(js_eval("({a: 2})"), js_eval("({b: 2})")) }


test("#instanceof")
# too few arguments
ensure_raise(ArgumentError) { js_eval("'a'").instanceof }
#
c = js_eval("(class {})")
i = js_eval("new v0", c)
ensure_result( i.instanceof(c) == true )
c, i = nil
# not instance of
c1 = js_eval("(class {})")
c2 = js_eval("(class {})")
i = js_eval("new v0", c1)
ensure_result_not( i.instanceof(c2) == true )
c1, c2, i = nil
# rescue not a constructor error
ensure_raise(JSError) { js_eval("'a'").instanceof(js_eval("2")) }
# too many arguments
ensure_raise(ArgumentError) { js_eval("'a'").instanceof(js_eval("String"), js_eval("String")) }


test("#nan?")
#
ensure_result( js_eval("NaN").nan? == true )
#
ensure_result( js_eval("2").nan? == false )
#
ensure_result( js_eval("'a'").nan? == false )
#
ensure_result( js_eval("'NaN'").nan? == false )
# too many arguments
ensure_raise(ArgumentError) { js_eval("2").nan?(js_eval("3")) }


test("#new")
# no arguments
c = js_eval("(class {})")
i = c.new
ensure_js_result("v0 instanceof v1", i, c)
c, i = nil
# forgot an argument
c = js_eval("(class { constructor(p) { this.p = p; } })")
i = c.new
ensure_js_result("v0 instanceof v1", i, c)
ensure_js_result("v0.p === undefined", i)
c, i = nil
# pass 1 argument
c = js_eval("(class { constructor(p) { this.p = p; } })")
p = js_eval("({})")
i = c.new(p)
ensure_js_result("v0 instanceof v1", i, c)
ensure_js_result("v0.p === v1", i, p)
c, i = nil
# pass 3 arguments
c = js_eval("(class { constructor(...p) { this.p = p; } })")
p1 = js_eval("({})")
p2 = js_eval("Symbol()")
p3 = c
i = c.new(p1, p2, p3)
ensure_js_result("v0 instanceof v1", i, c)
ensure_js_result("v0.p[0] === v1, v0.p[1] === v2, v0.p[2] === v3", i, p1, p2, p3)
c, i = nil
# catch error: not a constructor
ensure_raise(JSError) { js_eval("({})").new }
# can not return null
c = js_eval("(class { constructor() { return null; } })")
ensure_js_result("v0 instanceof Object", c.new)
ensure_js_result_not("v0 == null", c.new)
c = nil
# can not return undefined
c = js_eval("(class { constructor() { return undefined; } })")
ensure_js_result("v0 instanceof Object", c.new)
c = nil
# ensure that passing the same JSValue again will result in the same js object
c = js_eval("(class { constructor(a) { return a; } })")
p = js_eval("({})")
i1 = c.new(p)
i2 = c.new(p)
ensure_js_result("v0 === v1", i1, i2)
c, p, i1, i2 = nil
# ensure that passing a different JSValue will result in different js objects
c = js_eval("(class { constructor(a) { return a; } })")
p1 = js_eval("({})")
p2 = js_eval("({})")
i1 = c.new(p1)
i2 = c.new(p2)
ensure_js_result_not("v0 === v1", i1, i2)
c, p, i1, i2 = nil
# catch js error
c = js_eval("(class { constructor() { throw new Error; } })")
ensure_raise(JSError) { c.new }
c = nil
# catch specific js error class
c = js_eval("(class { constructor() { throw new TypeError; } })")
begin
  c.new
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 instanceof TypeError", js_error.js_value)
else
  fail
end
c = nil
# catch specific js error instance
e = js_eval("new Error")
c = js_eval("(class { constructor() { throw v0; } })", e)
begin
  c.new
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === v1", js_error.js_value, e)
else
  fail
end
e, c = nil
# catch js error not an instance of Error
e = js_eval("2")
o = js_eval("({ get p() { throw v0; } })", e)
begin
  o.get('p')
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === v1", js_error.js_value, e)
else
  fail
end
e, o = nil
# catch js error that is an object but not an instance of Error
e = js_eval("({})")
c = js_eval("(class { constructor() { throw v0; } })", e)
begin
  c.new
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === v1", js_error.js_value, e)
else
  fail
end
e, c = nil
#catch rb error
define_method(:m) { raise StandardError }
c = js_eval("(class { constructor() { BRubyBridge.RbValue.Object.send('m'); } })")
ensure_raise(StandardError) { c.new }
Object.undef_method(:m)
c = nil
# catch specific rb error class
e = Class.new(StandardError)
define_method(:m) { raise e }
c = js_eval("(class { constructor() { BRubyBridge.RbValue.Object.send('m'); } })")
ensure_raise(e) { c.new }
Object.undef_method(:m)
c, e = nil
# catch same instance of rb error
ec = Class.new(StandardError)
e = ec.new
define_method(:m) { raise e }
c = js_eval("(class { constructor() { BRubyBridge.RbValue.Object.send('m'); } })")
begin
  c.new
rescue ec => rb_error
  ensure_result(rb_error.is_a?(ec))
  ensure_result(rb_error.equal?(e))
else
  fail
end
Object.undef_method(:m)


test("#null?")
#
ensure_result( js_eval("null").null? )
#
ensure_result_not( js_eval("true").null? )
#
ensure_result_not( js_eval("({})").null? )
#
ensure_result_not( js_eval("'null'").null? )
#
ensure_result_not( js_eval("undefined").null? )


test("#number?")
#
ensure_result( js_eval("2").number? )
#
ensure_result( js_eval("-2.5").number? )
#
ensure_result( js_eval("NaN").number? )
#
ensure_result_not( js_eval("true").number? )
#
ensure_result_not( js_eval("({})").number? )
#
ensure_result_not( js_eval("'2'").number? )
#
ensure_result_not( js_eval("undefined").number? )


# test("#post_decrement")
# #
# n = js_eval("3")
# ensure_js_result("v0 == 3", n.post_decrement)
# ensure_js_result("v0 == 2", n)
# n = nil
# #
# ensure_raise(ArgumentError) { js_eval("3").post_decrement(2) }
# #
# ensure_raise(JSError) { js_eval("'a'").post_decrement }


# test("#post_increment")
# #
# n = js_eval("3")
# ensure_js_result("v0 == 3", n.post_increment)
# ensure_js_result("v0 == 4", n)
# n = nil
# #
# ensure_raise(ArgumentError) { js_eval("3").post_increment(2) }
# #
# ensure_raise(JSError) { js_eval("'a'").post_increment }


# test("#pre_decrement")
# #
# n = js_eval("3")
# ensure_js_result("v0 == 2", (n.pre_decrement))
# ensure_js_result("v0 == 2", n)
# n = nil
# #
# ensure_raise(ArgumentError) { js_eval("3").pre_decrement(2) }
# #
# ensure_raise(JSError) { js_eval("'a'").pre_decrement }


# test("#pre_increment")
# #
# n = js_eval("3")
# ensure_js_result("v0 == 3", (n.pre_decrement))
# ensure_js_result("v0 == 3", n)
# n = nil
# #
# ensure_raise(ArgumentError) { js_eval("3").pre_decrement(2) }
# #
# ensure_raise(JSError) { js_eval("'a'").pre_decrement }


test("#set")
#
ensure_raise(ArgumentError) { js_eval("({})").set }
#
ensure_raise(ArgumentError) { js_eval("({})").set('a') }
# key is String
o = js_eval("({})")
ensure_js_result("v0.a === undefined", o)
ensure_js_result("v0 === 3", o.set('a', js_eval("3")))
ensure_js_result("v0.a === 3", o)
o = nil
# key is Symbol
o = js_eval("({})")
ensure_js_result("v0.a === undefined", o)
ensure_js_result("v0 === 3", o.set(:a, js_eval("3")))
ensure_js_result("v0.a === 3", o)
o = nil
# key is js string
# key is Symbol
o = js_eval("({})")
ensure_js_result("v0.a === undefined", o)
ensure_js_result("v0 === 3", o.set(js_eval("'a'"), js_eval("3")))
ensure_js_result("v0.a === 3", o)
o = nil
# key is Integer
o = js_eval("[0,0,5]")
ensure_js_result("v0[2] === 5", o)
ensure_js_result("v0 === 3", o.set(2, js_eval("3")))
ensure_js_result("v0[2] === 3", o)
o = nil
# key is JSValue
o = js_eval("[0,0,5]")
k = js_eval("Symbol()")
ensure_js_result("v0[v1] === undefined", o, k)
ensure_js_result("v0 === 3", o.set(k, js_eval("3")))
ensure_js_result("v0[v1] === 3", o, k)
k, o = nil
# passing two empty js objects should result in the same key
k1 = js_eval("({})")
k2 = js_eval("({})")
o = js_eval("({})")
ensure_js_result("v0[v1] === undefined", o, k1)
ensure_js_result("v0 === 3", o.set(k1, js_eval("3")))
ensure_js_result("v0[v1] === 3", o, k1)
ensure_js_result("v0 === 5", o.set(k2, js_eval("5")))
ensure_js_result("v0[v1] === 5", o, k1)
ensure_js_result("v0[v1] === 5", o, k2)
k1, k2, o = nil
# ensure that passing the same JSValue again will result in the same key
js_eval("global.k = Symbol()")
k = js_eval("global.k")
o = js_eval("({})")
ensure_js_result("v0[v1] === undefined", o, k)
ensure_js_result("v0 === 3", o.set(k, js_eval("3")))
ensure_js_result("v0[v1] === 3", o, k)
ensure_js_result("v0 === 5", o.set(k, js_eval("5")))
ensure_js_result("v0[v1] === 5", o, k)
js_eval("delete global.k")
k, o = nil
# ensure that passing a different JSValue will result in different key
js_eval("global.k1 = Symbol()")
js_eval("global.k2 = Symbol()")
k1 = js_eval("global.k1")
k2 = js_eval("global.k2")
o = js_eval("({})")
ensure_js_result("v0[v1] === undefined", o, k1)
ensure_js_result("v0[v1] === undefined", o, k2)
ensure_js_result("v0 === 3", o.set(k1, js_eval("3")))
ensure_js_result("v0 === 5", o.set(k2, js_eval("5")))
ensure_js_result("v0[v1] === 3", o, k1)
ensure_js_result("v0[v1] === 5", o, k2)
js_eval("delete global.k1")
js_eval("delete global.k2")
k1, k2, o = nil
# ensure that passing the same JSValue again will result in the same js value
o = js_eval("({})")
v = js_eval("({})")
ensure_js_result("v0.a === undefined", o)
ensure_js_result("v0.b === undefined", o)
ensure_js_result("v0 === v1", o.set('a', v), v)
ensure_js_result("v0 === v1", o.set('b', v), v)
ensure_js_result("v0.a === v0.b", o)
o, v = nil
# ensure that passing a different JSValue will result in different js value
o = js_eval("({})")
v1 = js_eval("({})")
v2 = js_eval("({})")
ensure_js_result("v0.a === undefined", o)
ensure_js_result("v0.b === undefined", o)
ensure_js_result("v0 === v1", o.set('a', v1), v1)
ensure_js_result("v0 === v1", o.set('b', v2), v2)
ensure_js_result_not("v0.a === v0.b", o)
o, v1, v2 = nil
# catch js error
o = js_eval("({ set p(v) { throw new Error; } })")
ensure_raise(JSError) { o.set('p', js_eval("3")) }
o = nil
# catch specific js error class
o = js_eval("({ set p(v) { throw new TypeError; } })")
begin
  o.set('p', js_eval("3"))
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 instanceof TypeError", js_error.js_value)
else
  fail
end
o = nil
# catch specific js error instance
e = js_eval("new Error")
o = js_eval("({ set p(v) { throw v0; } })", e)
begin
  o.set('p', js_eval("3"))
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === v1", js_error.js_value, e)
else
  fail
end
e, o = nil
# catch js error not an instance of Error
e = js_eval("2")
o = js_eval("({ set p(v) { throw v0; } })", e)
begin
  o.set('p', js_eval("3"))
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === v1", js_error.js_value, e)
else
  fail
end
e, o = nil
# catch js error that is an object but not an instance of Error
e = js_eval("({})")
o = js_eval("({ set p(v) { throw v0; } })", e)
begin
  o.set('p', js_eval("3"))
rescue JSError => js_error
  ensure_result(js_error.is_a?(JSError))
  ensure_js_result("v0 === v1", js_error.js_value, e)
else
  fail
end
e, o = nil
#catch rb error
define_method(:m) { raise StandardError }
o = js_eval("({ set p(v) { BRubyBridge.RbValue.Object.send('m'); } })")
ensure_raise(StandardError) { o.set('p', js_eval("3")) }
Object.undef_method(:m)
o = nil
# catch specific rb error class
e = Class.new(StandardError)
define_method(:m) { raise e }
o = js_eval("({ set p(v) { BRubyBridge.RbValue.Object.send('m'); } })")
ensure_raise(e) { o.set('p', js_eval("3")) }
Object.undef_method(:m)
o, e = nil
# catch same instance of rb error
ec = Class.new(StandardError)
e = ec.new
define_method(:m) { raise e }
o = js_eval("({ set p(v) { BRubyBridge.RbValue.Object.send('m'); } })")
begin
  o.set('p', js_eval("3"))
rescue ec => rb_error
  ensure_result(rb_error.is_a?(ec))
  ensure_result(rb_error.equal?(e))
else
  fail
end
Object.undef_method(:m)
# too many arguments
ensure_raise(ArgumentError) { js_eval("({})").set("a", js_eval("3"), js_eval("5")) }


test("#string?")
#
ensure_result( js_eval("'a'").string? )
#
ensure_result( js_eval("'abc'").string? )
#
ensure_result( js_eval("'2'").string? )
#
ensure_result( js_eval("''").string? )
#
ensure_result_not( js_eval("true").string? )
#
ensure_result_not( js_eval("({})").string? )
#
ensure_result_not( js_eval("undefined").string? )


test("#to_boolean")
#
ensure_result( js_eval("false").to_boolean == false )
#
ensure_result( js_eval("true").to_boolean == true )
#
ensure_result( js_eval("undefined").to_boolean == false )
#
ensure_result( js_eval("null").to_boolean == false )
#
ensure_result( js_eval("0").to_boolean == false )
#
ensure_result( js_eval("'0'").to_boolean == true )


test("#to_float")
#
ensure_result( js_eval("0").to_float == 0 )
#
ensure_result( js_eval("0.5").to_float == 0.5 )
#
ensure_result( js_eval("1").to_float == 1 )
#
ensure_result( js_eval("-0.5").to_float == -0.5 )
#
ensure_result( js_eval("-0.5").to_float != -1.5 )
#
ensure_result( js_eval("'1'").to_float == 1 )
#
ensure_result( js_eval("'-1.5'").to_float == -1.5 )
#
ensure_result( js_eval("'1 5'").to_float.nan? )
#
ensure_result( js_eval("undefined").to_float.nan? )
#
ensure_result( js_eval("null").to_float == 0 )
#
ensure_result( js_eval("'a'").to_float.nan? )
#
ensure_result( js_eval("NaN").to_float.nan? )
#
ensure_result( js_eval("Infinity").to_float == Float::INFINITY )


test("#to_integer")
#
ensure_result( js_eval("0").to_integer == 0 )
#
ensure_result( js_eval("0.5").to_integer == 0 )
#
ensure_result( js_eval("1").to_integer == 1 )
#
ensure_result( js_eval("-0.5").to_integer == 0 )
#
ensure_result( js_eval("'1'").to_integer == 1 )
#
ensure_result( js_eval("'-1.5'").to_integer == -1 )
#
ensure_result( js_eval("null").to_integer == 0 )
#
ensure_raise(FloatDomainError) { js_eval("'1 5'").to_integer }
#
ensure_raise(FloatDomainError) { js_eval("undefined").to_integer }
#
ensure_raise(FloatDomainError) { js_eval("'a'").to_integer }
#
ensure_raise(FloatDomainError) { js_eval("NaN").to_integer }
#
ensure_raise(FloatDomainError) { js_eval("Infinity").to_integer }


test("#to_string")
#
ensure_result( js_eval("'0'").to_string == "0" )
#
ensure_result( js_eval("'-0.5'").to_string == "-0.5" )
#
ensure_result( js_eval("-0.5").to_string == "-0.5" )
#
ensure_result( js_eval("'1'").to_string == "1" )
#
ensure_result( js_eval("'a'").to_string == "a" )
#
ensure_result( js_eval("'abc'").to_string == "abc" )
#
ensure_result( js_eval("undefined").to_string == "undefined" )
#
ensure_result( js_eval("null").to_string == "null" )
#
ensure_result( js_eval("({})").to_string == "[object Object]" )


test("#true?")
#
ensure_result( js_eval("true").true? )
#
ensure_result_not( js_eval("false").true? )
#
ensure_result_not( js_eval("({})").true? )
#
ensure_result_not( js_eval("2").true? )


test("#typeof")
#
ensure_result( js_eval("'a'").typeof == "string" )
#
ensure_result( js_eval("3").typeof == "number" )
#
ensure_result( js_eval("Symbol()").typeof == "symbol" )
#
ensure_result( js_eval("({})").typeof == "object" )
#
ensure_result( js_eval("(function(){})").typeof == "function" )
#
ensure_result( js_eval("undefined").typeof == "undefined" )
#
ensure_result( js_eval("null").typeof == "object" )
# too many arguments
ensure_raise(ArgumentError) { js_eval("'a'").typeof(js_eval("String")) }


test("#undefined?")
#
ensure_result( js_eval("undefined").undefined? )
#
ensure_result_not( js_eval("null").undefined? )
#
ensure_result_not( js_eval("false").undefined? )
#
ensure_result_not( js_eval("({})").undefined? )
#
ensure_result_not( js_eval("'undefined'").undefined? )


puts("end-js_value")