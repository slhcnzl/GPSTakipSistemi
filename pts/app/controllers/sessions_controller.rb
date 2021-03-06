class SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session, if: Proc.new {|c| c.request.format.json? }

  def create
    user = User.find_for_database_authentication(email: params[:email])
    if user && user.valid_password?(params[:password])
      token = user.ensure_authentication_token
      render json: {auth_token: token, user_id: user.id}
    else
      render nothing: true, status: :unauthorized
    end
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render :json => {}
  end
end 