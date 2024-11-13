class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :redirect_unless_restaurant
  before_action :user_have_permition
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @order = @restaurant.orders.build
  end

  def index
    @orders = @restaurant.orders.order(updated_at: :desc)
  end

  def show
    @order = Order.find(params[:id])    
    redirect_to edit_restaurant_order_path(@restaurant, @order)
  end

  def create
    @order = @restaurant.orders.build(order_params)
    if @order.save
      redirect_to edit_restaurant_order_path(@restaurant, @order), notice: 'Pedido iniciado com sucesso..'
    else
      flash.now[:alert] = "ERRO Cardapio já cadastrado"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @menus = @restaurant.menus
    @order = Order.find(params[:id])
    @order_items = @order.order_items
  end

  def update
   
    @order = @restaurant.orders.find(params[:id])
   
    if params[:order_item][:portion_ids]
      item_total_price = 0
      @order.total_price = 0
      params[:order_item][:portion_ids].each do |portion_id|
        portion = Portion.find(portion_id)
        quantity = params[:order_item][:quantity][portion_id]
        note = params[:order_item][:notes][portion_id]
        order_item = OrderItem.create!(portion: portion, order: @order, note: note.present? ? note : nil, quantity: quantity.present? ? quantity : 1, price: portion.price_whole.to_i, cents: portion.price_cents.to_i)
        item_total_price = (order_item.price * order_item.quantity.to_i) + (order_item.cents * order_item.quantity.to_i / 100.0)
        @order.total_price += item_total_price
      end
      @order.aguardando_confirmacao_cozinha!
      @order.save
    end
      redirect_to  restaurant_orders_path(current_user.restaurant), notice: 'Pedido enviado a cozinha..'
  end
  
  private

  def order_params
    params.require(:order).permit(:client_name, :cpf, :phone, :email, :id, :portion_ids, :note, :quantity, :status)
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