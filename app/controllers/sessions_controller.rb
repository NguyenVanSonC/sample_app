class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        handling(user, params[:session][:remember_me])
      else
        flash[:warning] = t ".message"
        redirect_to root_url
      end
    else
      flash[:danger] = t ".wrong"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def handling user, param
    log_in user
    param == "1" ? remember(user) : forget(user)
    redirect_back_or user
    flash[:success] = t ".right"
  end
end
