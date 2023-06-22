class ScraperMailer < ApplicationMailer
  default from: 'robswebscraper@gmail.com'

  def job_save_error_html(html:, job:, error:, rollbar_uuid:)
    body = %{
      Title: #{job["title"]}
      Company: #{job["company"]}
      Link: #{job["url"]}

      Source: #{job["source"]}

      Error: #{error}

      Rollbar_uuid: #{rollbar_uuid}

      This error occured when trying to save a job
    }

    subject = "HTML debug: #{job["source"]} - #{job["title"]}"

    attachments['scraped_page.html'] = { :mime_type => 'text/html',
                                         :content => html }
    mail(to: 'robswebscraper@gmail.com',
         subject: subject,
         body: body,
         delivery_method_options: gmail_smtp_settings) # this line gets mailer to use gmail not godaddy
  end

  def gmail_smtp_settings
    {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'gmail.com',
      :user_name            => "robswebscraper@gmail.com",
      :password             => ENV["GMAIL_PASSWORD"],
      :authentication       => "plain",
      :enable_starttls_auto => true
    }
  end
end
