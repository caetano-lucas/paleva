class RestaurantsController < ApplicationController
  require 'cpf_cnpj'
  before_action :authenticate_user!
  before_action :redirect_unless_restaurant, only: [:show]
  before_action :user_have_permition, only: [:show]


  def show
    @restaurant = Restaurant.find(current_user.restaurant_id)
    @user = current_user
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
      @user.update!(restaurant_id: @restaurant.id, position: :owner)
      redirect_to @restaurant, notice: I18n.t('restaurants.create_success')
    else
      flash.now[:notice] = I18n.t('restaurants.create_fail')
      render :new, status: :unprocessable_entity
    end
  end

  private 
  def user_have_permition
    r = Restaurant.find(params[:id])
    if r.id != current_user.restaurant.id
      redirect_to root_path, notice: I18n.t('.no_permition')
    end
  end
  
  def redirect_unless_restaurant
    if current_user.restaurant_id.nil?
      flash.now[:notice] = I18n.t('.no_permition')
      redirect_to new_restaurant_path
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:trade_name, :legal_name, :cnpj, :address, :phone, :email, :id)
  end
end