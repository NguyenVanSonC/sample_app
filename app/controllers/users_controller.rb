class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user?, only: %i(edit update)
  before_action :verify_admin!, only: :destroy
  before_action :find_user, except: %i(index new create)
  def index
    @users = User.select(:id, :name, :email).recent.paginate page: params[:page], per_page: Settings.pageuser
  end

  def show
    render :show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".destroy"
      redirect_to users_url
    else
      flash[:success] = t ".notdestroy"
      redirect_to users_url
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".logged"
    redirect_to login_url
  end

  def correct_user?
    @user = User.find_by id: params[:id]
    redirect_to root_url unless  current_user? @user
  end

  def verify_admin!
    redirect_to root_url unless current_user.admin?
  end
  
  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".notfound"
    redirect_to root_url 
  end
end
