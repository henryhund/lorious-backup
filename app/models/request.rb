class Request < ActiveRecord::Base
  attr_accessible :email, :expertise, :help_needed, :max_rate, :name, :time_needed, :status, :horizon, :request_type, :profile_id, :finished

  # validates :name, :presence => {:message => 'You have to tell us who you are!'}
  # validates :email, :presence => {:message => 'We need to know how to reach you!'}
  # validates :help_needed, :presence => {:message => 'We need to know how to help you!'}

  belongs_to :profile

end
