class MacrosController < ApplicationController
  def index
  end

  def calculate_tdee
    tdee = Tdee.find_or_initialize_by(date: Date.today)
    tdee.tdee = Tdee.calculate_for_weight(Weight.rolling_average)
    tdee.save
    redirect_to :back
  end

  def pull_weight
    weight = Weight.find_or_initialize_by(date: Date.today)
    weight.weight = MFP.pull_weight
    weight.save
    redirect_to :back
  end

  def set_training_day_macros
    MFP.set_macros(**MFP.training_day_macros)
    redirect_to :back
  end

  def set_rest_day_macros
    MFP.set_macros(**MFP.rest_day_macros)
    redirect_to :back
  end
end
