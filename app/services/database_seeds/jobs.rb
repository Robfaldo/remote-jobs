module DatabaseSeeds
  class Jobs
    def self.call
      i = 0
      10.times do
        job = Job.new(
          title: "Test title #{i}",
          job_link: "https://www.google.com/",
          location: "London",
          description: "Test description #{i}",
          source: ["indeed", "stackoverflow", "google"].sample,
          status: "scraped",
          company: "Test company #{i}"
        )

        job.source_id = "Test source id #{i}" if [1, 2].sample.even?
        job.job_board = "Test job board #{i}" if [1, 2].sample.even?

        job.save!
        i += 1
      end
    end
  end
end


