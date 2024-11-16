class RegistrationsController < Devise::RegistrationsController
  def create
    employee = Employee.find_by(cpf: user_params[:cpf]) || Employee.find_by(email: user_params[:email])
    if employee
      @employee = employee
      @user = User.new(user_params)
      @user.restaurant_id = @employee.restaurant_id
      @user.save
    else
      super
    end
  end
  protected

  def after_sign_up_path_for(resource)
    '/restaurants/new'
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :cpf, :email, :password, :password_confirmation)
  end
end