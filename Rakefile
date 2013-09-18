# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

RucPoc1::Application.load_tasks

if RUBY_PLATFORM['java']
  require 'warbler'
  Warbler::Task.new
  begin
    require 'torquebox-rake-support'
  rescue LoadError => ex
    puts "Failed to load the TorqueBox rake gem (torquebox-rake-support). Make sure it is available in your environment."
  end
end

# namespace :csv do
#   desc "Import data from CSV to database for populating db."
#   task :import do |file|
#     require 'csv'
#     data = CSV.read(file)
#     columns = data.remove(0)
#     unique_column_index = -1#The index of a column that's always unique per row in the spreadsheet
#     data.each do | row |
#       r = Record.find_or_initialize_by_unique_column(row[unique_column_index])
#       columns.each_with_index do | index, column_name |
#         r[column_name] = row[index]
#       end
#       r.save! rescue => e Rails.logger.error("Failed to save #{r.inspect}")
#     end
#   end
# end