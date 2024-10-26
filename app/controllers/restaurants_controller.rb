class RestaurantsController < ApplicationController
  require 'cpf_cnpj'

  before_action :authenticate_user!
  def new
    @restaurant = Restaurant.new
  end

  def create  
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.alphanumeric_code = SecureRandom.base36(6)
    @restaurant.cnpj.strip
    if @restaurant.save
      redirect_to root_path, notice: "Restaurante cadastrado com sucesso"
    else
      flash.now[ :alert ] = "ALGO DEU ERRADO, RESTAURANTE NÃO CADASTRADO"
      render 'new'
    end
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:trade_name, :legal_name, :cnpj,
    :address, :phone, :email)
  end
end