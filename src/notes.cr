require "./notes/*"
require "file_utils"
require "option_parser"

# Usage
#
# ./notes blah blah blah ~~ blah blah on the second line

t = Time.now
notes_path = ENV["NOTES_PATH"]? || File.expand_path(".local/notes", ENV["HOME"])
date = t.to_s("%F-%A")
minute = ((t.minute / 15) * 15).to_s.rjust 2, '0'
hour = t.hour.to_s.rjust 2, '0'
time = "#{hour}:#{minute}"

increment = true
title = time
subtitle = ""
tag = ""
action = nil
file_path = ""
file_name = "#{date}"
read = :argv

parsed = OptionParser.parse! do |p|
  p.banner = "Usage: notes [arguments]"
  p.on("-c=TAG", "--category=TAG", "Choose a title prefix (change the directory)") { |arg_tag| tag = arg_tag }
  p.on("-t=TITLE", "--title=TITLE", "Change de title (default = HOUR:MINUTE)") { |arg_title| title = arg_title }
  p.on("-s=SUBTITLE", "--subtitle=TITLE", "Change de subtitle (default none)") { |arg_subtitle| subtitle = arg_subtitle }
  p.on("-I", "--no-increment", "Do not increment the last note (new title)") { increment = false }
  p.on("-P", "--show-path", "Show this current file's path") { action = :show_path }
  p.on("-p=PATH", "--path=PATH", "Choose the file's path") { |path| file_path = path }
  p.on("-D", "--show-directory", "Show this current file's directory") { action = :show_dir }
  p.on("-d=PATH", "--directory=PATH", "Choose the file's directory") { |path| notes_path = path }
  p.on("-N", "--show-name", "Show this current file's name") { action = :show_name }
  p.on("-n=NAME", "--name=NAME", "Choose the file's name") { |name| file_name = name }
  p.on("--stdin", "Read on stdin") { read = :stdin }
  p.on("-w", "--week", "Show the last week of notes") { action = :show_week }
  p.on("-h", "--help", "Show this help") { puts p; exit }
end

note = read == :stdin ? STDIN.gets_to_end : ARGV.map(&.strip).join(" ")
note = note.split("~~").map(&.strip).join("\n").strip
action = note.empty? ? :show : :add if action.nil?

notes_path = File.expand_path(tag, notes_path) unless tag.empty?
file_path = File.expand_path("#{file_name}.md", notes_path) if file_path.empty?

case action
when :show_path
  puts "File path: " + file_path
when :show_dir
  puts "File directory: " + notes_path
when :show_name
  puts "File name: " + file_name
when :show
  puts (File.read(file_path) rescue "nothing published yet")
when :show_week
  paths = Dir.entries(notes_path)
  paths.sort!
  paths.select! do |path|
    date = path.match /^(\d{4}-\d{2}-\d{2})-\w+\.md$/
    Time.parse(date[1], "%F") > (Time.new - 14.days) if date
  end
  paths.reverse! unless STDOUT.tty?
  paths.each_with_index do |path, i|
    title = path.chomp(".md")
    puts "#{title}"
    puts "="*title.size
    puts
    puts File.read(File.expand_path(path, notes_path))
    puts "\n\n\n\n" unless i == paths.size - 1
  end
when :add
  Dir.mkdir notes_path rescue nil
  data = if increment && File.exists?(file_path) && !File.read(file_path).match(/^# #{title}$/m).nil?
           ""
         else
           "\n# #{title}"
         end
  data = data.strip unless File.exists?(file_path)
  data += "\n## #{subtitle}" unless subtitle.empty?
  data += "\n#{note}\n"

  puts data
  File.open(file_path, "a") do |f|
    f << data
  end
end
