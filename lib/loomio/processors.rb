Rails.application.routes.default_url_options = ActionMailer::Base.default_url_options

class Processors
  def self.camp_created(log_entry, loomio) # static method
    url_helper = Class.new{ include Rails.application.routes.url_helpers }.new
    camp = log_entry.object

    response = loomio.new_thread(camp.name,
                                 url_helper.camp_url(camp, host: "tivedstorp-dreams.herokuapp.com", protocol: "https"))

    thread_id = response['discussions'][0]['id']
    thread_key = response['discussions'][0]['key']
    puts(thread_id, thread_key)

    camp.loomio_thread_id = thread_id
    camp.loomio_thread_key = thread_key
    log_entry.loomio_consumed = true

    # make sure to trigger database commit on modified objects
    camp.save
    log_entry.save
  end

  def self.other_entry_type(log_entry, loomio)
  end
end
