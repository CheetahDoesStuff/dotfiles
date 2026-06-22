import Quickshell
import Quickshell.Io
import QtQuick
import "../../config.js" as Config

Item {
    implicitWidth: netRect.implicitWidth
    implicitHeight: netRect.implicitHeight

    property int connectedCount: 0
    property bool btEnabled: false

    property string icon: {
        if (!btEnabled) return String.fromCodePoint(0xF00B2)
        if (connectedCount > 0) return String.fromCodePoint(0xF00B1)
        return String.fromCodePoint(0xF00AF)
    }

    Process {
        id: btProcess
        command: ["sh", "-c", "bluetoothctl show && bluetoothctl info"]
        running: true

        property int count: 0

        onExited: (code, status) => { connectedCount = btProcess.count }

        stdout: SplitParser {
            onRead: data => {
                if (data.includes("Connected: yes")) btProcess.count++
                if (data.includes("Powered: yes")) btEnabled = true
                if (data.includes("Powered: no")) btEnabled = false
                connectedCount = btProcess.count
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: btProcess.running = true
    }

    Rectangle {
        id: netRect
        color: Config.colors.bg0
        radius: 12
        clip: true
        implicitWidth: innerText.implicitWidth + 24
        implicitHeight: innerText.implicitHeight + 8

        Text {
            id: innerText
            anchors.centerIn: parent
            text: icon
            color: Config.colors.fg0
            font { family: "JetbrainsMono Nerd Font"; letterSpacing: -1; pixelSize: 14; weight: 700 }
        }
    }
}