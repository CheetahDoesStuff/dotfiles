import Quickshell
import QtQuick
import QtQuick.Layouts

ShellRoot {
    PanelWindow {
        id: bar
        property var modelData
        screen: modelData
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 30
        color: "#04040d"

        MangoTags {
            id: tags
            output: bar.screen.name
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14

            RowLayout {
                spacing: 7

                Repeater {
                    model: tags.tagCount

                    Text {
                        id: tagLabel
                        property var tag: tags.tagList[index]
                        property bool isActive: tag.state === 1
                        property bool isUrgent: tag.state === 2
                        property bool isOccupied: tag.clients > 0

                        text: tag.num
                        color: isUrgent
                            ? "#ff6048"
                            : isActive
                                ? "#a5e2c5"
                                : "#3a3d4a"
                        
                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -4
                            cursorShape: Qt.PointingHandCursor
                            onClicked: tags.switchTag(tagLabel.tag.num)
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Text {
                text: Qt.formatDateTime(clock.date, "hh:mm")
                color: "#a5e2c5"

                font {
                    family: "SF Mono"
                    letterSpacing: -1
                    pixelSize: 15
                    weight: 700
                }
            }

            SystemClock {
                id: clock
                precision: SystemClock.Minutes
            }
        }
    }
}