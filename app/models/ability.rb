# This is the Ability class is where all user permissions are defined.
# Based on who the user is, he/she would be allowed to make specific actions
class Ability
  include CanCan::Ability

  # The current user model is passed into the initialize method, so the permissions can be modified based on any user attributes. 
  # CanCan makes no assumption about how roles are handled in your application.
  def initialize(user)
    # set user to new User (a guest user) if not logged in
    user ||= User.new #a guest user (not logged in)
    
    # set authorizations for different user roles
    if user.vet?

      # The can method is used to define permissions and requires two arguments: 

        # 1. the action you're setting the permission for, 
        # 2. the class of object you're setting it on.

      # We can pass :manage to represent any action and :all to represent any object.
      # The vet can perform any action on any object in the system (pet, owner, visit, medicine, procedure, etc.)

      can :manage, :all
      
      # Common actions are :read, :create, :update and :destroy but it can be anything. 

    elsif user.assistant?
      # can manage owners, pets, and visits
      can :manage, Owner #this user can perform all actions (manage) on any Owner object
      can :manage, Pet #this user can perform all actions (manage) on any Owner object
      can :manage, Visit #this user can perform all actions (manage) on any Owner object
      
      # can create and destroy dosages and treatments
      can :manage, Dosage 
      can :manage, Treatment

      # can read (costs for) medicines and procedures

      can :read, MedicineCost  #user can read any object of type MedicineCost
      can :read, ProcedureCost # user can read any object of type ProcedureCost



      # they can read their own profile
      can :show, User do |u|  
        u.id == user.id
      end

      # they can update their own profile
      can :update, User do |u|  
        u.id == user.id
      end


    elsif user.owner?
      # they can read their own data
      can :show, Owner do |this_owner|  
        user.owner == this_owner
      end

      # they can see lists of pets and visits (controller filters automatically)
      can :index, Pet
      can :index, Visit

      # they can read their own pets' data
      can :show, Pet do |this_pet|  
        my_pets = user.owner.pets.map(&:id)
        my_pets.include? this_pet.id 
      end

      # they can read their own visits' data
      can :show, Visit do |this_visit|  
        my_visits = user.owner.visits.map(&:id)
        my_visits.include? this_visit.id 
      end

      
    else
      # guests can only read animals covered (plus home pages)
      can :read, Animal
    end
  end
end
