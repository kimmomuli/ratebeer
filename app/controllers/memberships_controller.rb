class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, only: [:new, :create, :destroy]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @available_beer_clubs = BeerClub.all - current_user.beer_clubs
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user

    respond_to do |format|
      if @membership.save
        format.html { redirect_to beer_club_path(@membership.beer_club), notice: "#{current_user.username} welcome to the club!" }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    if @membership.update(membership_params)
      redirect_to @membership, notice: 'Membership was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @membership = Membership.find(params[:id])
    beer_club = @membership.beer_club
    if current_user == @membership.user
      @membership.destroy
      redirect_to user_path(current_user), notice: 'Membership was successfully destroyed.'
    else
      redirect_to beer_club, alert: 'Only membership owner can destroy membership'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:beer_club_id, :user_id, :id)
  end

  def ensure_that_signed_in
    redirect_to signin_path, alert: 'You must be signed in' unless current_user
  end
end
