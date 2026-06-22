import Quickshell
import QtQuick
import "../../config.js" as Config
import "../backend"

Item {
    Mango {
        id: tags
        output: bar.screen.name
    }

    implicitWidth: focusedRect.implicitWidth
    implicitHeight: focusedRect.implicitHeight

    Rectangle {
        id: focusedRect
        color: Config.colors.bg0
        radius: 12
        clip: true
        implicitWidth: innerText.implicitWidth + 24
        implicitHeight: innerText.implicitHeight + 8

        Text {
            id: innerText
            anchors.centerIn: parent
            text: tags.focusedAppId
            color: Config.colors.fg0
            font { family: "SF Mono"; letterSpacing: -1; pixelSize: 14; weight: 600 }
        }
    }
}