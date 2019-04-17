require 'open3'

BIN_PATH = File.join(File.dirname(__FILE__), "../mruby/bin/pathfinder-agent-mruby")

assert('hello') do
  output, status = Open3.capture2(BIN_PATH)

  assert_true status.success?, "Process did not exit cleanly"
  assert_include output, "Agent for Pathfinder container manager"
end

assert('version') do
  output, status = Open3.capture2(BIN_PATH, "version")

  assert_true status.success?, "Process did not exit cleanly"
  assert_include output, "v0.1.0"
end
