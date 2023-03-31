task :test_rollbar => :environment do
  raise "An error to test rollbar"
end
