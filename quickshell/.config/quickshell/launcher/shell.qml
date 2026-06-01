import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    id: root

    property var palette: ({
        bg: "#11131c",
        surface: "#181825",
        text: "#cdd6f4",
        muted: "#6c7086",
        accent: "#89b4fa",
        accentText: "#1e1e2e",
        border: "#313244",
    })
    property var apps: []
    property int currentIndex: -1
    property int launcherWidth: 760
    property int launcherHeight: 600
    property int launcherTop: 58
    property int launcherLeft: 22

    function applyPalette(raw) {
        try {
            if (!raw || raw.trim().length === 0) {
                return
            }

            const parsed = JSON.parse(raw)
            palette = {
                bg: parsed.bg || palette.bg,
                surface: parsed.surface || parsed.bg || palette.surface,
                text: parsed.text || palette.text,
                muted: parsed.muted || palette.muted,
                accent: parsed.accent || palette.accent,
                accentText: parsed.accentText || parsed.text || palette.accentText,
                border: parsed.border || parsed.muted || palette.border,
            }
        } catch (error) {
            console.log("quickshell launcher palette parse failed: " + error)
        }
    }

    function loadApps(raw) {
        const next = []
        const lines = raw ? raw.trim().split("\n") : []

        for (let i = 0; i < lines.length; i++) {
            const parts = lines[i].split("\t")
            if (parts.length < 2) {
                continue
            }

            next.push({
                desktopId: parts[0],
                name: parts[1],
            })
        }

        apps = next
        applyFilter()
    }

    function applyFilter() {
        const needle = searchField.text.trim().toLowerCase()
        filteredApps.clear()

        for (let i = 0; i < apps.length; i++) {
            const app = apps[i]
            const matches = needle.length === 0
                || app.name.toLowerCase().indexOf(needle) !== -1
                || app.desktopId.toLowerCase().indexOf(needle) !== -1

            if (matches) {
                filteredApps.append(app)
            }
        }

        currentIndex = filteredApps.count > 0 ? 0 : -1
        appGrid.currentIndex = currentIndex
    }

    function launchSelected() {
        if (appGrid.currentIndex < 0 || appGrid.currentIndex >= filteredApps.count) {
            return
        }

        launchApp(filteredApps.get(appGrid.currentIndex).desktopId)
    }

    function launchApp(desktopId) {
        launcherExec.command = ["gtk-launch", desktopId]
        launcherExec.startDetached()
        launcher.visible = false
    }

    function resetAndFocus() {
        searchField.text = ""
        applyFilter()
        searchField.forceActiveFocus()
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            launcher.visible = !launcher.visible
            if (launcher.visible) {
                root.resetAndFocus()
            }
        }

        function show(): void {
            launcher.visible = true
            root.resetAndFocus()
        }

        function hide(): void {
            launcher.visible = false
        }
    }

    FileView {
        id: paletteFile
        path: "palette.json"
        watchChanges: true
        onLoaded: root.applyPalette(text)
        onTextChanged: root.applyPalette(text)
    }

    Process {
        id: appScanner
        stdout: StdioCollector {
            id: appOutput
            waitForEnd: true
            onStreamFinished: root.loadApps(text)
        }
    }

    Process {
        id: launcherExec
    }

    PanelWindow {
        id: launcher
        visible: true
        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.45)
            visible: launcher.visible
        }

        MouseArea {
            anchors.fill: parent
            onClicked: launcher.visible = false
        }

        Rectangle {
            id: attachment
            x: root.launcherLeft
            y: 12
            width: 220
            height: 34
            radius: 999
            color: root.palette.surface
            border.color: root.palette.border
            border.width: 1
        }

        Rectangle {
            id: panel
            x: root.launcherLeft
            y: root.launcherTop
            width: root.launcherWidth
            height: root.launcherHeight
            radius: 16
            color: root.palette.surface
            border.color: root.palette.border
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "Search entries... or use > for commands"
                    color: root.palette.text
                    selectionColor: root.palette.accent
                    selectedTextColor: root.palette.accentText
                    background: Rectangle {
                        radius: 999
                        color: root.palette.bg
                        border.color: root.palette.border
                        border.width: 1
                    }
                    onTextChanged: root.applyFilter()
                    Keys.onReturnPressed: root.launchSelected()
                    Keys.onEscapePressed: launcher.visible = false
                }

                ListModel {
                    id: filteredApps
                }

                GridView {
                    id: appGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    cellWidth: 108
                    cellHeight: 108
                    model: filteredApps
                    currentIndex: root.currentIndex
                    keyNavigationWraps: true

                    delegate: Rectangle {
                        required property string desktopId
                        required property string name
                        required property int index

                        width: 96
                        height: 96
                        radius: 12
                        color: GridView.isCurrentItem ? Qt.rgba(1, 1, 1, 0.12) : "transparent"
                        border.color: GridView.isCurrentItem ? root.palette.accent : "transparent"
                        border.width: 1

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 18
                            text: name.length > 0 ? name.slice(0, 1).toUpperCase() : "?"
                            font.pixelSize: 20
                            color: root.palette.text
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                            width: parent.width - 10
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                            text: name
                            color: root.palette.text
                            font.pixelSize: 11
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: appGrid.currentIndex = index
                            onClicked: root.launchApp(desktopId)
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: root.palette.border
                }

                Text {
                    Layout.fillWidth: true
                    text: `${filteredApps.count} results`
                    color: root.palette.muted
                    font.pixelSize: 11
                }
            }
        }

        Keys.onEscapePressed: launcher.visible = false
        Keys.onReturnPressed: root.launchSelected()
    }

    Component.onCompleted: {
        root.resetAndFocus()
        appScanner.exec(["bash", "-lc", "set -euo pipefail; for dir in \"$HOME/.local/share/applications\" /usr/share/applications /var/lib/flatpak/exports/share/applications; do [ -d \"$dir\" ] || continue; find \"$dir\" -maxdepth 1 -type f -name '*.desktop' -print; done | sort -u | while IFS= read -r file; do [ -r \"$file\" ] || continue; if grep -qE '^(NoDisplay|Hidden)=true$' \"$file\"; then continue; fi; id=${file##*/}; name=$(awk -F= '/^Name=/{print substr($0, 6); exit}' \"$file\"); [ -n \"$name\" ] || continue; printf '%s\\t%s\\n' \"$id\" \"$name\"; done"])
    }
}
