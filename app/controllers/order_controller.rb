require 'digest/md5'

class OrderController < ApplicationController
    before_action :set_order, only: [:show, :edit, :update, :destroy, :order_item_add, :order_item_remove, :order_custom_item_create]

    def index
        authorize! :index, Order

        @orders = Order.order(created_at: :desc).page(params[:page])
    end

    def show
        authorize! :show, @order

        @order_items = OrderItem.where(order_id: @order.id).order(created_at: :asc)
    end
    
    def new
        authorize! :new, Order    
        @order = Order.new
    end

    def edit
        authorize! :edit, @order

        @items = Item.where(status: :active).order(created_at: :desc).page(params[:page])
        
        @order_items = OrderItem.where(order_id: @order.id).order(created_at: :asc)
    end

    def create
        authorize! :create, Order

        @order = Order.new(allowed_params)

        respond_to do |format|
            if @order.save
            format.html { redirect_to edit_order_path(@order), notice: "#{@order.pid} was successfully created!" }
            format.json { render :show, status: :created, location: @order }
            else
            format.html { render :new }
            format.json { render json: @order.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        authorize! :update, @order

        respond_to do |format|
            if @order.update(allowed_params)
            format.html { redirect_to root_path, notice: "#{@order.pid} was successfully updated!" }
            format.json { render :show, status: :ok, location: @order }
            else
            format.html { render :edit }
            format.json { render json: @order.errors, status: :unprocessable_entity }
            end
        end
    end

    def order_item_add
        authorize! :create, Item

        @item = Item.find(params[:item_id])
        # check if the order item already exists in order details
        @order_item = OrderItem.where(order_id: @order.id, item_id: @item.id).first
        
        respond_to do |format|
            if @order_item.nil?
                # add to order 
                @order_item = OrderItem.new({item_name: @item.name, quantity: 1, price: @item.price, item_id: @item.id, order_id: @order.id})
                if @order_item.save 
                    # decrement Item quantity
                    @item.quantity = @item.quantity - 1
                    @item.save
                end
            else
                @order_item.quantity = @order_item.quantity + 1
                if @order_item.save 
                    # decrement Item quantity
                    @item.quantity = @item.quantity - 1
                    @item.save
                end
            end
            
            format.html { redirect_back fallback_location: root_path, notice: "#{@order_item.item_name} was successfully added!" }
            format.json { render :show, status: :created, location: @order }
        end
    end

    def order_item_remove
        authorize! :create, Item

        @item = Item.find(params[:item_id])
        # check if the order item already exists in order details
        @order_item = OrderItem.where(order_id: @order.id, item_id: params[:item_id]).first
        
        respond_to do |format|

            @order_item.quantity = @order_item.quantity - 1
            if @order_item.save 
                if @item
                    # increment Item quantity
                    @item.quantity = @item.quantity + 1
                    @item.save
                end
            end

            # remove order item if quantity is 0
            if @order_item.quantity <= 0
                @order_item.destroy
            end
                        
            format.html { redirect_back fallback_location: root_path, notice: "#{@order_item.item_name} was successfully added!" }
            format.json { render :show, status: :created, location: @order }
        end
    end

    def order_custom_item_create
        authorize! :create, Item

        @new_order_item = OrderItem.new(allowed_custom_item_params)
        # item_id is always = 0 for custiom items
        @new_order_item.item_id = @order.id.to_s + '_' + Digest::MD5.hexdigest(@new_order_item.item_name)
        # check if the order item already exists in order details
        @order_item = OrderItem.where(order_id: @order.id, item_id: @new_order_item.item_id).first
        
        respond_to do |format|
            if @order_item.nil?
                # add to order 
                @new_order_item.order_id = @order.id
                if @new_order_item.save
                    if @order.delivery_time < @new_order_item.delivery_time
                        @order.delivery_time = @new_order_item.delivery_time 
                        @order.save
                    end
                end
            else 
                @order_item.quantity = @order_item.quantity + @new_order_item.quantity
                @order_item.save    
            end
            
            format.html { redirect_back fallback_location: root_path, notice: "A new item was successfully added!" }
            format.json { render :show, status: :created, location: @order }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_order
            @order = Order.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def allowed_params
            params.require(:order).permit(:pid, :customer, :status, :delivery_time)
        end

        def allowed_custom_item_params
            params.require(:custom_item).permit(:quantity, :item_name, :price, :delivery_time)
        end

end
