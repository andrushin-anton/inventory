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
    end

    def create
        authorize! :create, Item

        @item = Item.new(allowed_params)

        respond_to do |format|
            if @item.save
            format.html { redirect_to root_path, notice: "#{@item.name} was successfully created!" }
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

end
