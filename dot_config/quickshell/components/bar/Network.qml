import Quickshell
import Quickshell.Networking
import QtQuick
import "../../config.js" as Config

Item {
    implicitWidth: netRect.implicitWidth
    implicitHeight: netRect.implicitHeight

    property var wiredDevice: Networking.devices.values.find(d => d.type === DeviceType.Wired)
    property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
    property bool hasEthernet: wiredDevice ? wiredDevice.connected : false

    property var active: wifiDevice ? wifiDevice.networks.values.find(n => n.connected) : null
    readonly property real signal: active ? active.signalStrength : 0
    readonly property string icon : { 
        if (hasEthernet) return String.fromCodePoint(0xEF44)
        if (!Networking.wifiEnabled) return String.fromCodePoint(0xF05AA) 
        if (!active) return String.fromCodePoint(0xF092D)

        let tier = signal >= 0.75 ? 4
            : signal >= 0.50 ? 3
            : signal >= 0.25 ? 2
            : 1

        return String.fromCodePoint(0xF091F + (tier - 1) * 3)
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