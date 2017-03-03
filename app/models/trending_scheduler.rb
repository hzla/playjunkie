require 'sidekiq-scheduler'

class TrendingScheduler
  include Sidekiq::Worker

  def perform
  	Quiz.where(is_preview?: true).destroy_all
    Quiz.shift_daily_view_counts
  end
end