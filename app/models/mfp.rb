class MFP
  def self.app
    Sinatra::Application
  end
  def app
    Sinatra::Application
  end
  def self.session
    @session ||= begin
                   # Capybara.register_driver :mydriver do |_|
                   #   app = Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }
                   #   Capybara::RackTest::Driver.new(app)
                   # end
                   Capybara.current_driver = :mydriver
                          Capybara.register_driver :poltergeist do |app|
                            Capybara::Poltergeist::Driver.new(app, {js_errors: false, timeout: 90})
                          end
                          Capybara.configure do |config|
                            config.run_server = false
                            config.app_host = 'https://www.myfitnesspal.com'
                          end
                          Capybara.current_driver = :poltergeist
                          Capybara.current_session
                   # Capybara.register_driver :mechanize do |app|
                   #   driver = Capybara::Mechanize::Driver.new(app)
                   #   driver.configure do |agent|
                   #     agent.user_agent_alias = 'Mac Safari'
                   #   end
                   #   driver
                   # end
                   # Capybara.app_host = 'https://www.myfitnesspal.com'
                   # Capybara.default_driver = :mechanize
                   # Capybara.current_session
                 end
  end

  def self.pull_weight
    log_in
    session.click_link 'My Home'
    session.click_link 'Check-In'
    session.body.scan(/Last recorded weight: (\d\d\.\d)/).first.first.to_f * 10
  end

  def self.log_in
    session.visit '/account/login'
    session.fill_in 'username', with: ENV.fetch('MFP_USERNAME')
    session.fill_in 'password', with: ENV.fetch('MFP_PASSWORD')
    session.find('li.submit input[type=submit]').click
  end

  def self.training_day_macros
    bodyweight = Weight.rolling_average
    bodyweight_in_lbs = bodyweight * 2.20462
    protein = (bodyweight_in_lbs * Tdee.bodyfat_multiplier) * 1.3
    protein_calories = protein * 4
    tdee_calorie_goal = Tdee.find_by(date: Date.today).tdee * 1.2 # sedentary = 1.2 multiplier
    calorie_goal = tdee_calorie_goal * (ENV['TRAINING_MULTIPLIER'].to_i || 1.1)
    calories_without_protein = (calorie_goal - protein_calories).to_f
    fat = calories_without_protein * 0.25 / 9
    carbs = calories_without_protein * 0.75 / 4
    {protein: protein.round(2), fat: fat.round(2), carbs: carbs.round(2)}
  end

  def self.rest_day_macros
    bodyweight = Weight.rolling_average
    bodyweight_in_lbs = bodyweight * 2.20462
    protein = (bodyweight_in_lbs * Tdee.bodyfat_multiplier) * 1.3
    protein_calories = protein * 4
    tdee_calorie_goal = Tdee.find_by(date: Date.today).tdee * 1.2 # sedentary = 1.2 multiplier
    calorie_goal = tdee_calorie_goal * (ENV['REST_MULTIPLIER'].to_i || 0.8)
    calories_without_protein = (calorie_goal - protein_calories).to_f
    fat = calories_without_protein / 2 / 9
    carbs = calories_without_protein / 2 / 4
    {protein: protein.round(2), fat: fat.round(2), carbs: carbs.round(2)}
  end

  def self.set_macros(protein:, fat:, carbs:)
    log_in
    session.visit '/account/my_goals/daily_nutrition_goals'
    sleep 5
    session.all('.mfp-input')[0].set(carbs)
    session.all('.mfp-input')[1].set(fat)
    session.all('.mfp-input')[2].set(protein)
    session.find(:css, 'a.button.save-changes').click
  end
end
