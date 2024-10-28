class RestaurantsController < ApplicationController
  require 'cpf_cnpj'

  skip_before_action :redirect_unless_restaurant, only: [ :new, :create ]

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @user = current_user
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.build_restaurant(restaurant_params)
    @restaurant.cnpj.strip # vou mover pro model

    if @restaurant.save
      redirect_to @restaurant, notice: "Restaurante cadastrado com sucesso"
    else
      flash.now[ :alert ] = "ALGO DEU ERRADO, RESTAURANTE NÃO CADASTRADO"
      render :new, status: :unprocessable_entity
    end
  end

  private
  
  def restaurant_params
    params.require(:restaurant).permit(:trade_name, :legal_name, :cnpj,
    :address, :phone, :email)
  end
end
