module TopRatingCalculations
  extend ActiveSupport::Concern

  class_methods do
    def top(num)
      all.sort_by { |instance| instance.average_rating || 0 }.reverse.take(num)
    end
  end
end
