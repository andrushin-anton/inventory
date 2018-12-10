class ItemController < ApplicationController
    before_action :set_item, only: [:show, :edit, :update, :destroy]

    def show
        authorize! :show, @item
    end
    
    def new
        authorize! :new, Item    
        @item = Item.new
    end

    def edit
        authorize! :edit, @item

        @item_history = ItemHistory.where(item_id: @item.id).order(created_at: :desc).page(params[:page])
    end

    def create
        authorize! :create, Item

        @item = Item.new(allowed_params)

        respond_to do |format|
            if @item.save
            format.html { redirect_to edit_item_path(@item), notice: "#{@item.name} was successfully created!" }
            format.json { render :show, status: :created, location: @item }
            else
            format.html { render :new }
            format.json { render json: @item.errors, status: :unprocessable_entity }
            end
        end
    end

    def item_history_create
        authorize! :create, Item

        @item_history = ItemHistory.new(allowed_history_params)
        @item_history.author = current_user.first_name + current_user.last_name
        @item_history.item_id = params[:id]

        respond_to do |format|
            if @item_history.save
            
            item = Item.find(params[:id])
            item.quantity = item.quantity + @item_history.quantity
            item.save

            format.html { redirect_back fallback_location: root_path, notice: "Quantity was successfully updated!" }
            format.json { render :show, status: :created, location: @item }
            else
            format.html { render :new }
            format.json { render json: @item.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        authorize! :update, @item

        respond_to do |format|
            if @item.update(allowed_params)
            format.html { redirect_to root_path, notice: "#{@item.name} was successfully updated!" }
            format.json { render :show, status: :ok, location: @item }
            else
            format.html { render :edit }
            format.json { render json: @item.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        authorize! :destroy, @item

        if @item.update({status: :deleted})
            redirect_to root_path, notice: "#{@item.name} was successfully removed!" 
        else
            format.html { render :edit }
            format.json { render json: @item.errors, status: :unprocessable_entity }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_item
            @item = Item.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def allowed_params
            params.require(:item).permit(:name, :price, :description)
        end

        def allowed_history_params
            params.require(:item_history).permit(:quantity, :description)
        end

end
