require 'nokogiri'
require 'byebug'
require 'httparty'
require 'selenium-webdriver'

def go(user_agent=nil)
  Selenium::WebDriver::Firefox::Service.driver_path= 'bing_it/geckodriver'
  login_url =     'https://login.live.com/'
  search_url =    'http://www.bing.com/search?q='
  login_email =   LOGIN_EMAIL 
  login_passwd =  LOGIN_PASSWD 
  t = 5

  word_list_mobile = %w(crsr crm csco ibm amzn goog spce bb adbe nflx fb aapl tsla msft amd pg atvi gme amc jnj nvda eth bitcoin lumen xrp)
  word_list_pc = [ 'The Vanguard Group', 'BlackRock', 'Berkshire Hathaway', 'State Street Corporation', 'Fidelity Investments', 'Luca Maestri', 'Jeff Williams', 'Eddy Cue', 'Hewlett-Packard', 'Steve Jobs', 'Steve Wozniak', 'Ron Wayne', 'Tim Cook', 'Arthur D. Levinson', 'Samsung', 'Huawei', 'nasdaq', 'russell 2000', 'djia', 's&p 500', 'cl', 'jpm', 'lumber futures', 'lmt', 'boeing', 'gold spot price', 'silver spot price', 'virgin galactic', 'micron', 'dkng' ]

  # nav to url
  profile = Selenium::WebDriver::Firefox::Profile.new()
  profile['general.useragent.override'] = user_agent unless user_agent.nil?
  driver = Selenium::WebDriver.for :firefox, profile: profile
  driver.navigate.to login_url

  # email
  puts 'Logging in ...'
  login = driver.find_element(name: 'loginfmt')
  login.clear()
  login.send_keys(login_email)
  sleep t
  login.send_keys(:return)
  sleep t

  # passwd
  passwd = driver.find_element(name: 'passwd')
  passwd.clear()
  passwd.send_keys(login_passwd)
  sleep t
  passwd.send_keys(:return)
  sleep 7

  # start searching
  puts 'Searching ...'
  word_list = user_agent.nil? ? word_list_pc : word_list_mobile
  word_list.each do |word|
    driver.get('https://bing.com')
    sleep t
    new_search = driver.find_element(name: 'q')
    new_search.clear()
    new_search.send_keys(word)
    sleep t
    new_search.send_keys(:return)
    sleep t
  end

  driver.quit
  puts 'Done'
end
%x(echo "Running: #{Time.now}" | tee -a  ~/Documents/do_it/do_it.log > /dev/null)
user_agent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148'
go(user_agent)
go
