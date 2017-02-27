import System.Taffybar
import System.Taffybar.Battery
import System.Taffybar.SimpleClock
import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.Text.CPUMonitor
import System.Taffybar.Text.MemoryMonitor

main = do
  let clock = textClockNew Nothing "<span fgcolor='white'>%_d %b %H:%M</span>" 1
      pager = taffyPagerNew defaultPagerConfig
      bat = batteryBarNew defaultBatteryConfig 1
      mem = textMemoryMonitorNew "mem: $usedPct$%" 1
      cpu = textCpuMonitorNew "cpu: $total$%" 1
      tray = systrayNew
  defaultTaffybar defaultTaffybarConfig
      { startWidgets = [ pager ]
      , endWidgets = [ tray, clock, mem, cpu, bat ]
      }
