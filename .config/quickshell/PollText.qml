import QtQuick
import Quickshell.Io

Text {
    id: self
    property alias command: proc.command
    property int pollMs: 5000
    color: "#c0caf5"
    font.family: "JetBrainsMono Nerd Font Mono"
    font.pixelSize: 13

    signal changed()

    function refresh() {
        proc.running = true;
    }

    Process {
        id: proc
        stdout: SplitParser {
            onRead: data => {
                const isChange = self.text !== data && self.text !== "";
                self.text = data;
                if (isChange) self.changed();
            }
        }
    }

    Timer {
        interval: self.pollMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }
}
