# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

# puts 'ROLES'
# YAML.load(ENV['ROLES']).each do |role|
#   Role.find_or_create_by_name({ :name => role }, :without_protection => true)
#   puts 'role: ' << role
# end
# puts 'DEFAULT USERS'
# user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
# puts 'user: ' << user.name
# user.add_role :admin


# puts 'CREATING ROLES'
# Role.create([
#   { :name => 'admin' }, 
#   { :name => 'user' }, 
#   { :name => 'VIP' }
# ], :without_protection => true)
puts 'SETTING UP DEFAULT USER LOGIN'
user_h = User.create! :name => 'Henry Hund', :username => "henry", :email => 'henryhund@gmail.com', :password => 'pleasechangeme', :password_confirmation => 'pleasechangeme'
puts 'New user created: ' << user_h.name
user_hh = User.create! :name => 'Hank Hund', :username => "hank", :email => 'henry@lorious.com', :password => 'pleasechangeme', :password_confirmation => 'pleasechangeme'
puts 'New user created: ' << user_hh.name
user = User.create! :name => 'First User',:username => "team", :email => 'user@example.com', :password => 'pleasechangeme', :password_confirmation => 'pleasechangeme'
puts 'New user created: ' << user.name
# user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'pleasechangeme', :password_confirmation => 'pleasechangeme'
# puts 'New user created: ' << user2.name
user.add_role :admin
user_h.add_role :admin
user_hh.add_role :admin
# user2.add_role :VIP