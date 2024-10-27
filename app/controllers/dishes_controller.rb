class DishesController < ApplicationController
  #skip_before_action :redirect_unless_restaurant, only: [ :new, :create ]
  def index
    restaurant = Restaurant.find(params[:restaurant_id])
    @dishes = restaurant.dishes
  end
  def edit
    restaurant = Restaurant.find(params[:restaurant_id])
    @dish = restaurant.dishes.find(params[:id])
  end
  def new
    restaurant = Restaurant.find(params[:restaurant_id])
    @dish = restaurant.dishes.build
  end
  def update
    restaurant = Restaurant.find(params[:restaurant_id])
    @dish = restaurant.dishes.find(params[:id])
    if @dish.update(dish_params)
      redirect_to restaurant_dish_path(@dish.id), notice: 'Prato atualizado com sucesso'
    else
      flash.now[:notice] = "Não foi possível atualizar o Prato"
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    # @dish = current_user.restaurant.build_dish(dish_params)
    # @restaurant = current_user.build_restaurant(restaurant_params)
    restaurant = Restaurant.find(params[:restaurant_id])
    @dish = restaurant.dishes.build(dish_params)
    if @dish.save
      redirect_to restaurant_dishes_path(restaurant), notice: 'Prato cadastrado com sucesso'
    else
      flash.now[ :alert ] = "ALGO DEU ERRADO, PRATO NÃO CADASTRADO"
      render :new, status: :unprocessable_entity
    end

  end

  private
  def dish_params
    params.require(:dish).permit(:name, :description, :calories)
  end
end