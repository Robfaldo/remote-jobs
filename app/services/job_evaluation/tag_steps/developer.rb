# Purpose of this tag is to determine if the job is a developer (rather than tester, devops, data etc...)
module JobEvaluation
  module TagSteps
    class Developer < ::JobEvaluation::Step
      include ::JobEvaluation::Helpers::TagHelper

      def call
        job.tag_list.add(tags_yaml["Groups"]["developer"])
        job.save!
      end

      def can_handle?
        JobEvaluators::CheckIfDeveloperJob.check_title_and_description(job)
      end
    end
  end
end
