class DrinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant

  def index
    @drinks = @restaurant.drinks
  end

  def show; end

  def edit
    @drink = @restaurant.drinks.find(params[:id])
  end

  def new
    @drink = @restaurant.drinks.build
  end

  def update
    @drink = @restaurant.drinks.find(params[:id])
    if @drink.update(drink_params)
      redirect_to restaurant_drinks_path(current_user.restaurant), notice: 'Bebida atualizada com sucesso'
    else
      flash.now[:notice] = "Não foi possível atualizar a bebida"
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    @drink = @restaurant.drinks.build(drink_params)   
    if @drink.save
      redirect_to restaurant_drinks_path(@restaurant), notice: 'Bebida cadastrada com sucesso'
    else
      flash.now[ :alert ] = "ALGO DEU ERRADO, BEBIDA NÃO CADASTRADA"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @drink = @restaurant.drinks.find(params[:id])
    @drink.destroy
    redirect_to restaurant_drinks_path(@restaurant), notice: 'Bebida deletada com sucesso'
  end

  def search
    @find = params["query"]
    @drink = @restaurant.drinks.find_by(name: params["query"])
  end

  private
  
  def set_restaurant
    @restaurant = current_user&.restaurant
  end

  def redirect_unless_restaurant
    restaurant = current_user&.restaurant
    if restaurant&.persisted?
      nil
    else
      redirect_to new_restaurant_path
      flash.now[:alert] = "Você não tem permissão para isso"
    end
  end

  def drink_params
    params.require(:drink).permit(:name, :description, :alcohol, :image)
  end
end