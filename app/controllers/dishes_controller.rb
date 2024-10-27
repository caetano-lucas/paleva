class DishesController < ApplicationController
  #skip_before_action :redirect_unless_restaurant, only: [ :new, :create ]
  def index
    @dishes = Dish.all
  end
  def edit; end
  def new
    @dish = Dish.new
    @user = current_user
    @dish.restaurant_id = current_user.restaurant.id 
  end
  def update
    if @dish.update(dish_params)
      redirect_to dish_path(@dish.id), notice: 'Prato atualizado com sucesso'
    else
      flash.now[:notice] = "Não foi possível atualizar o Prato"
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    # @dish = current_user.restaurant.build_dish(dish_params)
    # @restaurant = current_user.build_restaurant(restaurant_params)
    @dish = Dish.new(dish_params)
    @dish.restaurant_id = current_user.restaurant.id 
    if @dish.save
      redirect_to dishes_path
    else
      flash.now[ :alert ] = "ALGO DEU ERRADO, PRATO NÃO CADASTRADO"
      render :new, status: :unprocessable_entity
    end

  end

  private
  def dish_params
    params.require(:dish).permit(:name, :description, :calories, :restaurat)
  end
end