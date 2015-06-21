#!/usr/bin/env ruby

changed_subprojects = ARGV.dup

results = changed_subprojects.map do |subproject|
  puts "~ Running tests in #{subproject}"
  return_value = true
  Dir.chdir(subproject) do
    puts "~ #{subproject}"
    return_value = system './build.sh'
    unless subproject == changed_subprojects.last
      5.times { puts }
    end
  end
  [subproject, return_value]
end

exitstatus = 0
failed = Array.new

results.each do |(subproject, success)|
  unless success
    exitstatus = 1
    failed << subproject
    puts "Project #{subproject} failed."
  end
end

if exitstatus == 1
  puts "\n\n\nERROR"
  puts failed.join(', ')
end

exit exitstatus
