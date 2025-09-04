import QtQuick
import Quickshell.Io
import Quickshell

Scope {
    id: root
    required property string text
    property var entry: null

    onTextChanged: {
        if (text.trim() != "") {
            process.running = true;
        }
    }

    Process {
        id: process
        running: false
        command: ["qalc", root.text]
        stdinEnabled: false
        stdout: StdioCollector {
            onStreamFinished: {
                for (const line of this.text.split("\n")) {
                    if (line.startsWith("warning:") || line.startsWith("error:") || line.trim() == "") {
                        continue;
                    }

                    console.log(line);

                    root.entry = {
                        name: line,
                        genericName: "",
                        icon: ""
                    };
                    return;
                }
                root.entry = null;
            }
        }
    }
}
