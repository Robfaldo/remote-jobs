module JobEvaluation
  module FilterSteps
    class AlreadyAddedRecently < ::JobEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      FILTER_REASON = :already_added_recently

      def call
        filter_message = "Job has already been added within 1 week. Identical job ids: #{@identical_links_already_approved.map(&:id)}"
        filter_job(job, message: filter_message)
      end

      def can_handle?
        @identical_links_already_approved = Job.where(url: job.url).where.not(status: "scraped")
        @identical_links_already_approved.count > 0

        # we don't need to worry about duplicates for careers page jobs so can rely on just
        # the links being identical. For non-careers pages we have to check the title/content too
        # because a job can be posted across multiple job boards and we don't want to have the
        # same job scraped across multiple job boards

        # README: I'm going to try and allow duplicates that don't share the same link. This is because
        # I'm going for career page scrapes so the job board postings are just for me to find companies
        # to scrape their careers page and given i've only got 2 job board this logic doesn't seem worth it.
        # If you're future Rob and you're reading this and we haven't put this back in then you can probably
        # remove it

        # if !job_is_from_careers_page?
        #   identical_description_already_approved = Job.created_last_week.where(description: job.description)
        #
        #   matches_for_company_and_title =
        #     Job.created_last_week
        #        .where(company: job.company)
        #        .where("lower(title) LIKE ?", "#{job.title.downcase.strip}%")
        #
        #   @identical_jobs = identical_links_already_approved.to_ary.concat(matches_for_company_and_title.to_ary).concat(identical_description_already_approved.to_ary)
        #
        #   # over 1 because the Job has already been saved (we run this service after scraping & saving jobs) so there will be 1 matching already, any more means there's duplicates.
        #   identical_description_already_approved.count > 1 || matches_for_company_and_title.count > 1
        # end
      end
    end
  end
end
