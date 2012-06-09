every 15.minutes do
  rake "ts:index"
end

every :reboot do
  rake "ts:stop"
  rake "ts:start"
end