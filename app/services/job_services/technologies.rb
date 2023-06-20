module JobServices
  class Technologies
    def initialize(job)
      @job = job
    end

    def main_technology_names
      job.job_technologies.select{|jt| jt.main_technology }.map(&:technology).map(&:name)
    end

    def technology_names_in_title
      job_technologies_in_title.map {|job_technology| job_technology.technology.name }
    end

    def programming_language_names_in_title
      programming_language_technologies_in_title.map{ |technology| technology.name }
    end

    private

    attr_reader :job

    def job_technologies_in_title
      job.job_technologies.where('title_matches > ?', 0)
    end

    def programming_language_technologies_in_title
      job_technologies_in_title.select do |job_technology|
        job_technology.technology.is_language
      end.map(&:technology)
    end
  end
end
