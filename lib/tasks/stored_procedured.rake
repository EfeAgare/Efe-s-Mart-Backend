namespace :stored_procedured do
  task :migrate do
    # The logic of importing sql to database
    Dir[Rails.root + "/db/*.sql"].each do |file|
      sql = File.read(file)  
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end