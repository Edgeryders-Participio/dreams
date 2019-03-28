#!/usr/bin/env ruby
# Dreamy ~ the dumb dreams loomio bot
# imported and used from within the initializer: config/initializers/loomio_bot.rb

# TODO
# Don't busy loop
require ::File.expand_path('../../../config/environment', __FILE__)
require_relative 'processors'
require_relative 'loomio_handler'

@processors_hash = {
  'camp_created': Processors.method(:camp_created),
  'other_entry_type': Processors.method(:other_entry_type)
}.stringify_keys
@predefined_entry_types = @processors_hash.keys

# run through all log_entry_types and run their processors
def process(log_entry, loomio)
  puts("Processing %s" % log_entry.description)

  @predefined_entry_types.each do |predefined_entry_type|
    if log_entry.entry_type == predefined_entry_type
      @processors_hash[predefined_entry_type].(log_entry, loomio)
      return
    end

  puts("Event I don't care about: %s" % log_entry.entry_type)
  log_entry.loomio_consumed = true
  log_entry.save!

  puts("Done processing %s" % log_entry.description)
  end
end

# used from within the initializer: config/initializers/loomio_bot.rb
def run_bot
  return if !ENV['LOOMIO_USER']

  # initialize the handler here so that the authentication doesn't have to be repeated
  loomio = LoomioHandler.new()

  # start a new thread and run an infinite loop inside it
  #Thread.new do
    loop do
      LogEntry
        .where(loomio_consumed: [false, nil]) # extract all log_entries that haven't been processed yet
        .each { |log_entry|
          process(log_entry, loomio)
        }
      sleep 5 # check for new events every 5 seconds
    end
  #end
end

run_bot
