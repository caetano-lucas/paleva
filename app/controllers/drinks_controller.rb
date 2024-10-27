class DrinksController < ApplicationController
  #skip_before_action :redirect_unless_restaurant, only: [ :new, :create ]
  def index
    @drinks = Drink.all
  end
  def edit; end
  def new
    @drink = Drink.new
    @user = current_user
    @drink.restaurant_id = current_user.restaurant.id 
  end
  def update
    if @drink.update(drink_params)
      redirect_to drink_path(@drink.id), notice: 'Bebida atualizada com sucesso'
    else
      flash.now[:notice] = "Não foi possível atualizar a bebida"
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    # @drink = current_user.restaurant.build_drink(drink_params)
    # @restaurant = current_user.build_restaurant(restaurant_params)
    @drink = Drink.new(drink_params)
    @drink.restaurant_id = current_user.restaurant.id 
    if @drink.save
      redirect_to drinks_path
    else
      flash.now[ :alert ] = "ALGO DEU ERRADO, BEBIDA NÃO CADASTRADA"
      render :new, status: :unprocessable_entity
    end

  end

  private
  def drink_params
    params.require(:drink).permit(:name, :description, :alcohol, :restaurant_id)
  end
end