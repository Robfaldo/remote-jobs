module JobServices
  class Technologies
    def self.technologies_in_title(job)
      job_technologies_in_title = job.job_technologies.select do |job_technology|
        job_technology.title_matches > 0
      end

      job_technologies_in_title.map do |job_technology|
        job_technology.technology
      end
    end

    def self.technologies_in_description(job)
      job_technologies_in_description = job.job_technologies.select do |job_technology|
        job_technology.description_matches > 0
      end

      job_technologies_in_description.map do |job_technology|
        job_technology.technology
      end
    end
  end
end
