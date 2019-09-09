require 'fileutils'

old_area = ""
output = "# AWS Notes\n"
output = "## Services\n"


def flatten(str)
  str.gsub!(/\s+/, '')
end

File.open('aws.txt').each do |line|
  (service, area) = line.split(/\|/)
  flatten(service)
  flatten(area)

  if area == old_area
    file = "pages/#{area}/#{service.downcase}.md"
    FileUtils.touch(file)
    output += "  - [#{service}](#{file})\n"
  else
    old_area = area
    output += "\n### #{area}\n"
    
    dir = "pages/#{area.downcase}"
    FileUtils.mkdir_p(dir)

    file = "pages/#{area}/#{service.downcase}.md"
    FileUtils.touch(file)

    output += "  - [#{service}](#{file})\n"
  end
end

open("aws.md", "w") do |f|
  f << output
end
