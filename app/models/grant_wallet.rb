class GrantWallet < ApplicationRecord
    belongs_to :user
    belongs_to :event

    def grant_to(camp, requested_grants)
        num_grants = [requested_grants, self.grants_left, app_setting('max_grants_per_user_per_dream')].min
        
        camp.grants.build(user: self.user, amount: num_grants)
        camp.assign_attributes(
            minfunded:   (camp.grants_received + num_grants) >= @camp.minbudget,
            fullyfunded: (camp.grants_received + num_grants) >= @camp.maxbudget
        )

        return 0, false unless camp.save

        self.assign_attributes!(grants_left: self.grants_left - num_grants)
        return num_grants, true
    end
end
