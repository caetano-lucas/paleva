class DishFeaturesController < ApplicationController
  before_action :set_restaurant
  before_action :set_dish

  def new
    @dish_feature = DishFeature.new
  end

  def create
    @dish_feature = @dish.dish_features.build(dish_feature_params)
    if @dish_feature.save
      redirect_to edit_restaurant_dish_path(@restaurant, @dish), notice: 'Característica adicionada com sucesso.'
    else
      flash.now[:alert] = 'Erro ao adicionar característica.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_dish
    @dish = @restaurant.dishes.find(params[:dish_id])
  end

  def dish_feature_params
    params.require(:dish_feature).permit(:feature_id)
  end
end