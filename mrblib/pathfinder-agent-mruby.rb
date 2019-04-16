def __main__(argv)
  PATHFINDER_SCHEME = 'http'
  PATHFINDER_ADDRESS = 'localhost'
  PATHFINDER_PORT = 3000
  CLUSTER_NAME = 'default'
  CLUSTER_PASSWORD = 'pathfinder'

  pathfinder = Pathfinder::PathfinderNode.new(
    cluster_name: CLUSTER_NAME,
    scheme: PATHFINDER_SCHEME,
    address: PATHFINDER_ADDRESS,
    port: PATHFINDER_PORT
  )
  hostname = Socket.gethostname
  ipaddress = IPSocket.getaddress(hostname)
  node = Pathfinder::Node.new(hostname: hostname, ipaddress: ipaddress)
  lxd = MrubyLxd::Lxd.new

  root_command = Cmdr::Command.new(
    use: 'pathfinder-agent',
    short: 'Agent for Pathfinder container manager',
    long: "Pathfinder Agent
Ensure appropriate containers are running on the node in which this agent reside in.
",
    run: Proc.new { |command, argv|
      puts "Agent starting..."

      while true do
        ok, _ = pathfinder.register(
          cluster_password: CLUSTER_PASSWORD,
          node: node
        )

        if ok
          puts "Agent successfully registered!"
          break
        else
          retry_wait = 60 + (1..10).to_a
          puts "Registration failure, retrying in #{retry_wait} seconds"
          sleep retry_wait
        end
      end

      agent = PathfinderAgentMruby::Agent.new(pathfinder: pathfinder, lxd: lxd)
      agent.run
    }
  )
  root_command.execute(argv)
end
