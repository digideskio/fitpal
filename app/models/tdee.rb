class Tdee < ApplicationRecord
  BODYFAT = 18.freeze

  def self.calculate_for_weight(weight)
    370 + (21.6 * (weight.to_f * bodyfat_multiplier))
  end

  def self.bodyfat_multiplier
    (100.to_f - BODYFAT) / 100
  end
end
