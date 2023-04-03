require 'helpers/activeable'

class User < ApplicationRecord

# Use built-in rails support for password protection
  # Most of the secure password machinery will be implemented using a single Rails built_in module
  # called `has_secure_password`, which we'll include in the User model as follows:
  has_secure_password
  # NOw to have this has_secure_password working in rails, you will need to go to the Gemfile and add the `bcrypt gem` (check line 30)
  # has_secure_password is used to encrypt and authenticate passwords using the BCrypt password-hashing function 


    # When included in a model as above, this one module adds the following functionality:
    # 1- The ability to save a securely hashed `password_digest` attribute to the database:  The has_secure_password module will be 
    # responsible of creating the password_digest out of the password and password confirmation entered by the user when signinup.
    # 2- A pair of virtual attributes: password and password_confirmation, and their getters and setters 
    # (as if we did the following:  attr_accessor :password, :password_confirmation)
    # IMPORTANT NOTE: NEVER CREATE THESE TWO FIELDS WHEN YOU GENERATE THE MODEL.
    # 3- An `authenticate` method that returns the user when the password is correct (and false otherwise)

    # The only requirement for `has_secure_password` to work its magic is for the corresponding model to have 
    # an attribute called `password_digest`. (The name digest comes from the terminology of cryptographic hash functions. 
    # In this context, hashed password and password digest are synonyms.)
    # In the case of the User model, this leads to the data model shown in the ERD of PATS.





    # Relationships
    has_one :owner

  # enums
  enum :role, { vet: 1, assistant: 2, owner: 3}, scopes: true, default: :owner
  ROLES = [
    ['Vet', User.roles[:vet]],
    ['Assistant', User.roles[:assistant]],
    ['Owner', User.roles[:owner]]
  ]


   # Validations
  # make sure required fields are present
  validates_presence_of :first_name, :last_name 
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_inclusion_of :role, in: %w( vet assistant owner ), message: "is not recognized in the system"

  validates_presence_of :password, :on => :create 
  validates_presence_of :password_confirmation, :on => :create 
  validates_confirmation_of :password, message: "does not match"
  validates_length_of :password, :minimum => 4, message: "must be at least 4 characters long", :allow_blank => true

  # Other methods
  # -----------------------------  
  def proper_name
    first_name + " " + last_name
  end
  
  def name
    last_name + ", " + first_name
  end

  # def vet?
  #   return true if role=='vet'
  # end
  
 # we add this class method to handle logging in via username and password
#  we use this method later in the sessions_controller.

 def self.authenticate(username, password)
  find_by_username(username).try(:authenticate, password)
end

  

end
