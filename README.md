# README

Models 

Job has many technologies 
```clickhouse
job = Job.new(title: 'Ruby dev')
ruby = Technologies.new(name: 'Ruby')
job.technologies << ruby

job.technologies.include?(ruby)
=> true

ruby.jobs.include?(job)
=> true

```