class Item < ApplicationRecord
    paginates_per  20
    after_initialize :default_values
    
    def self.statuses
        {active: :active, deleted: :deleted}
    end  

    private
        def default_values
            self.status ||= :active
        end

end
