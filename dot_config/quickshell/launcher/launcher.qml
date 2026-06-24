import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.LocalStorage
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

// import "../config.js" as Config

Window {
  id: launcher
  title: "Nightfall Application Launcher"
  visible: true

  flags: Qt.WindowStaysOnTopHint
  color: Qt.rgba(0, 0, 0, 0.8)

  width: 560
  height: 360

  property string query: ""

  function launchSelected() {
    if (list.currentItem && list.currentItem.modelData) {
      list.currentItem.modelData.execute()
      Qt.quit()
    }
  }

  ColumnLayout {
    anchors.fill: parent
    spacing: 8

    RowLayout {
      TextField {
        id: input
        Layout.fillWidth: true
        placeholderText: ""
        font.pixelSize: 18
        color: "#ffffff"
        focus: true
        padding: 15

        background: Rectangle {
          border.width: 0
          color: "transparent"
        }

        onTextChanged: {
          launcher.query = text
          list.currentIndex = filtered.values.length > 0 ? 0 : -1
        }

        Keys.onEscapePressed: Qt.quit()
        Keys.onPressed: event => {
          const ctrl = event.modifiers & Qt.ControlModifier
          if (event.key == Qt.Key_Up) {
            event.accepted = true
            if (list.currentIndex > 0) list.currentIndex--
          } else if (event.key == Qt.Key_Down) {
            event.accepted = true 
            if (list.currentIndex < list.count - 1) list.currentIndex++
          } else if (event.key == Qt.Key_Return || event.Key == Qt.Key_Enter) {
            event.accepted = true
            launcher.launchSelected()
          }
        }
      }

      ScriptModel {
        id: filtered
        values: {
          const allEntries = [...DesktopEntries.applications.values]
          const q = launcher.query.trim()
          if (q == "") { return allEntries }

          return allEntries.filter(d => {
            d.name && d.name.toLowerCase().includes(q)
          })
        }
      }

    ListView {
      id: list
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      model: filtered.values
      currentIndex: filtered.values.length > 0 ? 0 : -1
      keyNavigationWraps: true
      preferredHighlightBegin: 0
      preferredHighlightEnd: height
      highlightRangeMode: Listview.ApplyRange
      highlightMoveDuration: 80
      highlight: Rectangle {
        radius: 4
        opacity: 0.45
        color: input.palette.highlight
      }

      delegate: Item {
        id: entry 
        required property var modelData
        required property int index
        width: ListView.view.width 
        height: 36

        MouseArea {
          anchors.fill: parent
          onClicked: list.currentIndex = entry.index
          onDoubleClicked: launcher.launchSelected()
        }

        Row {
          anchors.fill: parent
          anchors.margins: 0
          spacing: 10

          Text {
            id: label 
            color: "white"
            text: modelData.name
            font.pointSize: 13
            elide: Text.ElideRight
            verticalAlignment: Text.alignVCenter
          }
        }
      }

      Keys.onReturnPressed: launcher.launchSelected()
      }
    }
  }
}
