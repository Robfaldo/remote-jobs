# README

Models 

Job has many technologies 
```clickhouse
job = Job.new(title: 'Ruby dev')
job.save
ruby = Technologies.new(name: 'Ruby')
ruby.save
job.technologies << ruby
job.save

job.technologies.include?(ruby)
=> true

ruby.jobs.include?(job)
=> true

```

Job has one level (and a level has many jobs) 
```clickhouse
job = Job.new(title: 'Ruby dev')
job.save
mid_level = Level.new(name: 'mid')
level.save
job.level = mid_level
job.save

job.level == mid_level
=> true

level.jobs.count 
=> 1

```