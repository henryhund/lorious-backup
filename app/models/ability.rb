class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    else
        if Rails.env.production?
          can :create, Request
          can :create, Profile
          can :manage, Profile, :user_id => user.id 
          can :create, User
          can :manage, User, :id => user.id
          can :finish_registration, :users
          can :edit_incomplete_registration, :users
          can :chat_prep, :chat
          can :scheduled_chat, :chat
          can :chat_end, :chat
          can :test, :chat
          can :report_listener, :chat
        else
          # can :manage, :all
          # can :create, Request
          
          can :create, Profile
          can :manage, Profile, :user_id => user.id 
          
          can :read, User
          can :create, User
          can :manage, User, :id => user.id
          # can :finish_registration, :users
          # can :edit_incomplete_registration, :users
          
          # can :chat_prep, :chat
          can :scheduled_chat, :chat

          can :chat_end, :chat
          can :test, :chat
          can :report_listener, :chat
          
          # can :show, Profile
        end
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
