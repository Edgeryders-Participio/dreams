class GrantWallet < ApplicationRecord
    belongs_to :user
    belongs_to :event

    def grant_to(camp)
                
    end
end
