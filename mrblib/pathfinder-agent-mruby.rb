def __main__(argv)
  CONFIG = {
    PF_SERVER_SCHEME: ENV['PF_SERVER_SCHEME'] || 'http',
    PF_SERVER_ADDR: ENV['PF_SERVER_ADDR'] || 'localhost',
    PF_SERVER_PORT: ENV['PF_SERVER_PORT'] || 8080,
    PF_CLUSTER: ENV['PF_CLUSTER'] || 'default',
    PF_CLUSTER_PASSWORD: ENV['PF_CLUSTER_PASSWORD'] || 'pathfinder',
    LXD_SOCKET_PATH: ENV['LXD_SOCKET_PATH'] || '/var/snap/lxd/common/lxd/unix.socket',
  }

  pathfinder = Pathfinder::PathfinderNode.new(
    cluster_name: CONFIG[:PF_CLUSTER],
    scheme: CONFIG[:PF_SERVER_SCHEME],
    address: CONFIG[:PF_SERVER_ADDR],
    port: CONFIG[:PF_SERVER_PORT]
  )
  hostname = Socket.gethostname
  ipaddress = IPSocket.getaddress(hostname)
  node = Pathfinder::Node.new(hostname: hostname, ipaddress: ipaddress)
  lxd = MrubyLxd::Lxd.new(address: CONFIG[:LXD_SOCKET_PATH])

  root_command = Cmdr::Command.new(
    use: 'pathfinder-agent',
    short: 'Agent for Pathfinder container manager',
    long: "Pathfinder Agent
Ensure appropriate containers are running on the node in which this agent reside in.
",
    run: Proc.new { |command, argv|
      puts "Agent starting..."
      puts "\n"

      puts "Active configurations:"
      CONFIG.each do |k,v|
        puts "#{k}: #{v}"
      end
      puts "\n"

      while true do
        ok, _ = pathfinder.register(
          cluster_password: CONFIG[:PF_CLUSTER_PASSWORD],
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
