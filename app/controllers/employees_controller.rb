class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant
  before_action :user_have_permition
  before_action :user_is_owner
  def new
    @employee = Employee.new
  end
  def index
    @employees = Employee.where(restaurant: @restaurant)
  end

  def create
    @user = current_user
    if @user.owner?
      @employee = Employee.create(employee_params)
      @employee.restaurant =  Restaurant.find(@user.restaurant_id)
      @employee.user = @user
      if @employee.save
        redirect_to restaurant_employees_path, notice: I18n.t('employees.create_success')
      else
        render :new, notice: I18n.t('employees.create_fail')
      end
    else
      redirect_to root_path, alert: I18n.t('employees.no_autorization')
    end
  end

  private

  def user_is_owner
    if current_user.employee?
      redirect_to root_path, alert: I18n.t('employees.no_autorization')
    end
  end


  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def user_have_permition
    if @restaurant.id != current_user.restaurant_id
      redirect_to root_path, alert: I18n.t('employees.no_permition')
    end
  end

  def redirect_unless_restaurant
    if current_user.restaurant_id.nil?
      flash.now[:notice] =  I18n.t('employees.register_restaurant_first')
      redirect_to new_restaurant_path
    end
  end

  def employee_params
    params.require(:employee).permit(:email, :cpf)
  end
end