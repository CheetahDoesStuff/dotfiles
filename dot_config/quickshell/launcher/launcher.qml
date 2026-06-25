import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.LocalStorage
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import QtQuick.LocalStorage

ShellRoot {
  IpcHandler {
    target: "launcher"

    function toggle(): void {
      if (launcher.visible) {
        launcher.visible = false
      } else {
        input.text = ""
        launcher.query = ""
        launcher.visible = true
        input.forceActiveFocus()
      }
    }
  }

  FloatingWindow {
    id: launcher
    title: "Nightfall Application Launcher"
    visible: false
    Component.onCompleted: initDb()
    
    color: "#04040d"
    width: 560
    height: 360

    property string query: ""

    function getDb() { return LocalStorage.openDatabaseSync("nightfall-launcher", "1.0", "Launcher History", 1000000) }
    function initDb() {
      const db = getDb()
      db.transaction(tx => { tx.executeSql("CREATE TABLE IF NOT EXISTS app_usage ( id TEXT PRIMARY KEY, last_used INTEGER )") })
    }
    function recordLaunch(id) {
      const db = getDb()
      db.transaction(tx => { tx.executeSql(`
        INSERT OR REPLACE INTO app_usage
        (id, last_used)
        VALUES (?, ?)
      `, [id, Date.now()]) })
    }
    function getLastUsed(id) {
      const db = getDb()
      let result = 0
      db.readTransaction(tx => {
        const rs = tx.executeSql("SELECT last_used FROM app_usage WHERE id = ?", [id])
        if (rs.rows.length > 0) result = rs.rows.item(0).last_used
      })
      console.log("App " + id + " returned lastUsed " + result)
      return result
    }
    function launchSelected() {
      if (list.currentItem && list.currentItem.modelData) {
        const app = list.currentItem.modelData
        recordLaunch(app.id)
        app.execute()
        launcher.visible = false
      }
    }

    ColumnLayout {
      anchors.fill: parent
      spacing: 0

      RowLayout {
        TextField {
          id: input
          Layout.fillWidth: true
          placeholderText: ""
          font.pixelSize: 18
          color: "#a5e2c5"
          focus: true
          padding: 10

          background: Rectangle {
            border.width: 0
            color: "transparent"
          }

          onTextChanged: {
            launcher.query = text
            list.currentIndex = filtered.values.length > 0 ? 0 : -1
          }

          Keys.onEscapePressed: launcher.visible = false
          
          Keys.onPressed: event => {
            const ctrl = event.modifiers & Qt.ControlModifier
            if (event.key == Qt.Key_Up) {
              event.accepted = true
              if (list.currentIndex > 0) list.currentIndex--
            } else if (event.key == Qt.Key_Down) {
              event.accepted = true 
              if (list.currentIndex < list.count - 1) list.currentIndex++
            } else if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
              event.accepted = true
              launcher.launchSelected()
            }
          }
        }

        ScriptModel {
          id: filtered
          values: {
            const allEntries = [...DesktopEntries.applications.values]
            const q = launcher.query.trim().toLowerCase()
            let result = q === ""
              ? allEntries
              : allEntries.filter(d =>
                d.name &&
                (d.name.toLowerCase().includes(q) || d.genericName.toLowerCase().includes(q))
              )

            return result.sort((a, b) =>
              launcher.getLastUsed(b.id) -
              launcher.getLastUsed(a.id)
            )
          }
        }
      }

      Rectangle {
        height: 2
        Layout.fillWidth: true
        color: "#a5e2c5"
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
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 0
        highlight: Rectangle {
          radius: 0
          opacity: 1
          color: "#a5e2c5"
        }

        delegate: Item {
          id: entry 
          required property var modelData
          required property int index
          width: ListView.view.width 
          height: 24

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
              color: list.currentIndex === index ? "#04040d" : "white"
              text: modelData.name
              font.pointSize: 13
              elide: Text.ElideRight
              verticalAlignment: Text.AlignVCenter
            }

            Text {
              id: genericNameLabel
              color: list.currentIndex === index ? "#2f2f2d" : "#6f6f6d"
              text: "(" + modelData.genericName + ")"
              font.pointSize: 11
              font.italic: true
              elide: Text.ElideRight
              verticalAlignment: Text.AlignVCenter

              visible: modelData.genericName && modelData.genericName !== ""
            }
          }
        }

        Keys.onReturnPressed: launcher.launchSelected()
      }
    }
  }
}

