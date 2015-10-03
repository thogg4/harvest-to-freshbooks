require 'harvested'
require 'ruby-freshbooks'

def one_day
  60*60*24
end

h = Harvest.client(subdomain: ENV['HARVEST_SUBDOMAIN'], username: ENV['HARVEST_EMAIL'], password: ENV['HARVEST_PASSWORD'])
f = FreshBooks::Client.new("#{ENV['FRESHBOOKS_SUBDOMAIN']}.freshbooks.com", ENV['FRESHBOOKS_TOKEN'])

entries = []

7.times do |i|
  h.time.all(Time.now - (one_day*(i+1))).each do |entry|
    entries.push(entry)
  end
end

entries.each do |e|
  puts e
  f.time_entry.create({
    time_entry: {
      project_id: ENV['FRESHBOOKS_PROJECT_ID'],
      task_id: ENV['FRESHBOOKS_TASK_ID'],
      hours: e.hours,
      date: e.spent_at,
      notes: 'imported from harvest'
    }
  })
end
