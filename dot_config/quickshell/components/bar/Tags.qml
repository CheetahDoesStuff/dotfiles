import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../config.js" as Config
import "../backend/"

Item {
    Mango {
        id: tags
        output: bar.screen.name
    }

    implicitWidth: innerTagRect.implicitWidth
    implicitHeight: innerTagRect.implicitHeight
    property bool expanded: mouseArea.containsMouse

    Rectangle {
        id: innerTagRect
        color: Config.colors.bg0
        radius: 12
        implicitWidth: innerRow.implicitWidth + 24
        implicitHeight: innerRow.implicitHeight + 8
        
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

        RowLayout {
            id: innerRow
            anchors.centerIn: parent
            spacing: 7

            Repeater {
                model: tags.tagCount

                Text {
                    id: tagLabel

                    property var tag: tags.tagList[index]
                    property bool isActive: tag.isActive
                    property bool isUrgent: tag.isUrgent
                    property bool isOccupied: tag.clients > 0

                    text: tag.num
                    font {
                        family: "SF Mono"
                        pixelSize: 14
                        weight: isActive || isUrgent ? 700 : 500
                    }
                    color: isUrgent
                        ? "#ff6048"
                        : isActive
                            ? Config.colors.fg0
                            : isOccupied
                                ? Config.colors.fg1
                                : Config.colors.bg2

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -4
                        cursorShape: Qt.PointingHandCursor
                        onClicked: tags.switchTag(tagLabel.tag.num)
                    }
                }
            }
        }
    }
}