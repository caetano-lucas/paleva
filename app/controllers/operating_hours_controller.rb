class OperatingHoursController < ApplicationController
  
  def index
    @restaurant = Restaurant.find(params[:restaurant_id])
    @operating_hours = @restaurant.operating_hours
  end

  def show; end 
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @operating_hour = @restaurant.operating_hours.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @operating_hour = @restaurant.operating_hours.new(operating_hour_params)
    if @operating_hour.save
      redirect_to restaurant_operating_hours_path(@restaurant), notice: 'Horário de funcionamento criado com sucesso.'
    else
      render :new
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:restaurant_id])
    @operating_hour = @restaurant.operating_hours.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:restaurant_id])
    @operating_hour = @restaurant.operating_hours.find(params[:id])
    if @operating_hour.update(operating_hour_params)
      redirect_to restaurant_operating_hours_path(@restaurant), notice: 'Horário de funcionamento atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @operating_hour = @restaurant.operating_hours.find(params[:id])
    @operating_hour.destroy
    redirect_to restaurant_operating_hours_path(@restaurant), notice: 'Horário de funcionamento excluído com sucesso.'
  end
  
  private

  def operating_hour_params
    params.require(:operating_hour).permit(:day, :open_time, :close_time, :closed)
  end
end
