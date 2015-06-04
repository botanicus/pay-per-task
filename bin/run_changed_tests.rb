#!/usr/bin/env ruby

unless ENV['previous_build_commit']
  abort "You must set up environment variable previous_build_commit."
end

def find_rakefile(dir)
  if File.exist?(File.join("#{dir}/Rakefile"))
    dir
  elsif dir != '.'
    find_rakefile(File.dirname(dir))
  end
end

files = %x{git diff --name-only #{ENV['previous_build_commit']} HEAD}.split("\n")
puts "~ Changed files: #{files.inspect}"
dirs = files.map! { |file| File.dirname(file) }.uniq
p dirs
changed_subprojects = dirs.map do |dir|
  find_rakefile(dir)
end.compact
puts "~ Changed subprojects: #{changed_subprojects.inspect}"

changed_subprojects.each do |subproject|
  puts "~ Running tests in #{subproject}"
  fork do
    puts "~ #{subproject}"
    puts %x{bundle exec rake test}
  end
end
