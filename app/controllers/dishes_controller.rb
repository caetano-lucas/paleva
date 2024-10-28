class DishesController < ApplicationController
  
  def index
    restaurant = Restaurant.find(params[:restaurant_id])
    @dishes = restaurant.dishes
  end

  def show; end

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
      redirect_to restaurant_dishes_path(current_user.restaurant), notice: 'Prato atualizado com sucesso'
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

  def destroy
    restaurant = Restaurant.find(params[:restaurant_id])
    @dish = restaurant.dishes.find(params[:id])
    @dish.destroy
    redirect_to restaurant_dishes_path(restaurant), notice: 'Prato deletado com sucesso'
  end

  def search
    @find = params["query"]
    restaurant = Restaurant.find(params[:restaurant_id])
    @dish = restaurant.dishes.find_by(name: params["query"])
  end

  private

  def dish_params
    params.require(:dish).permit(:name, :description, :calories, :image)
  end
end