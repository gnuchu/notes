require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'fileutils'

old_area = ""
output = "# AWS Notes\n"
output = "## Services\n"

def flatten(str)
  str.gsub(/\s+/, '')
end

def writeheader(service, area)
  file = "pages/#{flatten(area.downcase)}/#{flatten(service.downcase)}.md"
  open(file, "w") do |f|
    f << "# #{service} (#{area})\n"
    f << "\n\n\n\n"
    f << "---\n"
    f << "[Home](../../aws.md)"
  end
end

def processNewService(area, service)
  file = "pages/#{flatten(area.downcase)}/#{flatten(service.downcase)}.md"
  FileUtils.touch(file)
  return "  - [#{service}](#{file})\n"
end

count = 0
output_dir = 'output/' + Time.now.strftime("%Y%m%d%H%m%S").to_s
FileUtils.mkdir_p(output_dir)
start_dir = Dir.pwd
Dir.chdir(output_dir)

inputfile = "#{start_dir}/input/aws.txt"

File.open(inputfile).each do |line|
  count += 1

  (service, area) = line.split(/\|/)
  
  service.strip!
  area.strip!

  if area == old_area
    output += processNewService(area, service)
    writeheader(service, area)
  else
    old_area = area
    output += "\n### #{area}\n"
    dir = "pages/#{flatten(area.downcase.strip)}"

    FileUtils.mkdir_p(dir)

    output += processNewService(area, service)

    writeheader(service, area)
  end
end

open("aws.md", "w") do |f|
  f << output
end

Dir.chdir(start_dir)
