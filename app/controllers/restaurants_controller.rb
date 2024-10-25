class RestaurantsController < ApplicationController
  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to root_path, notice: "Restaurante cadastrado com sucesso"
    else
      flash.now[ :notice ] = "ALGO DEU ERRADO, RESTAURANTE NÃO CADASTRADO"
      render 'new'
    end
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:trade_name, :legal_name, :cnpj,
    :address, :phone, :email)
  end
end