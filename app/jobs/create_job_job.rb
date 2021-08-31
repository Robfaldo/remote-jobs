# Weird name I know, because we're saving a job (i.e a job that's advertised on a job website)
# but this is a sidekiq job and the naming convention is to end in Job.
class CreateJobJob < ApplicationJob
  queue_as :calls_database

  def perform(...)
    binding.pry

    CreateJobService.call(...)
  end
end
