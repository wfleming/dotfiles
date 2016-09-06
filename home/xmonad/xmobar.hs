Config {
  -- appearance
  font = "xft:Mononoki:size=12"
  , position = TopW L 95

  -- layout
  , sepChar = "%"
  , alignSep = "}{"
--  , template = "%StdinReader% }{ %battery% | %cpu% | %memory% | %Volume% | %date% "
  , template = "%StdinReader% }{ %battery% | %cpu% | %memory% | %date% | "

  -- behavior
  , allDesktops = True
  , hideOnStart = False
  , pickBroadest = False -- multi monitor
  , iconRoot = "/home/will/.xmonad/icons"

  , commands = [
    -- cpu activity monitor
    Run Cpu              [ "--template" , "<icon=cpu.xbm/> <total>%"
                         , "--Low"      , "50"         -- units: %
                         , "--High"     , "85"         -- units: %
                         , "--low"      , "darkgreen"
                         , "--normal"   , "darkorange"
                         , "--high"     , "darkred"
                         ] 10

    -- memory usage monitor
    , Run Memory         [ "--template" ,"<icon=mem.xbm/> <usedratio>%"
                         , "--Low"      , "20"        -- units: %
                         , "--High"     , "90"        -- units: %
                         , "--low"      , "darkgreen"
                         , "--normal"   , "darkorange"
                         , "--high"     , "darkred"
                         ] 10

    -- battery monitor
    , Run BatteryP       ["AC", "BAT0", "BAT1"]
                         [ "--template" , "<icon=bat_full_01.xbm/> <left>% (<timeleft>)"
                         , "--Low"      , "10"        -- units: %
                         , "--High"     , "80"        -- units: %
                         , "--low"      , "darkred"
                         , "--normal"   , "darkorange"
                         , "--high"     , "darkgreen"

                         -- These aren't working: <actstatus> is always "N/A" /shrug
                         , "--" -- battery specific options
                                   -- discharging status
                                   , "-o"	, "<left>% (<timeleft>)"
                                   -- AC "on" status
                                   , "-O"	, "<fc=#dAA520>Charging</fc>"
                                   -- charged status
                                   , "-i"	, "<fc=#006000>Charged</fc>"
                         ] 50

    --, Run Volume         "default" "Master" [] 10

    -- time and date indicator
    --   (<date> <month> HH::MM)
    , Run Date           "<fc=#ABABAB>%d %b %R</fc>" "date" 20

    , Run StdinReader
  ]
}
