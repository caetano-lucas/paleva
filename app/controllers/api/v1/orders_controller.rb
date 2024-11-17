class Api::V1::OrdersController < ActionController::API
  
  def show
    begin
      restaurant = Restaurant.find_by(alphanumeric_code: params[:restaurant_alphanumeric_code])
      order = Order.find_by(alphanumeric_code: params[:order_alphanumeric_code])
      order_items = order.order_items
      if restaurant && order
        order_items = order.order_items.includes(portion: :portionable)
        
        render status: 200, json: {
          order: order.as_json(only: [:client_name, :created_at, :status]),
          order_items: order_items.map do |item|{
            portion_name: item.portion.portionable.name,
            portion_description: item.portion.description,
            note: item.note,
            quantity: item.quantity}
          end
        }
      else
        return render status: 404, json: '{}'
      end
    rescue
      return render status: 404, json: '{}'
    end
  end

  def index
    begin 
      restaurant = Restaurant.find_by(alphanumeric_code: params[:restaurant_alphanumeric_code])
      orders = restaurant.orders.where(status: [0,1,2,3]).sort.reverse
      render status: 200, json: {orders: orders.as_json(except: [:updated_at]), 
                               restaurant: restaurant.as_json(except: [:created_at, :updated_at])}
    rescue
      return render status: 404, json: '{}'
    end
  end
end

