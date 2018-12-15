class Order < ApplicationRecord
    paginates_per  20
    after_initialize :default_values

    def self.statuses
        {waiting: :waiting, inproduction: :inproduction, readyforpickup: :readyforpickup, pickedup: :pickedup}
    end

    def color
        case self.status.to_sym 
        when :waiting
            return 'background-color:red; color:white'
        when :inproduction
            return 'background-color:blue; color:white'
        when :readyforpickup
            return 'background-color:yellow; color:black'
        when :pickedup
            return 'background-color:green; color:white'
        end
    end

    private
        def default_values
            self.status ||= :waiting
            self.delivery_time ||= DateTime.now
        end
end
