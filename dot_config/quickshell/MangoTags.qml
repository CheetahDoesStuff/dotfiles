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
        var parts = line.trim().split(/\s+/)
        if (parts.length < 3) return

        var type = parts[1]
        if (type !== "tag") return

        var num = parseInt(parts[2])
        var state = parseInt(parts[3])
        var clients = parseInt(parts[4])
        var focused = parseint(parts[5])
        if (isNaN(num) || num < 1 || num > tagCount) return

        var next = tagList.slice()
        netxt[num-1] = {num: num, state: state, clients: clients, focused: focused}
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
        command: root.output.length > 0
            ? ["mmsg", "-w", "-o", root.output, "-t"]
            : ["mmsg", "-w", "-t"]
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