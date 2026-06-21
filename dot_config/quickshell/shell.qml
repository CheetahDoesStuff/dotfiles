import Quickshell
import QtQuick
import QtQuick.Layouts

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 35
            color: "transparent"

            MangoTags {
                id: tags
                output: bar.screen.name
            }
            
            RowLayout {
                id: leftZone
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 4
                spacing: 4

                Rectangle {
                    color: "#04040d"
                    radius: 12
                    implicitWidth: innerRow.implicitWidth + 24
                    implicitHeight: innerRow.implicitHeight + 8

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
                                        ? "#a5e2c5"
                                        : isOccupied
                                            ? "#7d8aa3"
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
                }
            }
            Rectangle {
                anchors.centerIn: parent
                color: "#04040d"
                radius: 12
                implicitWidth: innerText.implicitWidth + 24
                implicitHeight: innerText.implicitHeight + 8

                Text {
                    id: innerText
                    anchors.centerIn: parent
                    text: Qt.formatDateTime(clock.date, "hh:mm")
                    color: "#a5e2c5"
                    font {
                        family: "SF Mono"
                        letterSpacing: -1
                        pixelSize: 15
                        weight: 700
                    }
                }
            }

            RowLayout {
                id: rightZone
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 4
                spacing: 4
                layoutDirection: Qt.RightToLeft
            }

            SystemClock {
                id: clock
                precision: SystemClock.Minutes
            }
        }
    }
}
