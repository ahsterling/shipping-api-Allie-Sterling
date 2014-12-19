# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)


Rails.application.load_tasks

task :wake_up => :environment do
  HTTParty.get("http://ishipit.herokuapp.com/search?package_info[weight]=50&package_info[dest_zip]=07901")
end
