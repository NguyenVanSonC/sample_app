class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to user
      flash[:success] = t(".m1")
    else
      flash[:danger] = t(".m2")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
