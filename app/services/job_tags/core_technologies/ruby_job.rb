module JobTags
  module CoreTechnologies
    class RubyJob < Tag
      def add_tag
        job.tag_list.add(tags_yaml["Technologies"]["ruby_job"])
        job.save!
      end

      def can_handle?
        technologies_in_title = JobServices::Technologies.technologies_in_title(job)

        title_includes_ruby_or_rails(technologies_in_title)
      end

      private

      def title_includes_ruby_or_rails(technologies_in_title)
        technologies_in_title.map(&:name).include?('ruby') ||
          technologies_in_title.map(&:name).include?('rails')
      end
    end
  end
end
