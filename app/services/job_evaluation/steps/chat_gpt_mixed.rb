module JobEvaluation
  module Steps
    class ChatGptMixed < ::JobEvaluation::Step
      def call
        response = ChatGpt.new.send_first_message(prompt)
        data = JSON.parse(response)

        raise_error_if_unexpected_response_data(data)
        notify_if_unsure(data)

        if rails_is_a_main_technology?(data)
          mark_technology_as_main("rails")
        end

        if ruby_is_a_main_technology?(data)
          mark_technology_as_main("ruby")
        end

        job.remote_status = data["remote_status"]
        job.save!
      end

      def can_handle?
        job.tag_list.include?("developer") && (job_includes_ruby || job_includes_rails)
      end

      private

      def rails_is_a_main_technology?(data)
        title_technology_names.include?('rails') || (data["rails_web_framework"] == "true" && job_includes_rails)
      end

      def ruby_is_a_main_technology?(data)
        title_technology_names.include?('ruby') || (data["ruby"] == "true" && job_includes_ruby)
      end

      def title_technology_names
        job.technologies_in_title.map {|job_technology| job_technology.technology.name }
      end

      def raise_error_if_unexpected_response_data(data)
        return if ["true", "false", "unsure"].include?(data["rails_web_framework"])
        return if ["true", "false", "unsure"].include?(data["ruby"])
        return if ["office based", "hybrid", "fully remote", "unsure"].include?(data["remote_status"])

        additional = {
          job_id: job.id,
          chat_gpt_data: data
        }

        SendToErrorMonitors.send_error(error: "ChatGPT response is invalid.", additional: additional)
      end

      def notify_if_unsure(data)
        if data["rails_web_framework"] == "unsure" || data["ruby"] == "unsure" || data["remote_status"] == "unsure"
          additional = {
            job_id: job.id,
            chat_gpt_data: data
          }

          SendToErrorMonitors.send_notification(message: "ChatGPT response is unsure.", additional: additional)
        end
      end

      def mark_technology_as_main(technology)
        job_technology = job.job_technologies.find{|job_t| job_t.technology.name == technology }
        job_technology.main_technology = true
        job_technology.save!
      end

      def job_includes_ruby
        job.technologies.map(&:name).include?("ruby")
      end

      def job_includes_rails
        job.technologies.map(&:name).include?("rails")
      end

      def prompt
        <<~PROMPT
  I'm going to give you a job description and job title and you are going to extract information into the following JSON format, you will respond with only this JSON and no other text:
  
  {
  "rails_web_framework":"string",
  "ruby":"string",
  "remote_status":"string"
  }
  
  Each key in the JSON above is the data that you are extracting and they should remain the same. You should change the values of the JSON above and here are the rules for what value you should provide.
  
  1. "rails_web_framework" value rule:
  * response type: you will reply with only "true", "false" or "unsure" (always lower case with no punctuation or other words). 
  * It will be "true" if the main web framework that the job would be writing code for is the rails framework. 
  * if you are not at least 75% confident what the main web framework is it will be "unsure"
  * if you are confident what the web framework is but it is not rails then it will be "false"
  
  2. "ruby" value rule:
  * response type: you will reply with only "true", "false" or "unsure" (always lower case with no punctuation or other words). 
  * It will be "true" if the rails_web_framework is "true" (because rails uses ruby)
  * It will be "true" if the rails_web_framework is "false" but the job will mainly be using the ruby programming language. The job description might mention ruby but that does not mean it is the main language, for example it might be mentioning that they are looking for people who know ruby but the job won't involve writing ruby code. It is only true if the main focus of the job will be as a ruby developer.
  * It will be "unsure if you are not at least 75% confident that the main programming language is ruby
  
  2. "remote_status" value rule:
  * response type: you will reply with only "fully remote", "hybrid", "office based" or "unsure" (always lower case with no punctuation or other words). 
  * It will be "fully remote" if there is the option to be fully remote or if the only option is to be fully remote
  * It will be "hybrid" if you need to go to the office regularly but can spend a lot of time working from home
  * It will be "office based" if you need to be in the office for the majority of the time
  * It will be "unsure" if you are not at least 75% confident that one of the other options applies
  
  For example you could respond with: 
  
  {
  "rails_web_framework":"true",
  "ruby":"true",
  "remote_status":"office based"
  }
  
  Example for if you were not confident on the ruby language:
  
  {
  "rails_web_framework":"true",
  "ruby":"unsure",
  "remote_status":"office based"
  }
  
  The title of the job is: #{job.title}
  
  The job description is:
  #{job.description}
        PROMPT
      end
    end
  end
end
