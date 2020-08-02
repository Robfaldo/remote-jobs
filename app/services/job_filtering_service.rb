class JobFilteringService
  def call(active: nil, stacks: [])
    jobs_to_filter = if active.nil?
                       Job.all
                     else
                       Job.where(active: active)
                     end

    if stacks.count > 0
      jobs_to_filter.select{|job| stacks.include?(job.stack.id)} if stacks
    else
      jobs_to_filter
    end
  end
end