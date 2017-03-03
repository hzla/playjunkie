class TrendingAjusterWorker
  include Sidekiq::Worker

  def perform
  	Quiz.shift_daily_view_counts
  end
  
end