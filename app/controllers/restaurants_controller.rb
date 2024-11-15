class RestaurantsController < ApplicationController
  require 'cpf_cnpj'
  before_action :authenticate_user!
  before_action :redirect_unless_restaurant, only: [:show]


  def show
    @restaurant = Restaurant.find(current_user.restaurant_id)
  end

  def new
    @user = current_user
    @restaurant = Restaurant.new
  end

  def create
    @user = current_user
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.cnpj.strip
    if @restaurant.save
      @user.update!(restaurant_id: @restaurant.id)
      redirect_to @restaurant, notice: "Restaurante cadastrado com sucesso"
    else
      flash.now[:notice] = 'Não foi possível cadastrar o restaurante, siga as instruções abaixo.'
      render :new, status: :unprocessable_entity
    end
  end

  private 

  def redirect_unless_restaurant
    if current_user.restaurant_id.nil?
      flash.now[:notice] = 'Você não tem permissão para acessar esse restaurante.'
      redirect_to new_restaurant_path
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:trade_name, :legal_name, :cnpj, :address, :phone, :email)
  end
end