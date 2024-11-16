class FeaturesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant
  before_action :user_have_permition
  before_action :user_is_owner

  def index
    @features = @restaurant.features
  end

  def show
    @feature = @restaurant.features.find(params[:id])
  end

  def new
    @feature = @restaurant.features.build
  end

  def create
    @feature = @restaurant.features.build(feature_params)
    if @feature.save
      redirect_to restaurant_features_path(@restaurant), notice: 'Característica cadastrada com sucesso'
    else
      flash.now[:alert] = "ALGO DEU ERRADO, CARACTERÍSTICA NÃO CADASTRADA"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @feature = @restaurant.features.find(params[:id])
  end

  def update
    @feature = @restaurant.features.find(params[:id])
    if @feature.update(feature_params)
      redirect_to restaurant_features_path(@restaurant), notice: 'Característica atualizada com sucesso'
    else
      flash.now[:alert] = "Não foi possível atualizar a característica"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @feature = @restaurant.features.find(params[:id])
    if @feature.destroy
      redirect_to restaurant_features_path(@restaurant), notice: 'Característica deletada com sucesso'
    else
      redirect_to restaurant_features_path(@restaurant), alert: 'Erro ao deletar a característica'
    end
  end

  private

  def user_is_owner
    if current_user.employee?
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
  end

  def user_have_permition
    if @restaurant.id != current_user.restaurant_id
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def redirect_unless_restaurant
    if current_user.restaurant_id.nil?
      flash.now[:notice] = 'Você não tem permissão para acessar esse restaurante.'
      redirect_to new_restaurant_path
    end
  end

  def feature_params
    params.require(:feature).permit(:name)
  end
end