class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant
  before_action :user_have_permition
  def new
    @order = @restaurant.orders.build
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def create
    @order = @restaurant.orders.build(order_params)
    if @order.save
      redirect_to restaurant_order_path(@restaurant, @order), notice: 'Pedido iniciado com sucesso..'
    else
      flash.now[:alert] = "ERRO"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @order = Order.find(params[:id])
  end
  private

  def order_params
    params.require(:order).permit(:client_name, :cpf, :phone, :email)
  end

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
end