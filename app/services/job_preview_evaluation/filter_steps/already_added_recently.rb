module JobPreviewEvaluation
  module FilterSteps
    class AlreadyAddedRecently < ::JobPreviewEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      FILTER_REASON = :already_added_recently

      def call
        filter_job(job_preview, message: "Rejected: job_preview has already been added within 1 week, jobs deemed identical: #{@identical_links_already_approved.map(&:id)}")
      end

      def can_handle?
        @identical_links_already_approved = Job.where(url: job_preview.url)
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
        #   existing_company = CompanyServices::FindCompany.call(job_preview.company)
        #
        #   matches_for_company_and_title =
        #     Job.created_last_week
        #        .where(company: existing_company)
        #        .where("lower(title) LIKE ?", "#{job_preview.title.downcase.strip}%")
        #
        #   @identical_jobs = identical_links_already_approved.to_ary.concat(matches_for_company_and_title.to_ary)
        #
        #   return matches_for_company_and_title.count > 0
        # end
      end
    end
  end
end
