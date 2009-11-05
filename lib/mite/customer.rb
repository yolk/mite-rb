class Mite::Customer < Mite::Base
  
  include Mite::ResourceWithActiveArchived
  
  def time_entries(options = {})
    Mite::TimeEntry.find(:all, :params => options.update(:customer_id => id))
  end

  def projects(options = {})
    Mite::Project.find(:all, :params => options.update(:customer_id => id))
  end
end