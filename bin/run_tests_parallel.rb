#!/usr/bin/env ruby

pids = changed_subprojects.map do |subproject|
  puts "~ Running tests in #{subproject}"
  pid = fork do
    return_value = true
    Dir.chdir(subproject) do
      puts "~ #{subproject}"
      return_value = system './build.sh'
      unless subproject == changed_subprojects.last
        5.times { puts }
      end
    end
    exit(return_value ? 0 : 1)
  end
  [subproject, pid]
end

exitstatus = 0
failed = Array.new

pids.each do |(subproject, pid)|
  Process.waitpid(pid)
  unless $?.exitstatus == 0
    exitstatus = 1
    failed << subproject
  end
  puts "Project #{subproject} finished with #{$?.exitstatus}."
end

if exitstatus == 1
  puts "==== ERROR ====="
  p failed
end

exit exitstatus
