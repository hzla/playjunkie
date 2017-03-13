class ImageProcesserWorker
  include Sidekiq::Worker

  def perform model_name, model_id	
  	model_name.constantize.find(model_id).save_and_process_image
  end
  
end