module JobEvaluation
  module TagSteps
    class Level < ::JobEvaluation::Step
      include EvaluationHelpers::TagStepHelper

      def call
        job.tag_list.add(tags_yaml["Level"]["graduate"]) if job.title.include?("grad")
        job.tag_list.add(tags_yaml["Level"]["junior"]) if job.title.include?("junior")
        job.tag_list.add(tags_yaml["Level"]["mid"]) if job.title.include?("mid")
        job.tag_list.add(tags_yaml["Level"]["senior"]) if job.title.include?("senior")
        job.tag_list.add(tags_yaml["Level"]["staff"]) if job.title.include?("staff")
        job.tag_list.add(tags_yaml["Level"]["lead"]) if job.title.include?("lead")
        job.tag_list.add(tags_yaml["Level"]["principle"]) if job.title.include?("principle")
        job.save!
      end

      def can_handle?
        true
      end
    end
  end
end
