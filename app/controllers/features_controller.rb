class FeaturesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant

  def index
    authorize_access
    @features = @restaurant.features
  end

  def show
    authorize_access
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
    authorize_access
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
    authorize_access
    @feature = @restaurant.features.find(params[:id])
    if @feature.destroy
      redirect_to restaurant_features_path(@restaurant), notice: 'Característica deletada com sucesso'
    else
      redirect_to restaurant_features_path(@restaurant), alert: 'Erro ao deletar a característica'
    end
  end

  private

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

  def feature_params
    params.require(:feature).permit(:name)
  end
end