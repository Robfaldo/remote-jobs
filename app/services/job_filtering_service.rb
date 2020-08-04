class JobFilteringService
  class InvalidStackProvided < StandardError; end

  def initialize(valid_stacks: Stack.all)
    @valid_stack_ids = valid_stacks.map{|s| s.id}
  end

  def call(active: nil, stacks: [], levels: [])
    raise InvalidStackProvided unless stacks.all? { |s| @valid_stack_ids.include?(s) }

    filtered_jobs = if active.nil?
                       Job.all.to_a
                     else
                       Job.where(active: active).to_a
                     end

    if stacks.count > 0
      filtered_jobs.select!{|job| stacks.include?(job.stack.id)}
    end

    if levels.count > 0
      filtered_jobs.select!{|job| levels.include?(job.level.id)}
    end

    filtered_jobs
  end
end