require "./notes/*"
require "file_utils"
require "option_parser"

# Usage
#
# ./notes blah blah blah :: blah blah on the second line

notes_path = ENV["NOTES_PATH"]? || File.expand_path(".local/notes", ENV["HOME"])
date = Time.now.to_s("%F-%A")
time = Time.now.to_s("%R")
file_path = File.expand_path("#{date}.md", notes_path)
note = ""
action = :add
increment = true
title = time

parsed = OptionParser.parse! do |p|
  p.banner = "Usage: notes [arguments]"
  p.on("-t=TITLE", "--title=TITLE", "Change de title (default = HOUR:MINUTE)") { |arg_title| title = arg_title }
  p.on("-h", "--help", "Show this help") { puts p; exit }
  p.on("-P", "--show-path", "Show this current file path") { puts file_path; exit }
  p.on("-I", "--no-increment", "Do not increment the last note") { increment = false }
  p.unknown_args { |args| note = args.map(&.strip).join(" ").split("::").map(&.strip).join("\n").strip }
end
action = :show if note.empty?

case action
when :show
  puts File.read(file_path)
when :add
  Dir.mkdir notes_path rescue nil
  data = if increment && !File.read(file_path).match(/^# #{title}$/m).nil?
           "
#{note}

"
         else
           "# #{title}
#{note}

"
         end
  puts data
  File.open(file_path, "a") do |f|
    f << data
  end
end
