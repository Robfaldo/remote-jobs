class JobFilteringService
  def call(active: nil)
    return Job.where(active: active) unless active.nil?

    Job.all
  end
end