class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant
  before_action :user_have_permition
  before_action :user_is_owner, only: [:new,:create,:show, :edit]
  def new
    @menu = @restaurant.menus.build
  end

  def create
    @menu = @restaurant.menus.build(menu_params)
    if @menu.save
      redirect_to restaurant_menu_path(@restaurant, @menu), notice: I18n.t('menus.create.success')
    else
      flash.now[:alert] = "ERRO Cardápio já cadastrado"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @menu = Menu.find(params[:id])
  end

  def index
    @menus = @restaurant.menus
  end

  def edit
    @menu =  @restaurant.menus.find(params[:id])
    @dishes = @restaurant.dishes.active
    @drinks = @restaurant.drinks.active
  end

  def update
    @menu =  @restaurant.menus.find(params[:id])

    if @menu.update(menu_params1)
      MenuItem.where(menu_id: @menu.id).delete_all
      if params[:dish_ids]
        params[:dish_ids].each do |dish_id|
          dish = Dish.find(dish_id)
          MenuItem.create!(menu_id: @menu.id, menu_itemable: dish)
        end
      end
      if params[:drink_ids]
        params[:drink_ids].each do |drink_id|
          drink = Drink.find(drink_id)
          MenuItem.create!(menu_id: @menu.id, menu_itemable: drink)
        end
      end
      redirect_to restaurant_menus_path(@restaurant), notice: 'Cardápio atualizado com sucesso'
    else
      flash.now[:notice] = "Não foi possível atualizar o cardápio"
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def user_is_owner
    if current_user.employee?
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
  end

  def menu_params1
    params.permit(:name, :dish_ids, :drink_ids, :restaurant_id, :id)
  end

  def menu_params
    params.require(:menu).permit(:name, :dish_ids, :drink_ids, :restaurant_id, :id)
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

end
