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

    property bool expanded: mouseArea.containsMouse

    Rectangle {
        id: focusedRect
        color: Config.colors.bg0
        radius: 12
        clip: true
        implicitWidth: tags.focusedAppId === "" ? 0
                     : (expanded ? innerTextExpanded.implicitWidth : innerText.implicitWidth) + 24
        implicitHeight: innerText.implicitHeight + 8

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }

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
        }

        Text {
            id: innerText
            opacity: expanded ? 0 : 1
            anchors.centerIn: parent
            text: tags.focusedAppId
            color: Config.colors.fg0
            font { family: "SF Mono"; letterSpacing: -1; pixelSize: 14; weight: 600 }

            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Text {
            id: innerTextExpanded
            opacity: expanded ? 1 : 0
            anchors.centerIn: parent
            text: tags.focusedAppId + " // " + tags.focusedTitle
            color: Config.colors.fg0
            font { family: "SF Mono"; letterSpacing: -1; pixelSize: 14; weight: 700 }

            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}