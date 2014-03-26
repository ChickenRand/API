# Load the existing files
Dir["spec/**/*.rb"].each do |spec_file|
  if File.basename(spec_file) != 'init.rb' and File.basename(spec_file) != 'helper.rb'
    next if File.dirname(spec_file).include?("fixtures")
    puts "% Using spec file : #{spec_file}"
    require File.expand_path(spec_file)
  end
end