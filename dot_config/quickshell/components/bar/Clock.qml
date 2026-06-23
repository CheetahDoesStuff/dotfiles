import Quickshell
import QtQuick
import "../../config.js" as Config

Item {
    implicitWidth: clockRect.implicitWidth
    implicitHeight: clockRect.implicitHeight
    property bool expanded: mouseArea.containsMouse

    Rectangle {
        id: clockRect
        color: Config.colors.bg0
        radius: 12
        clip: true
        implicitWidth: (expanded ? innerTextExpanded.implicitWidth : innerText.implicitWidth) + 24
        implicitHeight: innerText.implicitHeight + 8

        border.width: 2
        border.color: mouseArea.containsMouse ? Config.colors.fg0 : Config.colors.bg0

        Behavior on border.color {
            ColorAnimation {
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on implicitWidth {
            NumberAnimation {
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
            text: Qt.formatDateTime(clock.date, "hh:mm")
            color: Config.colors.fg0
            font { family: "SF Mono"; letterSpacing: -1; pixelSize: 14; weight: 700 }

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
            text: Qt.formatDateTime(clock.date, "hh:mm:ss // yyyy MMM dd")
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

    SystemClock {
        id: clock
        precision: !mouseArea.containsMouse ? SystemClock.Minutes : SystemClock.Seconds
    }
}