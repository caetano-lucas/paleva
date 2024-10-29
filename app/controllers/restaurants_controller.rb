class RestaurantsController < ApplicationController
  require 'cpf_cnpj'
  before_action :authenticate_user!
  before_action :redirect_unless_restaurant, only: [:show]


  def show
    @restaurant = Restaurant.find(params[:id])
    @restaurant = current_user&.restaurant
    if @restaurant&.persisted?
      nil
    else
      flash.now[ :alert ] = "Você não tem acesso ao restaurante de outro usuário"
      redirect_to new_restaurant_path
    end
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
      render :new, status: :unprocessable_entity
    end
  end

  private 
  
  def redirect_unless_restaurant
    restaurant = current_user&.restaurant
    if restaurant&.persisted?
      nil
    else
      redirect_to new_restaurant_path
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:trade_name, :legal_name, :cnpj,
    :address, :phone, :email)
  end
end
