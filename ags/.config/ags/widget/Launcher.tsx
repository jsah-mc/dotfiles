import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createComputed, createState, For } from "ags"
import Apps from "gi://AstalApps"
import { execAsync } from "ags/process"

const apps = new Apps.Apps()
apps.showHidden = false
apps.reload()

let launcherWindow: Gtk.Window | null = null

function hideLauncher() {
  launcherWindow?.hide()
}

export function toggleLauncher() {
  if (!launcherWindow) return
  launcherWindow.visible = !launcherWindow.visible
}

function runCommand(command: string) {
  execAsync(["bash", "-lc", command]).catch(console.error)
}

function launchApp(selection: Apps.Application) {
  selection.launch()
  hideLauncher()
}

function launchCommand(query: string) {
  const command = query.trim().replace(/^>\s*/, "")
  if (!command) return
  runCommand(command)
  hideLauncher()
}

export function LauncherButton() {
  return (
    <button
      class="LauncherButton"
      tooltipText="Open launcher"
      onClicked={toggleLauncher}
    >
      <box spacing={8}>
        <label label="" />
        <label class="LauncherButtonLabel" label="Search" />
      </box>
    </button>
  )
}

export function LauncherWindow() {
  const [query, setQuery] = createState("")
  const commandMode = createComputed(() => query().trim().startsWith(">"))
  const results = createComputed(() => {
    const text = query().trim().replace(/^>\s*/, "")
    const list = text ? apps.fuzzy_query(text) : apps.list
    return list.slice(0, 24)
  })

  let entryRef: Gtk.Entry | null = null
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      name="Launcher"
      class="LauncherWindow"
      visible={false}
      layer={Astal.Layer.OVERLAY}
      keymode={Astal.Keymode.ON_DEMAND}
      exclusivity={Astal.Exclusivity.IGNORE}
      anchor={TOP | LEFT | RIGHT}
      $={(self) => {
        launcherWindow = self
        app.add_window(self)
      }}
      onNotifyVisible={({ visible }) => {
        if (!visible) return
        setQuery("")
        if (entryRef) {
          entryRef.set_text("")
          entryRef.grab_focus()
        }
      }}
    >
      <Gtk.EventControllerKey
        onKeyPressed={(_, keyval) => {
          if (keyval === Gdk.KEY_Escape) {
            hideLauncher()
            return true
          }
          return false
        }}
      />

      <box
        class="LauncherDock"
        orientation={Gtk.Orientation.VERTICAL}
        spacing={0}
        halign={Gtk.Align.CENTER}
        valign={Gtk.Align.START}
      >

        <box
          class="LauncherPanel"
          orientation={Gtk.Orientation.VERTICAL}
          spacing={12}
        >
          <entry
            class="LauncherEntry"
            hexpand
            placeholderText="Search entries... or use > for commands"
            text={query}
            $={(self) => {
              entryRef = self
            }}
            onNotifyText={({ text }) => setQuery(text)}
            onActivate={() => {
              if (commandMode()) {
                launchCommand(query())
              } else {
                const topResult = results()[0]
                if (topResult) launchApp(topResult)
              }
            }}
          />

          <scrolledwindow class="LauncherScroll" vexpand hexpand>
            <Gtk.FlowBox
              class="LauncherGrid"
              selectionMode={Gtk.SelectionMode.NONE}
              columnSpacing={12}
              rowSpacing={12}
              minChildrenPerLine={6}
              maxChildrenPerLine={6}
              homogeneous
            >
              <For each={results}>
                {(selection) => (
                  <Gtk.FlowBoxChild>
                    <button class="LauncherCard" onClicked={() => launchApp(selection)}>
                      <box
                        class="LauncherCardInner"
                        orientation={Gtk.Orientation.VERTICAL}
                        spacing={8}
                      >
                        <image
                          iconName={selection.iconName || "application-x-executable-symbolic"}
                          pixelSize={44}
                        />
                        <label
                          class="LauncherCardLabel"
                          maxWidthChars={13}
                          wrap
                          justify={Gtk.Justification.CENTER}
                          label={selection.name || selection.entry}
                        />
                      </box>
                    </button>
                  </Gtk.FlowBoxChild>
                )}
              </For>
            </Gtk.FlowBox>
          </scrolledwindow>

          <box class="LauncherFooter">
            <label
              class="LauncherHint"
              xalign={0}
              hexpand
              label={commandMode() ? "Press Enter to run command" : `${results().length} results`}
            />
          </box>
        </box>
      </box>
    </window>
  )
}
