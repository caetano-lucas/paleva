class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant
  
  def index    
    @dishes = @restaurant.dishes
  end

  def show
  end

  def edit
    @dish = @restaurant.dishes.find(params[:id])
  end

  def new
    @dish = @restaurant.dishes.build
  end
  
  def update
    @dish = @restaurant.dishes.find(params[:id])
    if @dish.update(dish_params)
      redirect_to restaurant_dishes_path(current_user.restaurant), notice: 'Prato atualizado com sucesso'
    else
      flash.now[:notice] = "Não foi possível atualizar o Prato"
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    @dish = @restaurant.dishes.build(dish_params)
    if @dish.save
      redirect_to restaurant_dishes_path(@restaurant), notice: 'Prato cadastrado com sucesso'
    else
      flash.now[ :alert ] = "ALGO DEU ERRADO, PRATO NÃO CADASTRADO"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @dish = @restaurant.dishes.find(params[:id])
    @dish.destroy
    redirect_to restaurant_dishes_path(@restaurant), notice: 'Prato deletado com sucesso'
  end

  def search
    @find = params["query"]

    if @restaurant.dishes.find_by(name: params["query"]) == nil
      @dish = @restaurant.dishes.find_by(description: params["query"])
    else
      @dish = @restaurant.dishes.find_by(name: params["query"])
    end
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

  def dish_params
    params.require(:dish).permit(:name, :description, :calories, :image)
  end
end