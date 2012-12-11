class Mite::Tracker < Mite::Base

  self.collection_name = "tracker"

  def self.current
    tracking_time_entry = (format.decode(connection.get(collection_path, headers).body) || {})["tracking_time_entry"]
    tracking_time_entry ? instantiate_record(tracking_time_entry) : nil
  end

  def self.start(time_entry_or_id)
    id = time_entry_or_id.is_a?(Mite::TimeEntry) ? time_entry_or_id.id : time_entry_or_id
    new({:id => id}, true).start
  end

  def self.stop
    tracker = current
    tracker ? tracker.stop : false
  end

  def start
    response = connection.put(element_path(prefix_options), encode, self.class.headers)
    load(self.class.format.decode(response.body)["tracking_time_entry"])
    response.is_a?(Net::HTTPSuccess) ? self : false
  end

  def stop
    Net::HTTPSuccess === connection.delete(element_path, self.class.headers) && self
  end

  def time_entry
    Mite::TimeEntry.find(id)
  end

end