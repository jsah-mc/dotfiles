import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
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
    property int workspaceCount: 10
    property string timeText: "00:00"

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
            console.log("quickshell bar palette parse failed: " + error)
        }
    }

    function updateTime() {
        timeText = Qt.formatTime(new Date(), "hh:mm")
    }

    function recomputeWorkspaceCount() {
        let maxId = 5
        const focused = Hyprland.focusedWorkspace
        if (focused && focused.id > maxId) {
            maxId = focused.id
        }

        const values = Hyprland.workspaces && Hyprland.workspaces.values
            ? Hyprland.workspaces.values
            : []
        for (let i = 0; i < values.length; i++) {
            const workspace = values[i]
            if (workspace && workspace.id > maxId) {
                maxId = workspace.id
            }
        }

        workspaceCount = maxId
    }

    function isWorkspaceOccupied(id) {
        const values = Hyprland.workspaces && Hyprland.workspaces.values
            ? Hyprland.workspaces.values
            : []
        for (let i = 0; i < values.length; i++) {
            const workspace = values[i]
            if (workspace && workspace.id === id) {
                return true
            }
        }
        return false
    }

    function switchWorkspace(id) {
        Hyprland.dispatch("workspace " + id)
    }

    function toggleLauncher() {
        launcherToggle.command = ["bash", "-lc", "$HOME/.config/quickshell/launcher-toggle.sh"]
        launcherToggle.startDetached()
    }

    FileView {
        id: paletteFile
        path: "palette.json"
        watchChanges: true
        onLoaded: root.applyPalette(text)
        onTextChanged: root.applyPalette(text)
    }

    Process {
        id: launcherToggle
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.updateTime()
    }

    Connections {
        target: Hyprland

        function onFocusedWorkspaceChanged() {
            root.recomputeWorkspaceCount()
        }

        function onRawEvent() {
            root.recomputeWorkspaceCount()
        }
    }

    Connections {
        target: Hyprland.workspaces

        function onValuesChanged() {
            root.recomputeWorkspaceCount()
        }
    }

    Component.onCompleted: {
        Hyprland.refreshWorkspaces()
        root.recomputeWorkspaceCount()
        root.updateTime()
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            color: "transparent"
            implicitHeight: 54
            anchors {
                top: true
                left: true
                right: true
            }

            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 8
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                radius: 999
                color: root.palette.bg
                border.color: root.palette.border
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    anchors.topMargin: 6
                    anchors.bottomMargin: 6
                    spacing: 10

                    Rectangle {
                        Layout.alignment: Qt.AlignVCenter
                        implicitHeight: 30
                        implicitWidth: launcherButton.implicitWidth + workspaceRow.implicitWidth + 18
                        radius: 999
                        color: root.palette.surface
                        border.color: root.palette.border
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 6
                            anchors.rightMargin: 10
                            spacing: 8

                            Rectangle {
                                id: launcherButton
                                implicitWidth: 26
                                implicitHeight: 20
                                radius: 999
                                color: launcherMouse.containsMouse ? root.palette.accent : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: ""
                                    font.pixelSize: 13
                                    color: launcherMouse.containsMouse ? root.palette.accentText : root.palette.text
                                }

                                MouseArea {
                                    id: launcherMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.toggleLauncher()
                                }
                            }

                            RowLayout {
                                id: workspaceRow
                                spacing: 8

                                Repeater {
                                    model: root.workspaceCount

                                    delegate: Rectangle {
                                        required property int index
                                        property int workspaceId: index + 1
                                        property bool focused: Hyprland.focusedWorkspace
                                            && Hyprland.focusedWorkspace.id === workspaceId
                                        property bool occupied: root.isWorkspaceOccupied(workspaceId)

                                        width: focused ? 28 : 10
                                        height: 10
                                        radius: 999
                                        color: focused ? root.palette.accent : root.palette.text
                                        opacity: focused || occupied ? 1.0 : 0.35

                                        Behavior on width {
                                            NumberAnimation { duration: 140; easing.type: Easing.InOutQuad }
                                        }

                                        Behavior on opacity {
                                            NumberAnimation { duration: 120; easing.type: Easing.InOutQuad }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: root.switchWorkspace(workspaceId)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignVCenter
                        implicitHeight: 30
                        implicitWidth: 78
                        radius: 999
                        color: root.palette.surface
                        border.color: root.palette.border
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: root.timeText
                            color: root.palette.text
                            font.pixelSize: 13
                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}
