class JobFilteringService
  def call(active_status:)
    Job.where(active: true) if active_status == :active
  end
end