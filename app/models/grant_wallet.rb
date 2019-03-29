class GrantWallet < ApplicationRecord
    belongs_to :user
    belongs_to :event

    def grant_to(camp, requested_grants)
        max_grants_per_user_per_dream = Rails.configuration.x.firestarter_settings['max_grants_per_user_per_dream']
        num_grants = [requested_grants, self.grants_left, max_grants_per_user_per_dream].min

        til_funded = camp.maxbudget - num_grants
        num_grants = til_funded if num_grants > til_funded
        
        camp.grants.build(user: self.user, amount: num_grants)
        camp.assign_attributes(
            minfunded:   (camp.grants_received + num_grants) >= camp.minbudget,
            fullyfunded: (camp.grants_received + num_grants) >= camp.maxbudget
        )

        return 0, false unless camp.save
        self.update_attributes!(grants_left: self.grants_left - num_grants)

        return num_grants, true
    end
end
