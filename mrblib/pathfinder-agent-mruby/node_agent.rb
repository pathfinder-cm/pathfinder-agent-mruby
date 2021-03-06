module PathfinderAgentMruby
  class NodeAgent
    def initialize(pathfinder:, lxd:)
      @pathfinder = pathfinder
      @lxd = lxd
    end

    def run
      while true
        delay = 5 + (1..5).to_a.sample
        sleep(delay)
        process
      end
    end

    def process
      # Fetch container from server
      _, scheduled_containers = @pathfinder.get_scheduled_containers

      # Fetch container from local daemon
      _, local_containers = @lxd.get_containers

      # Compare between server and local containers
      # Do action as necessary
      scheduled_containers.each do |scheduled_container|
        case scheduled_container.status
        when "SCHEDULED"
          provision_container(scheduled_container, local_containers)
        when "SCHEDULE_DELETION"
          delete_container(scheduled_container, local_containers)
        end
      end

      # TODO: Get a list of orphaned containers

      return true
    end

    def provision_container(scheduled_container, local_containers)
      local_container = local_containers.select{ |c|
        c.hostname == scheduled_container.hostname 
      }.first

      if !local_container
        puts "Creating container..."

        container_source = MrubyLxd::ContainerSource.new(
          type: 'image',
          server: 'https://cloud-images.ubuntu.com/releases',
          protocol: 'simplestreams',
          source_alias: scheduled_container.image
        )
        ok = @lxd.create_container(
          hostname: scheduled_container.hostname,
          container_source: container_source
        )
        if !ok
          @pathfinder.mark_container_as_provision_error(container: scheduled_container)
          puts "Error during container creation."
          return false
        end

        @lxd.start_container(hostname: scheduled_container.hostname)

        ipaddress = @lxd.get_container_address(hostname: scheduled_container.hostname)
        @pathfinder.update_ipaddress(container: 
          Pathfinder::Container.new(hostname: scheduled_container.hostname, ipaddress: ipaddress)
        )

        @pathfinder.mark_container_as_provisioned(container: scheduled_container)

        puts "Container created"
      else
        @pathfinder.mark_container_as_provisioned(container: scheduled_container)

        puts "Container already exist"
      end

      return true
    end

    def delete_container(scheduled_container, local_containers)
      local_container = local_containers.select{ |c|
        c.hostname == scheduled_container.hostname 
      }.first

      if local_container
        ok = @lxd.delete_container(hostname: scheduled_container.hostname)
        if !ok
          puts "Error during container deletion"
          return false
        end

        @pathfinder.mark_container_as_deleted(container: scheduled_container)

        puts "Container deleted"
      else
        @pathfinder.mark_container_as_deleted(container: scheduled_container)

        puts "Container already deleted"
      end

      return true
    end
  end
end
