class Request < ActiveRecord::Base
  attr_accessible :email, :expertise, :help_needed, :max_rate, :name, :time_needed, :status
end
