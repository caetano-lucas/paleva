class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_restaurant
  def index
  end

  def redirect_unless_restaurant
    restaurant = current_user&.restaurant
    if restaurant&.persisted?
      redirect_to restaurant_menus_path(current_user.restaurant)
    else
      redirect_to new_restaurant_path
    end
  end
end
