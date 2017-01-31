ActiveAdmin.register Quiz do

  permit_params :title, :description, :user_id, :completion_message, :quiz_type, :image, :published, :view_count, :featured, :homepage_pick, :browse_pick, :publish_date

  index do
    column :id
    column :title
    column :description
    actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
   f.inputs "Livestream Details" do
     f.inputs :title
     f.inputs :description
     f.inputs :user_id
     f.inputs :quiz_type
     f.inputs :image
     f.inputs :view_count
     f.inputs :publish_date
     f.inputs :completion_message
     f.inputs :featured
     f.inputs :homepage_pick
     f.inputs :browse_pick
   end
  f.actions
 end
end




