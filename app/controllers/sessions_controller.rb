class SessionsController < Devise::SessionsController
 before_filter :configure_sign_in_params, only: [:create]

   
   def new
    super
   end

 
  def create
    super
  end

   
  private

  def configure_sign_in_params 
    params.require(:user).permit(:email, :password) 
  end
end
