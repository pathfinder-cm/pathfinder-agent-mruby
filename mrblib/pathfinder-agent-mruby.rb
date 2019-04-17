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
    short: 'Agents for Pathfinder container manager',
    long: "Pathfinder Agent
Contains node agent and metrics agent.
",
  )

  start_command = Cmdr::Command.new(
    use: 'start',
    short: 'Specify agent to start',
    long: 'Specify agent to start'
  )
  root_command.add_command(start_command)

  start_node_command = Cmdr::Command.new(
    use: 'node',
    short: 'Start node agent',
    long: 'Start node agent, manage containers lifecycle of this particular node',
    run: Proc.new { |command, argv|
      puts "Node agent starting..."
      puts "\n"

      print_configuration
      pathfinder = register_agent(pathfinder: pathfinder, node: node)
      node_agent = PathfinderAgentMruby::NodeAgent.new(pathfinder: pathfinder, lxd: lxd)
      node_agent.run
    }
  )
  start_command.add_command(start_node_command)

  start_metrics_command = Cmdr::Command.new(
    use: 'metrics',
    short: 'Start metrics agent',
    long: 'Start metrics agent, periodically send this node metrics to pathfinder',
    run: Proc.new { |command, argv|
      puts "Metrics agent starting..."
      puts "\n"

      print_configuration
      pathfinder = register_agent(pathfinder: pathfinder, node: node)
      metrics_agent = PathfinderAgentMruby::MetricsAgent.new(pathfinder: pathfinder)
      metrics_agent.run
    }
  )
  start_command.add_command(start_metrics_command)

  root_command.execute(argv)
end

def print_configuration
  puts "Active configurations:"
  CONFIG.each do |k,v|
    puts "#{k}: #{v}"
  end
  puts "\n"
end

def register_agent(pathfinder:, node:)
  authentication_token = nil
  if File.exist?("#{ENV['HOME']}/.pathfinder/node-token")
    File.foreach("#{ENV['HOME']}/.pathfinder/node-token") do |line|
      authentication_token = line
    end
  end

  if authentication_token.nil? || authentication_token == ''
    while true do
      ok, authentication_token = pathfinder.register(
        cluster_password: CONFIG[:PF_CLUSTER_PASSWORD],
        node: node
      )

      if ok
        puts "Agent successfully registered!"
        Dir.mkdir("#{ENV['HOME']}/.pathfinder")
        File.open("#{ENV['HOME']}/.pathfinder/node-token", 'w') do |f|
          f.write authentication_token
        end
        break
      else
        retry_wait = 60 + (1..10).to_a
        puts "Registration failure, retrying in #{retry_wait} seconds"
        sleep retry_wait
      end
    end
  end

  Pathfinder::PathfinderNode.new(
    cluster_name: CONFIG[:PF_CLUSTER],
    authentication_token: authentication_token,
    scheme: CONFIG[:PF_SERVER_SCHEME],
    address: CONFIG[:PF_SERVER_ADDR],
    port: CONFIG[:PF_SERVER_PORT]
  )
end
