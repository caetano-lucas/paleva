class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant
  before_action :user_have_permition
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
        redirect_to restaurant_employees_path, notice: 'Funcionário criado com sucesso.'
      else
        render :new, notice: 'Falha ao criar funcionário.'
      end
    else
      redirect_to root_path, alert: 'Nenhum usuário encontrado para este restaurante.'
    end
  end

  private


  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def user_have_permition
    if @restaurant.id != current_user.restaurant_id
      redirect_to root_path, alert: 'Você não possui acesso a esta tela'
    end
  end

  def redirect_unless_restaurant
    if current_user.restaurant_id.nil?
      flash.now[:notice] = 'Você não tem permissão para acessar esta função;'
      redirect_to new_restaurant_path
    end
  end

  def employee_params
    params.require(:employee).permit(:email, :cpf)
  end
end