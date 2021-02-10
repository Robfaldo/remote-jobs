class ScraperMailer < ApplicationMailer
  default from: 'robswebscraper@gmail.com'

  def error_html_log(html)
    mail(to: 'robertfaldo@gmail.com',
         subject: 'Scraping error html log',
         content_type: 'text/html',
         body: html)
  end
end
