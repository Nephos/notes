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
note = ""
increment = true
title = time
subtitle = ""
tag = ""
action = nil

parsed = OptionParser.parse! do |p|
  p.banner = "Usage: notes [arguments]"
  p.on("-c=TAG", "--category=TAG", "Choose a title prefix (change the directory)") { |arg_tag| tag = arg_tag }
  p.on("-t=TITLE", "--title=TITLE", "Change de title (default = HOUR:MINUTE)") { |arg_title| title = arg_title }
  p.on("-s=SUBTITLE", "--subtitle=TITLE", "Change de subtitle (default none)") { |arg_subtitle| subtitle = arg_subtitle }
  p.on("-h", "--help", "Show this help") { puts p; exit }
  p.on("-P", "--show-path", "Show this current file path") { action = :show_path }
  p.on("-I", "--no-increment", "Do not increment the last note") { increment = false }
  p.unknown_args { |args| note = args.map(&.strip).join(" ").split("~~").map(&.strip).join("\n").strip }
end
action ||= note.empty? ? :show : :add

notes_path = File.expand_path(tag, notes_path) unless tag.empty?
file_path = File.expand_path("#{date}.md", notes_path)

case action
when :show_path
  puts "File: " + file_path
when :show
  puts File.read(file_path)
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
