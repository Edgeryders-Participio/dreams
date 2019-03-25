ActiveAdmin.register Event do
  actions :index, :show, :new, :create, :edit, :update, :destroy
  permit_params :organization_id, :name, :submission_deadline, :safety_deadline, :starts_at, :ends_at

  # TODO:
  # the default ActiveAdmin format for entering dates is ridiculously painful.
  # putting a datepicker in here of some kind will make this thing so much better.
  # https://github.com/activeadmin/activeadmin/wiki/Combine-datetime-picker-with-activeadmin
end
