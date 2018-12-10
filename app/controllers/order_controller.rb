class OrderController < ApplicationController
    before_action :set_order, only: [:show, :edit, :update, :destroy]

    def index
        authorize! :index, Order

        @orders = Order.order(created_at: :desc).page(params[:page])
    end

    def show
        authorize! :show, @order
    end
    
    def new
        authorize! :new, Order    
        @order = Order.new
    end

    def edit
        authorize! :edit, @order

        # @item_history = ItemHistory.where(item_id: @item.id).order(created_at: :desc).page(params[:page])
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

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_order
            @order = Order.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def allowed_params
            params.require(:item).permit(:customer, :status, :delivery_time)
        end

end
