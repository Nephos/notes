require "./notes/*"
require "file_utils"

# Usage
#
# ./notes blah blah blah :: blah blah on the second line

notes_path = ENV["NOTES_PATH"]? || File.expand_path(".local/notes", ENV["HOME"])
date = Time.now.to_s("%F %A")
time = Time.now.to_s("%R")
file_path = File.expand_path("#{date}.md", notes_path)
note = ARGV.join(" ").split("::").map(&.strip).join("\n")

if note.empty?
  puts File.read(file_path)
else
  Dir.mkdir notes_path rescue nil
  File.open(file_path, "a") do |f|
    f <<
      "# #{time}
#{note}

"
  end
end
