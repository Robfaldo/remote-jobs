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

Job has one stack (and a stack has many jobs)
```clickhouse
job = Job.new(title: 'Ruby dev')
job.save
backend = Stack.new(name: 'backend')
backend.save
job.stack = backend
job.save

job.stack == backend
=> true

stack.jobs.count 
=> 1

```

Job has one company (and a company has many jobs)
```clickhouse
job = Job.new(title: 'Ruby dev')
job.save
kelvinltd = Company.new(name: 'kelvinltd')
kelvinltd.save
job.company = kelvinltd
job.save

job.company == kelvinltd
=> true

kelvinltd.jobs.count 
=> 1

```