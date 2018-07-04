class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      handling(user, params[:session][:remember_me])
      redirect_to user
      flash[:success] = t(".m1")
    else
      flash[:danger] = t(".m2")
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def handling user, par
    log_in user
    par == "1" ? remember(user) : forget(user)
  end
end
