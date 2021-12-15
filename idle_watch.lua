print('Loaded Stream Deck Sleep Watch....')

-- Set Defaults
local notifications = false
local debug = true
local idle_time = 600
local idle_interval = 180
local currentDeck = nil


function idleWatch()
    if (hs.host.idleTime() > idle_time) then
      if notifications then
        hs.notify.show("System Inactive", "", "")
      end
      streamdeck_sleep()
    else
      streamdeck_wake() 
    end

    if debug then
      print('watch idle_interval: ' .. idle_interval .. ' idle_time: ' .. idle_time ..  ' idle: ' .. hs.host.idleTime())
    end
end

function sleepWatch(eventType)
      if (eventType == hs.caffeinate.watcher.systemDidWake) then
        if notifications then
            hs.notify.show("System Wake!", "", "")
        end
        streamdeck_wake()
      elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
        if notifications then
            hs.notify.show("System Sleep", "", "")
        end
        streamdeck_sleep()
      elseif (eventType == hs.caffeinate.watcher.screensDidSleep) then
        if notifications then
            hs.notify.show("Screens Sleep", "", "")
        end
        streamdeck_sleep()
      elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
        if notifications then
            hs.notify.show("Screens Wake", "", "")
        end
        streamdeck_wake()
      end
end

function streamdeck_sleep()
    if currentDeck == nil then 
      if debug then
        print('Not sleeping because not connected')
      end
      return
    end
    currentDeck:setBrightness(0)
    if notifications then
      hs.notify.show("Brightness Off", "", "")
    end
    if debug then
      print('Streamdeck sleep')
    end
end

function streamdeck_wake()
    if currentDeck == nil then 
      if debug then
        print('Not waking because not connected')
      end
      return 
    end
    currentDeck:setBrightness(75)
    if notifications then
      hs.notify.show("Brightness High", "", "")
    end
    if debug then
      print('Streamdeck wake')
    end
end

function my_streamdeck_discovery(connected, deck)
    if connected then
        currentDeck = deck
        if notifications then
          hs.notify.show("Stream Deck detected", "", "")
        end
        if debug then
          print('Steam Deck detected')
        end
    else
        if debug then
          print('No Stream Deck detected')
        end
        currentDeck = nil
        if notifications then
          hs.notify.show("No Stream Deck detected", "", "")
        end
    end
end


hs.streamdeck.init(my_streamdeck_discovery)
myWatcher = hs.caffeinate.watcher.new(function(eventType) sleepWatch(eventType) end)
myTimer = hs.timer.new(idle_interval,function () idleWatch() end, true)
myWatcher:start()
myTimer:start()
print('Started StreamDeckSleepWatch')

