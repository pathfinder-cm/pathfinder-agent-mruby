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
      mem_stats = sysinfo.mem_stats

      puts 'Sending metrics:'
      puts "Memory free: #{mem_stats[:mem_available]}"
      puts "Memory used: #{mem_stats[:mem_used]}"
      puts "Memory total: #{mem_stats[:mem_total]}"
      puts "\n"

      @pathfinder.store_metrics(metrics: {
        memory: {
          free: mem_stats[:mem_available],
          used: mem_stats[:mem_used],
          total: mem_stats[:mem_total],
        }
      })

      return true
    end
  end
end
