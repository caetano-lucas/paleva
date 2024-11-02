class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant
  
  def index    
    if @restaurant.user != current_user
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    else
      @dishes = @restaurant.dishes
    end
  end

  def show
    if @restaurant.user != current_user
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    else
      @dish = @restaurant.dishes.find(params[:id])
    end
  end

  def edit
    if @restaurant.user != current_user
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    else
      @dish = @restaurant.dishes.find(params[:id])
    end
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
     if @restaurant.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a esta lista'
     end
    @dish = @restaurant.dishes.find(params[:id])
    @dish.destroy
    redirect_to restaurant_dishes_path(@restaurant), notice: 'Prato deletado com sucesso'
  end

  def search
    if @restaurant.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
    @find = params["query"]
    @dishes = @restaurant.dishes.where("name LIKE ? OR description LIKE ?", "%#{@find}%", "%#{@find}%").all
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
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