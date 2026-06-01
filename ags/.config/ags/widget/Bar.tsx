import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"
import { LauncherButton } from "./Launcher"
import { Workspaces } from "./Bar/Workspaces"
export default function Bar(gdkmonitor: Gdk.Monitor) {
  const time = createPoll("", 1000, "date '+%H:%M'")
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox class="BarShell" hexpand halign={Gtk.Align.FILL}>
        <box $type="start" class="BarGroup BarGroupStart" spacing={4}>
          <LauncherButton />
        </box>
        <box $type="center" class="BarGroup BarGroupCenter" spacing={0}>
          <Workspaces />
        </box>
        <menubutton $type="end" class="BarGroup BarGroupEnd BarClock">
          <label class="BarClockLabel" label={time} />
          <popover>
            <Gtk.Calendar />
          </popover>
        </menubutton>
      </centerbox>
    </window>
  )
}
