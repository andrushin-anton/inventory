class Order < ApplicationRecord
    paginates_per  20
    after_initialize :default_values

    def self.statuses
        {waiting: :waiting, inproduction: :inproduction, readyforpickup: :readyforpickup, pickedup: :pickedup}
    end

    def self.color
        case self.status 
        when :waiting
            return 'red'
        when :inproduction
            return 'blue'
        when :readyforpickup
            return 'yellow'
        when :pickedup
            return 'green'
        end
    end

    private
        def default_values
            self.status ||= :waiting
        end
end
