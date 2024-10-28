class DrinksController < ApplicationController
  
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
    restaurant = Restaurant.find(params[:restaurant_id])
    @drink = restaurant.drinks.find(params[:id])
    @drink.destroy
    redirect_to restaurant_drinks_path(restaurant), notice: 'Bebida deletada com sucesso'
  end

  def search
    @find = params["query"]
    restaurant = Restaurant.find(params[:restaurant_id])
    @drink = restaurant.drinks.find_by(name: params["query"])
  end

  private

  def drink_params
    params.require(:drink).permit(:name, :description, :alcohol, :image)
  end
end