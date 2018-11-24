MRuby::Gem::Specification.new('bruby-bridge') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Rob Fors'
  spec.summary = 'exposes objects between ruby and javascript'
  spec.version = '0.0.0'

  #spec.add_dependency('mruby-regexp-pcre', :github => 'iij/mruby-regexp-pcre')
  #spec.add_dependency('mruby-eval')
  spec.add_dependency('mruby-metaprog')
  spec.add_dependency('mruby-enumerator')
  spec.add_dependency('mruby-array-ext')
  spec.add_dependency('mruby-object-ext')
  spec.add_dependency('mruby-kernel-ext')
  spec.add_dependency('mruby-string-ext')
  spec.add_dependency('esruby-esruby')
  spec.add_dependency('bruby-bridge-mruby-embind', :github => 'robfors/bruby-bridge-mruby-embind')
  
  spec.cxx.flags << "-std=c++11"
  
  spec.compilers.each do |c|
    c.flags << "--bind"
  end
  
  spec.rbfiles = []
  spec.rbfiles << "#{dir}/mrblib/array.rb"
  spec.rbfiles << "#{dir}/mrblib/module.rb"
  spec.rbfiles << "#{dir}/mrblib/bruby_bridge/override.rb"
  spec.rbfiles << "#{dir}/mrblib/bruby_bridge.rb"
  spec.rbfiles << "#{dir}/mrblib/bruby_bridge/js_error.rb"
  spec.rbfiles << "#{dir}/mrblib/bruby_bridge/rb_error.rb"
  spec.rbfiles << "#{dir}/mrblib/bruby_bridge/js_method.rb"
  spec.rbfiles << "#{dir}/mrblib/bruby_bridge/js_value.rb"
  spec.rbfiles << "#{dir}/mrblib/bruby_bridge/rb_value.rb"
  #spec.rbfiles = Dir.glob("#{dir}/mrblib/**/*.rb")



#spec.rbfiles = []

#spec.objs = []

  spec.objs = Dir.glob("#{dir}/src/**/*.cpp")
    .map { |f| objfile(f.relative_path_from(dir).pathmap("#{build_dir}/%X")) }

end
