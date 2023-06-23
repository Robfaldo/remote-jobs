class ScraperMailer < ApplicationMailer
  default from: 'robswebscraper@gmail.com'

  def job_save_error_html(html:, job: nil, error:, rollbar_uuid:)
    if job
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
    else
      body = %{
        No job information available.

        Error: #{error}

        Rollbar_uuid: #{rollbar_uuid}

        This error occured when trying to save a job preview.
      }
      subject = "HTML debug: rollbar error: #{rollbar_uuid}"
    end

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
      # this password is an "app password". To generate a new one you can go to
      # https://myaccount.google.com/ and then search for "app passwords" in the search
      # bar and then generate a new one. 
      :password             => ENV["GMAIL_PASSWORD"],
      :authentication       => "plain",
      :enable_starttls_auto => true
    }
  end
end
