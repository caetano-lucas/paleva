class DrinksController < ApplicationController
  before_action :redirect_unless_restaurant
  before_action :set_restaurant
  before_action :authenticate_user!
  before_action :user_have_permition

  def index
    @features = ItemFeature.where(featurable_type: "Drink")
    @drinks = @restaurant.drinks
    if params[:feature_ids] 
      @drinks = @drinks.joins(:features).where(features: { id: params[:feature_ids] }).distinct
    end
  end

  def show
    if params[:feature_ids].present?
      @drink = @restaurant.drinks.includes(:features).where(features: { id: params[:feature_ids] }).distinct
    else
      @drink = @restaurant.drinks.find(params[:id])
      @portions = @drink.portions
    end
  end

  def edit
    @features = @restaurant.features
    @drink = @restaurant.drinks.find(params[:id])
  end

  def new
    @drink = @restaurant.drinks.build
  end

  def update
    @drink = @restaurant.drinks.find(params[:id])
    if @drink.update(drink_params)
      if params[:feature_ids] 
        params[:feature_ids].each do |feature_id|
          feature = Feature.find(feature_id)
          ItemFeature.create!(feature: feature, featurable: @drink)
        end
      end
      redirect_to restaurant_drinks_path(current_user.restaurant), notice: 'Bebida atualizada com sucesso'
    else
      flash.now[:notice] = "Não foi possível atualizar a bebida"
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    @drink = @restaurant.drinks.build(drink_params)
    if @drink.save
      redirect_to restaurant_drink_path(@restaurant, @drink), notice: 'Bebida cadastrada com sucesso'
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
    @drinks = @restaurant.drinks.where("name LIKE ? OR description LIKE ?", "%#{@find}%", "%#{@find}%").all
    @features = ItemFeature.where(featurable_type: "Drink")
    if params[:feature_ids] 
      @drinks = @drinks.joins(:features).where(features: { id: params[:feature_ids] }).distinct
    end
  end

  def change_status

    @drink = @restaurant.drinks.find(params[:id])
    if @drink.active? 
      @drink.inactive!
    else 
      @drink.active!
    end
    redirect_to restaurant_drink_path(@restaurant, @drink)
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

  def drink_params
    params.require(:drink).permit(:name, :description, :alcohol, :image)
  end
end