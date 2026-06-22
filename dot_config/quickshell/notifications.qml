import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

Scope {
    id: root

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            console.log("got:", n.summary, "---", n.body)
            n.tracked = true
        }
    }

    PanelWindow {
        anchors { top: true; right: true }
        margins { top: 12; right: 12 }
        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications
                delegate: Rectangle {
                    id: card
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: layout.implicitHeight + 20
                    radius: 12
                    color: Config.colors.bg0
                    border.width: 2
                    border.color: modelData.urgency === NotificationUrgency.Critical ? Config.colors.red : Config.colors.fg0

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Timer {
                            running: card.modelData.urgency !== NotificationUrgency.Critical
                            interval: Config.notifications.timeout
                            onTriggered: card.modelData.dismiss()
                        }

                        Image {
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.summary
                                color: card.modelData.urgency === NotificationUrgency.Critical ? Config.colors.red : Config.colors.fg0
                                font.family: "SF Mono"
                                font.pixelSize: 14
                                font.weight: 700
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.modelData.body
                                color: Config.colors.fg1
                                font.family: "SF Mono"
                                font.pixelSize: 12
                                font.weight: 600
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.modelData.dismiss()
                    }
                }
            }
        }
    }
}