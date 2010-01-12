class Mite::TimeEntry::Bookmark < Mite::Base
  
  include Mite::ResourceWithoutWriteAccess
  self.prefix = "/time_entries/"
  
  def team?
    user_id.blank?
  end
  
  def params
    hash = CGI.parse(query)
    hash.each do |k, v|
      hash[k] = v[0]
    end
    hash
  end
  
  def follow
    Mite::TimeEntry.all(:params => params)
  end
  
  class << self
    def follow(id)
      get("#{id}/follow")
    rescue ActiveResource::Redirection => err
      query = err.response['Location'].split(/\?/,2)[1] || ""
      new(:query => query).follow
    end
  end
end