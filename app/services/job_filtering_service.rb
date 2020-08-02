class JobFilteringService
  def call(active_status:)
    return Job.where(active: true) if active_status == :active
    return Job.where(active: false) if active_status == :inactive
  end
end