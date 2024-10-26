class RestaurantsController < ApplicationController
  require 'cpf_cnpj'

  before_action :authenticate_user!

  def show
    @restaurant = Restaurant.find(params[:id])
  end
  def new
    @user = current_user
    @restaurant = Restaurant.new
  end

  def create  
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.alphanumeric_code = SecureRandom.base36(6)
    @restaurant.cnpj.strip
    @restaurant.user= current_user
    if @restaurant.save
      redirect_to @restaurant, notice: "Restaurante cadastrado com sucesso"
    else
      flash.now[ :alert ] = "ALGO DEU ERRADO, RESTAURANTE NÃO CADASTRADO"
      render :new
    end
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:trade_name, :legal_name, :cnpj,
    :address, :phone, :email)
  end
end