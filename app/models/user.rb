class User < ApplicationRecord
    has_secure_password
    after_initialize :default_values

    validates :email, presence: true, uniqueness: true, length: { maximum: 70 }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
    validates :email, :uniqueness => true, on: [:save]

    paginates_per  20

    def self.roles
        {admin: :admin, user: :user}
    end    

     private
        def default_values
            self.status ||= 'ACTIVE'
        end
end
