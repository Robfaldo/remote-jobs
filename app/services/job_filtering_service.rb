class JobFilteringService
  class InvalidStackProvided < StandardError; end

  def initialize(valid_stacks: Stack.all)
    @valid_stack_ids = valid_stacks.map{|s| s.id}
  end

  def call(active: nil, stacks: [])
    raise InvalidStackProvided unless stacks.all? { |s| @valid_stack_ids.include?(s) }

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