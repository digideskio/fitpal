class Tdee < ApplicationRecord
  BODYFAT = 17.freeze

  def self.calculate_for_weight(weight)
    370 + (21.6 * (weight.to_f * bodyfat_multiplier))
  end

  def self.bodyfat_multiplier
    (100.to_f - (ENV['BODYFAT'].to_f || BODYFAT)) / 100
  end
end
