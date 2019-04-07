require_relative 'mrblib/pathfinder-agent-mruby/version'

MRuby::Gem::Specification.new('pathfinder-agent-mruby') do |spec|
  spec.license = 'MIT'
  spec.authors = 'Giovanni Sakti'
  spec.summary = 'Agent for Pathfinder container manager. Written in mruby.'
  spec.version = PathfinderAgentMruby::VERSION
  spec.bins    = ['pathfinder-agent-mruby']
  spec.add_dependency('mruby-print')
  spec.add_dependency('mruby-mtest')
end
