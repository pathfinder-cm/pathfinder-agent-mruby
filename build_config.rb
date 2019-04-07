def gem_config(conf)
  conf.gem core: 'mruby-eval'
  conf.gem core: 'mruby-sleep'
  conf.gem github: 'iij/mruby-mtest'
  conf.gem File.expand_path(File.dirname(__FILE__))
end

MRuby::Build.new do |conf|
  toolchain :clang

  conf.enable_bintest
  conf.enable_debug
  conf.enable_test

  gem_config(conf)
end
