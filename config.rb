# This file sets up the build environment for a webruby project.
Extraneous::Module::Specification.new do |spec|

  # set the path of the esruby project
  # all other paths specified in this config file will be expanded
  #   relative to this path
  spec.project_directory = File.dirname(__FILE__)

  spec.name = 'bruby-bridge'

  spec.build_mode = 'development'

  spec.output_path = 'bin/bruby-bridge.js'
  
  # list as many ruby source files as you want
  # keep in mind they will be executed in the order you list them
  spec.source(path: 'js/bruby_bridge/argument_error.js', type: 'java_script')
  spec.source(path: 'js/bruby_bridge/js_error.js', type: 'java_script')
  spec.source(path: 'js/bruby_bridge/out_of_memory_error.js', type: 'java_script')
  spec.source(path: 'js/bruby_bridge/rb_error.js', type: 'java_script')
  spec.source(path: 'js/bruby_bridge/stale_rb_value_error.js', type: 'java_script')
  spec.source(path: 'js/bruby_bridge/js_value.js', type: 'java_script')

  spec.source(path: 'rb/array.rb', type: 'ruby')
  spec.source(path: 'rb/module.rb', type: 'ruby')
  spec.source(path: 'rb/bruby_bridge.rb', type: 'ruby')
  spec.source(path: 'rb/bruby_bridge/js_error.rb', type: 'ruby')
  spec.source(path: 'rb/bruby_bridge/rb_error.rb', type: 'ruby')
  spec.source(path: 'rb/bruby_bridge/js_method.rb', type: 'ruby')
  spec.source(path: 'rb/bruby_bridge/rb_value.rb', type: 'ruby')
  
  spec.source(path: 'js/bruby_bridge/rb_value.js', type: 'java_script')
  spec.source(path: 'rb/bruby_bridge/js_value.rb', type: 'ruby')
  

  
  #dependency mruby-bruby-bridge-interface
  #  spec.license = 'MIT'
  #spec.author  = 'Rob Fors'
  #spec.summary = 'low level minimalist interface between the javascript and ruby environment'
  
end
