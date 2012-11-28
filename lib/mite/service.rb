class Mite::Service < Mite::Base

  include Mite::ResourceWithActiveArchived

  def time_entries(options = {})
    Mite::TimeEntry.find(:all, :params => options.update(:service_id => id))
  end

end