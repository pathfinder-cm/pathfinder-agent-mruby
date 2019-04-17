module PathfinderAgentMruby
  class MetricsAgent
    def initialize(pathfinder:)
      @pathfinder = pathfinder
    end

    def run
      while true
        delay = 5 + (1..5).to_a.sample
        sleep(delay)
        process
      end
    end

    def process
      sysinfo = Sysinfo::Factory.create

      # Note: We got memory in KB
      mem_stats = sysinfo.mem_stats

      puts 'Sending metrics:'
      puts "Memory free: #{mem_stats[:mem_available] / 1000} MB"
      puts "Memory used: #{mem_stats[:mem_used] / 1000} MB"
      puts "Memory total: #{mem_stats[:mem_total] / 1000} MB"
      puts "\n"

      @pathfinder.store_metrics(metrics: {
        memory: {
          free: mem_stats[:mem_available] / 1000,
          used: mem_stats[:mem_used] / 1000,
          total: mem_stats[:mem_total] / 1000,
        }
      })

      return true
    end
  end
end
