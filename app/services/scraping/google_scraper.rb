require 'simple-rss'
require 'open-uri'
require 'capybara/rails'
require 'selenium-webdriver'
require 'webdrivers/chromedriver'

# TODO:
# - Extract the capybara config
# - Only add the scraped job if it doesn't exist already
# - Get it working in production

# https://agilie.com/en/blog/case-study-how-we-built-web-scraper-on-ruby-on-rails
# https://stackoverflow.com/questions/51233654/chrome-binary-not-found-on-heroku-with-selenium-for-ruby-on-rails
# https://readysteadycode.com/howto-scrape-websites-with-ruby-and-headless-chrome

##### Relocate
Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.default_driver = :headless_chrome
##### Relocate

module Scraping
  class GoogleScraper < Scraper
    INITIAL_SEARCH_URL = "https://www.google.com/search?q=(junior+AND+(engineer+OR+developer))+london&rlz=1C5CHFA_enGB775GB776&oq=jobs&aqs=chrome.0.69i59j69i57j35i39j69i60l3j69i65j69i60.336j0j7&sourceid=chrome&ie=UTF-8&ibp=htl;jobs&sa=X&ved=2ahUKEwiGjKPg_LntAhWOasAKHQN2CrcQutcGKAB6BAgGEAQ&sxsrf=ALeKk020K0pApP4dUPg-jChaQko5DOdrLw:1607278969548#fpstate=tldetail&htivrt=jobs&htilrad=24.1401&htichips=date_posted:today&htischips=date_posted;today&htidocid=-xi42l9ie5CmB-OZAAAAAA%3D%3D"

    def get_jobs(url: INITIAL_SEARCH_URL)
      session = Capybara::Session.new(:headless_chrome)
      session.visit(INITIAL_SEARCH_URL)

      current_job = 0
      jobs = []

      session.all('.PwjeAc').each do |job|
        job.find('div[jsname="DVpPy"]').click
        title = session.all('.KLsYvd').first.text
        description = session.all('.HBvzbc').first.text
        company = session.all('.tJ9zfc').first.all('div').first.text
        location = session.all('.tJ9zfc').first.all('div').last.text
        link = session.current_url

        jobs.push(
          ScrapedJob.new(
            title: title,
            company: company,
            link: link,
            location: location,
            description: description,
            source: :google
          )
        )

        current_job += 1
      end

      jobs
    end
  end
end
