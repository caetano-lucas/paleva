class PortionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :set_dish_or_drink
  before_action :redirect_unless_restaurant
  before_action :user_have_permition

  def index
    authorize_access
    @portions = @portionable.portions
  end

  def show
    authorize_access
    @portion = @portionable.portions.find(params[:id])
  end

  def new
    @portion = @portionable.portions.build
  end

  def create
    @portion = @portionable.portions.build(portion_params)
    if @portion.save
      if (params[:dish_id])
        redirect_to restaurant_dish_path(@restaurant, @portionable), notice: 'Porção cadastrada com sucesso'
      else
        redirect_to restaurant_drink_path(@restaurant, @portionable), notice: 'Porção cadastrada com sucesso'
      end
    else
      flash.now[:alert] = 'Não foi possível cadastrar a porção'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_access
    @portion = Portion.find params[:id]
  end

  def update
    @portion = @restaurant.portions.find(params[:id])
    if @portion.update(portion_params)
      redirect_to restaurant_portions_path(@restaurant), notice: 'Porção atualizada com sucesso'
    else
      flash.now[:alert] = "Não foi possível atualizar a porção"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_access
    @portion = @restaurant.portions.find(params[:id])
    if @portion.destroy
      redirect_to restaurant_portions_path(@restaurant), notice: 'Porção deletada com sucesso'
    else
      redirect_to restaurant_portions_path(@restaurant), alert: 'Erro ao deletar a porção'
    end
  end

  private

  def user_have_permition
    if @restaurant.user != current_user
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
  end

  def set_dish_or_drink
    if (params[:dish_id])
      @portionable = @restaurant.dishes.find(params[:dish_id])
    else
      @portionable = @restaurant.drinks.find(params[:drink_id])     
    end
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def redirect_unless_restaurant
    restaurant = current_user&.restaurant
    unless restaurant&.persisted?
      redirect_to new_restaurant_path, alert: "Você não tem permissão para isso"
    end
  end

  def authorize_access
    redirect_to root_path, alert: 'Você não possui acesso a esta lista' if @restaurant.user != current_user
  end

  def portion_params
    params.require(:portion).permit(:description, :price_whole, :price_cents, :portionable_type, :portionable_id)
  end
end
