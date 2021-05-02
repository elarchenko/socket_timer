local gpio = require('gpio')
local tmr = require('tmr')
local timer = tmr.create()
tmr.register(timer, 15000, tmr.ALARM_AUTO, function() process() end)
local pin = 1
local wrapper = {}
local tm

gpio.mode(pin, gpio.OPENDRAIN)
gpio.write(pin, gpio.HIGH)

function sntp_sync_time()
  sntp.sync(nil, function(sec, usec, server, info) rtctime.set(sec + 18000) end, sntp_sync_time, 1)
end

function process()
  print("Processing")
  tm = rtctime.epoch2cal(rtctime.get())
  print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
end

function relay(s)
  if (s == 1) then
    gpio.write(pin, gpio.LOW)
  else
    gpio.write(pin, gpio.HIGH)
  end
end  

function switchOn()
  print("Turning on")
  relay(1)
end

function switchOff()
  print("Turning off")
  relay(0)
end

function init()
  print("Time syncing...")
  sntp_sync_time()
  tmr.start(timer)
  
  cron.schedule("0 8 * * 1,2,3,4,5", switchOn)
  cron.schedule("0 10 * * 1,2,3,4,5", switchOff)
  cron.schedule("0 13 * * 1,2,3,4,5", switchOn)
  cron.schedule("0 15 * * 1,2,3,4,5", switchOff)
  cron.schedule("0 19 * * 1,2,3,4,5", switchOn)
  cron.schedule("0 21 * * 1,2,3,4,5", switchOff)
  cron.schedule("0 12 * * 0,6", switchOn)
  cron.schedule("0 14 * * 0,6", switchOff)
end

wrapper.init = init

return wrapper