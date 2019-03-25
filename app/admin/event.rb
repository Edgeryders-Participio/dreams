ActiveAdmin.register Event do
  actions :index, :show, :new, :create, :edit, :update, :destroy
  permit_params :organization_id, :name, :submission_deadline, :safety_deadline, :starts_at, :ends_at


  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :organization, as: :select, collection: Organization.all
      f.input :submission_deadline, as: :datepicker 
      f.input :safety_deadline, as: :datepicker 
      f.input :starts_at, as: :datepicker 
      f.input :ends_at, as: :datepicker 
    end
    f.actions
  end
end
