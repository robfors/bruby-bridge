task :clean do
  rm_rf "test/temporary/build"
end

task :full_build_test do
  mkdir_p "test/temporary/www"
  cp "test/index.html", "test/temporary/www/index.html"
  mkdir_p "test/temporary/gems"
  mkdir_p "test/temporary/bruby-bridge-mruby-embind"
  rm_rf "test/temporary/gems/bruby-bridge-mruby-embind"
  cp_r "../bruby-bridge-mruby-embind/", "test/temporary/gems/bruby-bridge-mruby-embind"
  sh "esruby build test/config.rb"
end

task :build_test do
  mkdir_p "test/temporary/www"
  cp "test/index.html", "test/temporary/www/index.html"
  sh "esruby build test/config.rb"
end

task :run_test => :build_test do
  sh "ruby -run -e httpd #{__dir__ + "/test/temporary/www"} -p 2222"
end

task :full_run_test => :full_build_test do
  sh "ruby -run -e httpd #{__dir__ + "/test/temporary/www"} -p 2222"
end