dofile("wifi.lua")

tmr.alarm(2,1000,1,function()
  if connected==1 then
    tmr.stop(2)
    local exec = require("executor")
    exec.init()
  end
end)

