every 1.day, at: '00:00 am' do
  rake 'robot:cleaner'
end

every 1.minute do
  rake 'robot:builder'
end

every 30.minutes do
  rake 'robot:guard'
end

every 1.minute do
  rake 'robot:guard'
end
