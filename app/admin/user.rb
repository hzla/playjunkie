ActiveAdmin.register User do

  permit_params :name, :email, :description, :profile_pic_url, :is_admin?, :is_banned? 

  index do
    column :id
    column :name
    column :email
    column :is_admin?
    actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
   f.inputs "Livestream Details" do
     f.inputs :name
     f.inputs :email
     f.inputs :description
     f.inputs :is_admin?
     f.inputs :is_banned?
   end
  f.actions
 end
end

