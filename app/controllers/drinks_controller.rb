class DrinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant

  def index
    if @restaurant.user != current_user
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    else
      @drinks = @restaurant.drinks
    end   
  end

  def show
    if @restaurant.user != current_user
      redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    else
      @drink = @restaurant.drinks.find(params[:id])
      @portions = @drink.portions
    end
  end

  def edit
      if @restaurant.user != current_user
        redirect_to root_path, alert: 'Você não possui acesso a esta lista'
      else
        @drink = @restaurant.drinks.find(params[:id])
      end
  end

  def new
    if @restaurant.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
    @drink = @restaurant.drinks.build
  end

  def update
    if @restaurant.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
    @drink = @restaurant.drinks.find(params[:id])
    if @drink.update(drink_params)
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
    if @restaurant.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a este item'
    end 
    @drink.destroy
    redirect_to restaurant_drinks_path(@restaurant), notice: 'Bebida deletada com sucesso'
  end

  def search
    if @restaurant.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end
    @find = params["query"]
    @drinks = @restaurant.drinks.where("name LIKE ? OR description LIKE ?", "%#{@find}%", "%#{@find}%").all
  end

  def change_status
    if @restaurant.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a esta lista'
    end    
    @drink = @restaurant.drinks.find(params[:id])
    if @drink.active? 
      @drink.inactive!
    else 
      @drink.active!
    end
    redirect_to restaurant_drink_path(@restaurant, @drink)
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

  def drink_params
    params.require(:drink).permit(:name, :description, :alcohol, :image)
  end
end