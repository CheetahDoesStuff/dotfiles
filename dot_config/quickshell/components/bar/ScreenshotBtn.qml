import Quickshell
import Quickshell.Io
import QtQuick
import "../../config.js" as Config

Item {
    implicitWidth: clockRect.implicitWidth
    implicitHeight: clockRect.implicitHeight

    Process {
        id: scriptRunner
        command: ["flameshot", "gui"]
    }

    Rectangle {
        id: clockRect
        color: Config.colors.bg0
        radius: 12
        clip: true
        implicitWidth: innerText.implicitWidth + 24
        implicitHeight: innerText.implicitHeight + 8
        border.width: 2
        border.color: mouseArea.containsMouse ? Config.colors.fg0 : Config.colors.bg0

        Behavior on border.color {
            ColorAnimation {
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: { scriptRunner.running = true }
        }

        Text {
            id: innerText
            anchors.centerIn: parent
            text: ""
            color: Config.colors.fg0
            font { family: "JetbrainsMono Nerd Font"; letterSpacing: -1; pixelSize: 14; weight: 700 }
        }
    }
}