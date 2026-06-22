import Quickshell
import QtQuick
import QtQuick.Layouts

import "config.js" as Config
import "components/bar"
import "components/backend"

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
            exclusiveZone: 35 
            color: "transparent"
            
            RowLayout {
                id: leftZone
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 4
                anchors.leftMargin: 4
                spacing: 4

                Tags {}
                FocusedInfo {}
            }

            Item {
                id: centerZone
                anchors.centerIn: parent
                width: innerCenterRow.width
                height: innerCenterRow.height

                RowLayout {
                    id: centerLeft
                    anchors.right: clockItem.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 4
                    layoutDirection: Qt.RightToLeft
                    spacing: 4

                    Network {}
                }

                Clock { id: clockItem; anchors.centerIn: parent }

                RowLayout {
                    id: centerRight
                    anchors.left: clockItem.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 4
                    layoutDirection: Qt.RightToLeft
                    spacing: 4

                    Bluetooth {}
                }
            }

            RowLayout {
                id: rightZone
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 4
                spacing: 4
                layoutDirection: Qt.RightToLeft

                ScreenshotBtn {}
            }
        }
    }
}
