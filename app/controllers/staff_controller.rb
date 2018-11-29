class StaffController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :staff, User

    @users = User.order(created_at: :desc).page(params[:page])
  end

  def show
    authorize! :staff_show, @user
  end

  def new
    authorize! :staff_new, User    
    @user = User.new
  end

  def edit
    authorize! :staff_edit, @user
  end

  def create
    authorize! :staff_create, User

    @user = User.new(allowed_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to staff_index, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :staff_update, @user

    respond_to do |format|
      if @user.update(allowed_params)
        format.html { redirect_to user_index, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def allowed_params
      params.require(:user).permit(:email, :password, :role, :first_name, :last_name, :password_confirmation)
    end
end
