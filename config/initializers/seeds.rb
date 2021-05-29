# These are seeds we want to run when we load the app. Do NOT include
# seeds that we only want in local/test environments

def database_exists?
  ActiveRecord::Base.connection
rescue ActiveRecord::NoDatabaseError
  false
else
  true
end

def table_exists?(name)
  ActiveRecord::Base.connection.table_exists? name
end

if database_exists? && table_exists?('technologies')
  DatabaseSeeds::Technologies.call
end
