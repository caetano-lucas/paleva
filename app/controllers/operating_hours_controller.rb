class OperatingHoursController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_restaurant
  before_action :set_restaurant
  before_action :user_have_permition
  before_action :user_is_owner

  def index
    @operating_hours = @restaurant.operating_hours
  end

  def show; end 
  def new
    @operating_hour = @restaurant.operating_hours.new
  end

  def create
    @operating_hour = @restaurant.operating_hours.new(operating_hour_params)
    if @operating_hour.save
      redirect_to restaurant_operating_hours_path(@restaurant), notice: 'Horário de funcionamento criado com sucesso.'
    else
      flash.now[:notice] = "Horário de Abertura deve ser menor que o de fechamento"
      render :new
    end
  end

  def edit
    @operating_hour = @restaurant.operating_hours.find(params[:id])
  end

  def update
    @operating_hour = @restaurant.operating_hours.find(params[:id])
    if @operating_hour.update(operating_hour_params)
      redirect_to restaurant_operating_hours_path(@restaurant), notice: 'Horário de funcionamento atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @operating_hour = @restaurant.operating_hours.find(params[:id])
    @operating_hour.destroy
    redirect_to restaurant_operating_hours_path(@restaurant), notice: 'Horário de funcionamento excluído com sucesso.'
  end
  
  private

  def user_is_owner
    if current_user.employee?
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
  end

  def user_have_permition
    if @restaurant.id != current_user.restaurant_id
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
  end

  def set_restaurant
    @restaurant =  Restaurant.find(params[:restaurant_id])
  end

  def redirect_unless_restaurant
    if current_user.restaurant_id.nil?
      flash.now[:notice] = 'Você não tem permissão para acessar esse restaurante.'
      redirect_to new_restaurant_path
    end
  end

  def operating_hour_params
    params.require(:operating_hour).permit(:day, :open_time, :close_time, :closed)
  end
end
