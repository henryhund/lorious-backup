desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  

end

task :send_reminders => :environment do
  User.send_reminders
end