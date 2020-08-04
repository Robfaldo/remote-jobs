class JobFilteringService
  class InvalidStackProvided < StandardError; end
  class InvalidLevelProvided < StandardError; end

  def initialize(valid_stacks: Stack.all, valid_levels: Level.all)
    @valid_stack_ids = valid_stacks.map{|s| s.id}
    @valid_level_ids = valid_levels.map{|l| l.id}
  end

  def call(active: nil, stacks: [], levels: [])
    raise InvalidStackProvided unless stacks.all? { |s| @valid_stack_ids.include?(s) }
    raise InvalidLevelProvided unless levels.all? { |l| @valid_level_ids.include?(l) }

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