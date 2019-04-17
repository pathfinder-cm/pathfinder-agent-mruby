require_relative 'mrblib/pathfinder-agent-mruby/version'

MRuby::Gem::Specification.new('pathfinder-agent-mruby') do |spec|
  spec.license = 'MIT'
  spec.authors = 'Giovanni Sakti'
  spec.summary = 'Agent for Pathfinder container manager. Written in mruby.'
  spec.version = PathfinderAgentMruby::VERSION
  spec.bins    = ['pathfinder-agent-mruby']
  spec.add_dependency('mruby-print')
  spec.add_dependency('mruby-mtest')
  spec.add_dependency('mruby-random')
  spec.add_dependency('mruby-require')
  spec.add_dependency('mruby-socket')
  spec.add_dependency('mruby-lxd', '>= 0.1.0', github: 'giosakti/mruby-lxd')
  spec.add_dependency('mruby-pathfinder-client', '>= 0.1.0', github: 'pathfinder-cm/mruby-pathfinder-client')
  spec.add_dependency('mruby-cmdr', '>= 0.1.0', github: 'giosakti/mruby-cmdr')
end
