class InventoryController < ApplicationController

    def index
        authorize! :index, Inventory

        @items = Item.where(status: :active).order(created_at: :desc).page(params[:page])
    end

end