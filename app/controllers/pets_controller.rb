class PetsController < ApplicationController

  # A callback to set up an @pet object to work with 
  before_action :set_pet, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    # get data on all pets and paginate the output to 10 per page
    if current_user.owner? #equivalent to current_user.role=="owner"
      # we make sure that the owner sees only his pets
      @active_pets = current_user.owner.pets.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @inactive_pets = current_user.owner.pets.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    else #otherwise (current user is vet or assistant )
      # get the list of all the pets in the system
      @active_pets = Pet.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @inactive_pets = Pet.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    end

  end

  def show
    # check if the current owner is allowed to see his pet details as well as its recent visits
    # authorize! :show, @pet
    # get the last 10 visits for this pet
    @recent_visits = @pet.visits.chronological.last(10).to_a

  end

  def new
    # authorize! :new, @pet

    @pet = Pet.new
  end

  def edit
  end

  def create
    # authorize! :create, @pet

    @pet = Pet.new(pet_params)
    if @pet.save
      redirect_to @pet, notice: "Successfully added #{@pet.name} as a PATS pet."
    else
      render action: 'new'
    end
  end

  def update
    if @pet.update(pet_params)
      redirect_to @pet, notice: "Updated #{@pet.name}'s information"
    else
      render action: 'edit'
    end
  end

  def destroy
    @pet.make_inactive
    redirect_to pets_path, notice: "Deactivated #{@pet.name}"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_pet
    @pet = Pet.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def pet_params
    params.require(:pet).permit(:name, :animal_id, :owner_id, :female, :date_of_birth, :active)
  end

end
