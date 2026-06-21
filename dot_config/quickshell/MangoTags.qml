import Quickshell
import Quickshell.Io 
import QtQuick

Item {
    id: root 
    property string output: ""
    property int tagCount: 9
    property var tagList: defaultTagList()

    function handleLine(line) {
        if (!line) return
        var parsed

        try { parsed = JSON.parse(line) }
        catch (e) { return }

        if (!parsed.tags) return

        var next = tagList.slice()
        for (var i = 0; i < parsed.tags.length; i++) {
            var t = parsed.tags[i]
            var idx = t.index
            if (idx < 1 || idx > tagCount) continue
            next[idx - 1] = {
                num: idx,
                isActive: !!t.is_active,
                isUrgent: !!t.is_urgent,
                clients: t.client_count || 0,
            }
        }
        tagList = next
    }

    function defaultTagList() {
        var list = []
        for (var i = 1; i <= tagCount; i++) {
            list.push({ num: i, state: 0, clients: 0, focused: 0 })
        }
        return list
    }

    property int activeTag: {
        for (var i = 0; i < tagList.length; i++) {
            if (tagList[i].isActive) return tagList[i].num
        }
    }

    function switchTag(num) {
        switchProc.tagArg = String(num)
        switchProc.running = false 
        switchProc.running = true
    }

    Process {
        id: switchProc
        property string tagArg: "1"
        command: ["mmsg", "dispatch", "view," + tagArg + ",0"]
    }

    Process {
        id: watcher
        command: ["mmsg", "watch", "tags", root.output]
        running: true
        stdout: SplitParser { onRead: line => root.handleLine(line) }
    }

    Timer  {
        id: restartTimer
        interval: 1000
        repeat: false
        onTriggered: watcher.running = false
    }
}