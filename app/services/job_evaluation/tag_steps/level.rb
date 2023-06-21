module JobEvaluation
  module TagSteps
    class Level < ::JobEvaluation::Step
      include EvaluationHelpers::TagStepHelper

      def call
        if job_title_includes_any_level_name?
          add_tag("graduate") if title_includes?("grad")
          add_tag("junior") if title_includes?("junior")
          add_tag("mid") if title_includes?("mid")
          add_tag("senior") if title_includes?("senior")
          add_tag("staff") if title_includes?("staff")
          add_tag("lead") if title_includes?("lead")
          add_tag("principle") if title_includes?("principle")
        else
          # assuming this because a "ruby engineer" would assumably be mid level
          job.tag_list.add(tags_yaml["Level"]["mid"])
        end

        job.save!
      end

      def can_handle?
        true
      end

      private

      def job_title_includes_any_level_name?
        all_level_names.any? { |level| title_includes?(level) }
      end


      def all_level_names
        ["graduate", "junior", "mid", "senior", "staff", "lead", "principle"]
      end

      def add_tag(tag)
        job.tag_list.add(tags_yaml["Level"][tag])
      end

      def title_includes?(str)
        job.title.downcase.include?(str)
      end
    end
  end
end
