class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)
    if user.has_role? :need_poster
        can :create, Need
        can :update, Need, Need.all do |need|
            need.need_stage.admin_incoming? && need.user_id_posted_by == user.id
        end
        can :read, Need, :user_id_posted_by => user.id
        can :read, Need, :is_public => true
        can :manage, Expense, :need => { :user_id_posted_by => user.id }
        can :read, Contribution, :need => { :user_id_posted_by => user.id }
    end
    if user.has_role? :church_admin
        can :read, Need, :user_id_church_admin => user.id
        can :read, Need, :is_public => true
        can :update, Need, :user_id_church_admin => user.id
        can :set_is_public, Need, :user_id_church_admin => user.id
        can :manage, Expense, :need => { :user_id_church_admin => user.id }
        can :manage, Update # this needs to be only for the appropriate ones
        can :read, Contribution, :need => { :user_id_church_admin => user.id }
    end
    if user.has_role? :super_admin
        can :update, User
    end
    if user.has_role? :validation_partner
        can :read, User
    end
    if user.has_role? :pending_church_admin
        can :agree_to_church_admin_agreement, User
    end
    if user.has_role? :pending_need_poster
        can :agree_to_need_poster_agreement, User
    end


    can :read, Need do |need|
        at_least_one = false
        need.contributions.each do |contribution|
            at_least_one = true if contribution.user_id == user.id && contribution.succeded? && !contribution.reimbursed?
        end
        at_least_one
    end

    # This didnt work... will just lock it at the view level for now.
    # can :create, Contribution do |contribution|
    #     contribution.need.is_public
    # end

    can :create, Contribution

    can :read, Expense
    can :read, Update

    can :read, Contribution, :user_id => user.id
    can :read, Need, :is_public => true
    can :create, User
    can :update, User, :id => user.id
    can :read, User
    can :create_charge, Need

    can :read, Skill

    can :new, TimeContribution
    can :create, TimeContribution # this should only be if signed in...
    can :manage, TimeContribution


    # can :manage, :all
    
    # def initialize(user)
    #     # Define abilities for the passed in user here.
    #     user ||= User.new # guest user (not logged in)
    #     # a signed-in user can do everything
    #     if user.has_role? :admin
    #      # an admin can do everything
    #       can :manage, :all
    #     elsif user.has_role? :editor
    #       # an editor can do everything to documents and reports
    #       can :manage, [Document, Report]
    #       # but can only read, create and update charts (ie they cannot
    #       # be destroyed or have any other actions from the charts_controller.rb
    #       # executed)
    #       can [:read, :create, :update], Chart
    #       # an editor can only view the annual report
    #       can :read, AnnualReport
    #     elsif user.has_role? :guest
    #       can :read, [Document, Report, Chart]
    #     end
    # end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
