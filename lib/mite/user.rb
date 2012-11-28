class Mite::User < Mite::Base

  include Mite::ResourceWithoutWriteAccess
  include Mite::ResourceWithActiveArchived

  def time_entries(options = {})
    Mite::TimeEntry.find(:all, :params => options.update(:user_id => id))
  end
end
