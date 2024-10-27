class DrinksController < ApplicationController
  #skip_before_action :redirect_unless_restaurant, only: [ :new, :create ]
  def index
    restaurant = Restaurant.find(params[:restaurant_id])
    @drinks = restaurant.drinks
  end
  def show; end
  def edit
    restaurant = Restaurant.find(params[:restaurant_id])
    @drink = restaurant.drinks.find(params[:id])
  end
  def new
    restaurant = Restaurant.find(params[:restaurant_id])
    @drink = restaurant.drinks.build
  end
  def update
    restaurant = Restaurant.find(params[:restaurant_id])
    @drink = restaurant.drinks.find(params[:id])
    if @drink.update(drink_params)
      redirect_to restaurant_drinks_path(current_user.restaurant), notice: 'Bebida atualizada com sucesso'
    else
      flash.now[:notice] = "Não foi possível atualizar a bebida"
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    # @drink = current_user.restaurant.build_drink(drink_params)
    # @restaurant = current_user.build_restaurant(restaurant_params)
    restaurant = Restaurant.find(params[:restaurant_id])
    @drink = restaurant.drinks.build(drink_params)
   
    if @drink.save
      redirect_to restaurant_drinks_path(restaurant), notice: 'Bebida cadastrada com sucesso'
    else
      flash.now[ :alert ] = "ALGO DEU ERRADO, BEBIDA NÃO CADASTRADA"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @drink.destroy
    redirect_to restaurant_drinks_path(restaurant), notice: 'Bebida deletada com sucesso'
  end

  private
  def drink_params
    params.require(:drink).permit(:name, :description, :alcohol)
  end
end