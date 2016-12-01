class Weight < ApplicationRecord
  def self.rolling_average
    where("date > ?", 8.days.ago).average(:weight).to_f / 10
  end
end
