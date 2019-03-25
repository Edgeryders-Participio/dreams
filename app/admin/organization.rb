ActiveAdmin.register Organization do
  actions :index, :show, :new, :create, :edit, :update, :destroy
  permit_params :name
end
