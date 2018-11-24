class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :password, :update_password, :update, :destroy, :activate]
  
  def new
    authorize! :new, User

    @user = User.new
  end

  def edit
    authorize! :edit, @user
  end  

  def password
    authorize! :password, @user
  end  

  def update_password
    authorize! :update_password, @user
    
    respond_to do |format|
      if @user.update(allowed_params)
        format.html { redirect_to redirect_to_back, notice: 'Password was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    authorize! :create, User
    
    @user = User.new(allowed_params)
    if @user.save
      redirect_to root_url, notice: 'Thank you for signing up!'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize! :update, @user    

    respond_to do |format|
      if @user.update(allowed_params)
        format.html { redirect_to redirect_to_back, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate
    authorize! :activate, @user

    @user.status = 'ACTIVE'
    @user.save
    respond_to do |format|
      format.html { redirect_to redirect_to_back, notice: 'User was successfully activated.' }
      format.json { head :no_content }
    end
  end

  def destroy
    authorize! :destroy, @user

    @user.status = 'DELETED'
    @user.save
    respond_to do |format|
      format.html { redirect_to redirect_to_back, notice: 'User was successfully disabled.' }
      format.json { head :no_content }
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def redirect_to_back(default = root_url)
      if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
        :back
      else
        default
      end
    end

    def allowed_params
      params.require(:user).permit(:email, :password, :status, :role, :first_name, :last_name, :password_confirmation)
    end
end
