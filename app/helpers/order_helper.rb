module OrderHelper
    
    def add_to_order_btn(order, item)
        btn_class = 'btn btn-info btn-xs'
        if item.quantity <= 0
            btn_class = btn_class + ' disabled'
        end
        link_to '<i class="fa fa-plus"></i> Add to order'.html_safe, order_item_add_path(order.id, item.id), :class => btn_class
    end

    def order_total(order_items)
        total = 0.0

        order_items.each do |item|
            total = total + (item.quantity * item.price)
        end
        return total.to_s
    end

end
