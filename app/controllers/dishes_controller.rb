class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant
  before_action :user_have_permition

  def index
    if params[:feature_ids].present?
      @dishes = @restaurant.dishes.includes(:features).where(features: { id: params[:feature_ids] }).distinct
    else
      @dishes = @restaurant.dishes
    end
  end

  def show
    if params[:feature_ids].present?
      @dish = @restaurant.dishes.includes(:features).where(features: { id: params[:feature_ids] }).distinct
    else
      @dish = @restaurant.dishes.find(params[:id])
      @portions = @dish.portions
    end
  end

  def edit
    @dish = @restaurant.dishes.find(params[:id])
  end

  def new
    @dish = @restaurant.dishes.build
    @features = @restaurant.features
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
      redirect_to restaurant_dish_path(@restaurant, @dish), notice: 'Prato cadastrado com sucesso'
    else
      flash.now[ :alert ] = "ALGO DEU ERRADO, PRATO NÃO CADASTRADO"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @dish = @restaurant.dishes.find(params[:id])
    @dish.features.destroy_all
    if @dish.destroy
      redirect_to restaurant_dishes_path(@restaurant), notice: 'Prato deletado com sucesso'
    else
      redirect_to restaurant_dishes_path(@restaurant), alert: 'Erro ao deletar o prato'
    end
  end

  def search
    @find = params["query"]
    @dishes = @restaurant.dishes.where("name LIKE ? OR description LIKE ?", "%#{@find}%", "%#{@find}%").all
  end

  def change_status
    @dish = @restaurant.dishes.find(params[:id])
    if @dish.active?
      @dish.inactive!
    else
      @dish.active!
    end
    redirect_to restaurant_dish_path(@restaurant, @dish)
  end

  private

  def user_have_permition
    if @restaurant.user != current_user
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
  end

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
