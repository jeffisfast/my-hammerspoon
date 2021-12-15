require "idle_watch"

---- Automatically reload the config ----
pw1 = hs.pathwatcher.new(hs.configdir, function(paths)
    for _, path in ipairs(paths) do
      if path:sub(-4) == ".lua" then
        hs.reload()
        break
      end
    end
  end):start()
  hs.notify.show("Hammerspoon",  "", "config loaded", "")

  