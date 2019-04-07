def __main__(argv)
  root_command = PathfinderAgentMruby::Command.new(
    use: 'pathfinder-agent',
    short: 'Agent for Pathfinder container manager',
    long: "Pathfinder Agent
Ensure appropriate containers are running on the node in which this agent reside in.
"
  )
  root_command.execute(argv)
end
