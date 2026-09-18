import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Services.Mpris

ShellRoot {

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData
            anchors { left: true; right: true; top: true }
            implicitHeight: 26
            exclusiveZone: 26
            color: "#000000"

        Item {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8

            // ---- left: workspaces ----
            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 3

                    Repeater {
                        model: Hyprland.workspaces.values.filter(ws => ws.monitor && ws.monitor.name === bar.screen.name)

                        delegate: Rectangle {
                            required property var modelData
                            width: label.implicitWidth + 12
                            height: 20
                            color: "transparent"
                            border.width: 0
                            anchors.verticalCenter: parent ? parent.verticalCenter : undefined

                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: label.implicitWidth + 4
                                height: 1
                                color: modelData.active ? "#c0caf5" : "#000000"
                            }

                            Text {
                                id: label
                                anchors.centerIn: parent
                                text: modelData.name
                                color: "#c0caf5"
                                opacity: modelData.active ? 1.0 : 0.6
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 13
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: modelData.activate()
                            }
                        }
                    }
                }
            }

            // ---- center: clock ----
            Text {
                anchors.centerIn: parent
                color: "#c0caf5"
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 13
                property date now: new Date()
                text: Qt.formatDateTime(now, "HH:mm - ddd dd MMM")

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: parent.now = new Date()
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: calendar.toggle()
                }
            }

            // ---- right: stats ----
            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 15

                Row {
                    id: mprisRow
                    visible: Mpris.players.values.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6
                    property var player: Mpris.players.values[0]

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: mprisRow.player ? (mprisRow.player.trackArtist ? mprisRow.player.trackArtist + " - " : "") + (mprisRow.player.trackTitle || "") : ""
                        color: "#c0caf5"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 13
                        elide: Text.ElideRight
                        width: 220
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: mprisRow.player && mprisRow.player.isPlaying ? "󰏤" : "󰐊"
                        color: "#c0caf5"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 13

                        MouseArea {
                            anchors.fill: parent
                            onClicked: mprisRow.player && mprisRow.player.togglePlaying()
                        }
                    }
                }

                Text {
                    id: gitText
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 13
                    property string cls: "clean"
                    color: cls === "dirty" ? "#f7768e"
                         : cls === "changes" ? "#e0af68"
                         : "#c0caf5"

                    Process {
                        id: gitProc
                        command: ["bash", "-lc", "~/.config/waybar/scripts/git-status.sh"]
                        stdout: SplitParser {
                            onRead: data => {
                                try {
                                    const parsed = JSON.parse(data);
                                    gitText.text = parsed.text;
                                    gitText.cls = parsed.class;
                                } catch (e) {}
                            }
                        }
                    }

                    Timer {
                        interval: 10000
                        running: true
                        repeat: true
                        triggeredOnStart: true
                        onTriggered: gitProc.running = true
                    }
                }

                PollText {
                    id: volumeText
                    pollMs: 300
                    command: ["bash", "-lc", "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{ if ($3==\"[MUTED]\") print \"󰝟\"; else printf \"󰕾 %d%%\", $2*100 }'"]
                    onChanged: {
                        const m = volumeText.text.match(/(\d+)/);
                        volumeOsd.icon = volumeText.text.replace(/\s*\d+%$/, "").trim() || "󰕾";
                        volumeOsd.percent = m ? parseInt(m[1]) : 0;
                        volumeOsd.shown = true;
                        volumeOsdTimer.restart();
                    }
                }

                PollText {
                    pollMs: 5000
                    command: ["bash", "-lc", "printf '󰍛 %3d%%' \"$(top -bn2 -d 0.3 | grep 'Cpu(s)' | tail -1 | awk '{print 100-$8}' | cut -d. -f1)\""]
                }

                PollText {
                    pollMs: 5000
                    command: ["bash", "-lc", "printf '󰘚 %d%%' \"$(free | awk '/Mem/{printf \"%.0f\", $3/$2*100}')\""]
                }

                PollText {
                    id: btText
                    pollMs: 10000
                    command: ["bash", "-lc", "bluetoothctl show 2>/dev/null | grep -q 'Powered: yes' && echo 󰂯 || echo 󰂲"]

                    Process {
                        id: btToggleProc
                        command: ["bash", "-lc", "bluetoothctl show 2>/dev/null | grep -q 'Powered: yes' && bluetoothctl power off || bluetoothctl power on"]
                        onExited: btText.refresh()
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: btToggleProc.running = true
                    }
                }

                PollText {
                    id: wifiText
                    pollMs: 5000
                    command: ["bash", "-lc", "nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '$1==\"yes\"{print \"󰤨 \" $2; f=1} END{if(!f) print \"󰖪\"}'"]

                    Process {
                        id: wifiToggleProc
                        command: ["bash", "-lc", "[ \"$(nmcli radio wifi)\" = enabled ] && nmcli radio wifi off || nmcli radio wifi on"]
                        onExited: wifiText.refresh()
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: wifiToggleProc.running = true
                    }
                }

                PollText {
                    pollMs: 5000
                    visible: text !== ""
                    command: ["bash", "-lc", "d=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1); [ -z \"$d\" ] && exit 0; cap=$(cat $d/capacity); st=$(cat $d/status); [ \"$st\" = Charging ] && icon=󰂅 || icon=󰁹; printf '%s%d%%' \"$icon\" \"$cap\""]
                }
            }
        }
    }
    }

    // ---- notifications ----
    NotificationServer {
        id: notifServer
        keepOnReload: false
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true
        onNotification: notification => {
            notification.tracked = true;
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            anchors { top: true; right: true }
            margins { top: 34; right: 8 }
            exclusiveZone: 0
            color: "transparent"
            focusable: false
            implicitWidth: 320
            implicitHeight: notifCol.implicitHeight

            Column {
                id: notifCol
                width: parent.width
                spacing: 6

                Repeater {
                    model: notifServer.trackedNotifications

                    delegate: Rectangle {
                        id: notifCard
                        required property var modelData
                        width: notifCol.width
                        implicitHeight: notifBody.implicitHeight + 16
                        radius: 6
                        color: "#1a1b26"
                        border.width: 1
                        border.color: modelData.urgency === NotificationUrgency.Critical ? "#f7768e" : "#3b4261"

                        Column {
                            id: notifBody
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 2

                            Text {
                                width: parent.width
                                text: notifCard.modelData.summary
                                color: "#c0caf5"
                                font.bold: true
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 13
                                wrapMode: Text.Wrap
                                textFormat: Text.PlainText
                            }

                            Text {
                                width: parent.width
                                visible: notifCard.modelData.body !== ""
                                text: notifCard.modelData.body
                                color: "#a9b1d6"
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 12
                                wrapMode: Text.Wrap
                                textFormat: Text.PlainText
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: notifCard.modelData.dismiss()
                        }

                        Timer {
                            running: true
                            interval: notifCard.modelData.expireTimeout > 0 ? notifCard.modelData.expireTimeout : 5000
                            onTriggered: notifCard.modelData.expire()
                        }
                    }
                }
            }
        }
    }

    // ---- brightness OSD ----
    Item {
        id: brightnessOsd
        property int percent: 0
        property bool shown: false

        FileView {
            id: brightnessFile
            path: "/sys/class/backlight/intel_backlight/brightness"
            watchChanges: true
            onFileChanged: reload()
            onLoaded: {
                brightnessOsd.percent = Math.round(parseInt(text()) / 96000 * 100);
                brightnessOsd.shown = true;
                brightnessOsdTimer.restart();
            }
        }

        Timer {
            id: brightnessOsdTimer
            interval: 1200
            onTriggered: brightnessOsd.shown = false
        }
    }

    Variants {
        model: Quickshell.screens.filter(s => Hyprland.focusedMonitor && s.name === Hyprland.focusedMonitor.name)

        PanelWindow {
            required property var modelData
            screen: modelData
            visible: brightnessOsd.shown
            anchors { bottom: true }
            margins.bottom: 60
            exclusiveZone: 0
            color: "transparent"
            focusable: false
            implicitWidth: 200
            implicitHeight: 50

            Rectangle {
                anchors.centerIn: parent
                width: 180
                height: 40
                radius: 8
                color: "#1a1b26"
                border.width: 1
                border.color: "#3b4261"

                Row {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        text: "󱎖"
                        color: "#c0caf5"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 16
                    }

                    Rectangle {
                        width: 100
                        height: 6
                        radius: 3
                        color: "#3b4261"
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            width: parent.width * brightnessOsd.percent / 100
                            height: parent.height
                            radius: 3
                            color: "#7aa2f7"
                        }
                    }

                    Text {
                        text: brightnessOsd.percent + "%"
                        color: "#c0caf5"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 13
                    }
                }
            }
        }
    }

    // ---- volume OSD ----
    Item {
        id: volumeOsd
        property int percent: 0
        property bool shown: false
        property string icon: "󰕾"
    }

    Timer {
        id: volumeOsdTimer
        interval: 1200
        onTriggered: volumeOsd.shown = false
    }

    Variants {
        model: Quickshell.screens.filter(s => Hyprland.focusedMonitor && s.name === Hyprland.focusedMonitor.name)

        PanelWindow {
            required property var modelData
            screen: modelData
            visible: volumeOsd.shown
            anchors { bottom: true }
            margins.bottom: 60
            exclusiveZone: 0
            color: "transparent"
            focusable: false
            implicitWidth: 200
            implicitHeight: 50

            Rectangle {
                anchors.centerIn: parent
                width: 180
                height: 40
                radius: 8
                color: "#1a1b26"
                border.width: 1
                border.color: "#3b4261"

                Row {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        text: volumeOsd.icon
                        color: "#c0caf5"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 16
                    }

                    Rectangle {
                        width: 100
                        height: 6
                        radius: 3
                        color: "#3b4261"
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            width: parent.width * volumeOsd.percent / 100
                            height: parent.height
                            radius: 3
                            color: "#7aa2f7"
                        }
                    }

                    Text {
                        text: volumeOsd.percent + "%"
                        color: "#c0caf5"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 13
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "notifcenter"
        function toggle(): void {
            calendar.toggle();
            notifPanel.open = !notifPanel.open;
        }
    }

    // ---- notification review panel (separate window from the calendar) ----
    Item {
        id: notifPanel
        property bool open: false
    }

    Variants {
        model: Quickshell.screens.filter(s => Hyprland.focusedMonitor && s.name === Hyprland.focusedMonitor.name)

        PanelWindow {
            required property var modelData
            screen: modelData
            visible: notifPanel.open
            anchors { top: true; right: true }
            margins { top: 30; right: 8 }
            exclusiveZone: 0
            color: "transparent"
            focusable: false
            implicitWidth: 280
            implicitHeight: notifPanelBg.height

            Rectangle {
                id: notifPanelBg
                width: parent.width
                height: notifPanelCol.implicitHeight + 24
                radius: 8
                color: "#000000"
                border.width: 1
                border.color: "#3b4261"

                Column {
                    id: notifPanelCol
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 12
                    spacing: 8

                    Text {
                        text: "notificaciones"
                        color: "#565f89"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 11
                    }

                    Text {
                        visible: notifServer.trackedNotifications.values.length === 0
                        text: "sin notificaciones"
                        color: "#565f89"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 12
                    }

                    Repeater {
                        model: notifServer.trackedNotifications

                        delegate: Rectangle {
                            id: notifPanelCard
                            required property var modelData
                            width: notifPanelCol.width
                            implicitHeight: notifPanelText.implicitHeight + 8
                            radius: 4
                            color: "transparent"
                            border.width: 1
                            border.color: "#3b4261"

                            Text {
                                id: notifPanelText
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.margins: 6
                                elide: Text.ElideRight
                                text: notifPanelCard.modelData.summary
                                color: "#c0caf5"
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 12
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: notifPanelCard.modelData.dismiss()
                            }
                        }
                    }
                }
            }
        }
    }

    // ---- calendar ----
    Item {
        id: calendar
        property bool open: false
        property date viewMonth: new Date()
        property string selectedDay: ""
        property var eventDays: ({})
        property var dayEvents: []

        function firstWeekday(y, m) { return (new Date(y, m, 1).getDay() + 6) % 7; }
        function lastDay(y, m) { return new Date(y, m + 1, 0).getDate(); }
        function isoDate(y, m, d) {
            return y + "-" + String(m + 1).padStart(2, "0") + "-" + String(d).padStart(2, "0");
        }

        property var cells: {
            const y = viewMonth.getFullYear();
            const m = viewMonth.getMonth();
            const lead = firstWeekday(y, m);
            const total = lastDay(y, m);
            const now = new Date();
            const isCurMonth = now.getFullYear() === y && now.getMonth() === m;
            let arr = [];
            for (let i = 0; i < lead; i++) arr.push({ day: "", today: false, dateStr: "" });
            for (let d = 1; d <= total; d++) {
                arr.push({ day: d, today: isCurMonth && now.getDate() === d, dateStr: isoDate(y, m, d) });
            }
            while (arr.length % 7 !== 0) arr.push({ day: "", today: false, dateStr: "" });
            return arr;
        }

        onViewMonthChanged: monthEventsProc.running = true
        onOpenChanged: if (open) monthEventsProc.running = true

        function selectDay(dateStr) {
            if (!dateStr) return;
            selectedDay = dateStr;
            dayEventsProc.command = ["bash", "-lc", "khal list " + dateStr + " 1d --json start-time --json title 2>/dev/null"];
            dayEventsProc.running = true;
        }

        function moveSelection(deltaDays) {
            const parts = (selectedDay || Qt.formatDate(new Date(), "yyyy-MM-dd")).split("-").map(Number);
            let d = new Date(parts[0], parts[1] - 1, parts[2]);
            d.setDate(d.getDate() + deltaDays);
            viewMonth = new Date(d.getFullYear(), d.getMonth(), 1);
            selectDay(Qt.formatDate(d, "yyyy-MM-dd"));
        }

        function toggle() {
            if (!open) {
                const now = new Date();
                viewMonth = now;
                selectDay(Qt.formatDate(now, "yyyy-MM-dd"));
            }
            open = !open;
        }

        function createEvent(text) {
            if (!text || !selectedDay) return;
            const tokens = text.trim().split(/\s+/);
            newEventProc.command = ["khal", "new", "-a", "joncastas@gmail.com", selectedDay].concat(tokens);
            newEventProc.running = true;
        }

        Process {
            id: newEventProc
            onExited: {
                calendar.selectDay(calendar.selectedDay);
                monthEventsProc.running = true;
                calendarSyncProc.running = true;
            }
        }

        Process {
            id: monthEventsProc
            property int y: calendar.viewMonth.getFullYear()
            property int m: calendar.viewMonth.getMonth()
            command: ["bash", "-lc", "khal list " + calendar.isoDate(y, m, 1) + " " + calendar.isoDate(y, m, calendar.lastDay(y, m)) + " --json start-date --json title 2>/dev/null"]
            onRunningChanged: if (running) calendar.eventDays = {}
            stdout: SplitParser {
                onRead: data => {
                    try {
                        const events = JSON.parse(data);
                        let merged = Object.assign({}, calendar.eventDays);
                        for (const e of events) merged[e["start-date"]] = true;
                        calendar.eventDays = merged;
                    } catch (e) {}
                }
            }
        }

        Process {
            id: dayEventsProc
            command: ["bash", "-lc", "true"]
            stdout: SplitParser {
                onRead: data => {
                    try {
                        calendar.dayEvents = JSON.parse(data);
                    } catch (e) {
                        calendar.dayEvents = [];
                    }
                }
            }
        }
    }

    // ---- calendar sync (google calendar via vdirsyncer) ----
    Timer {
        interval: 600000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: calendarSyncProc.running = true
    }

    Process {
        id: calendarSyncProc
        command: ["bash", "-lc", "vdirsyncer sync 2>&1; rm -f ~/.cache/khal/khal.db"]
        onExited: {
            monthEventsProc.running = true;
            if (calendar.selectedDay) calendar.selectDay(calendar.selectedDay);
        }
    }

    Variants {
        model: Quickshell.screens.filter(s => Hyprland.focusedMonitor && s.name === Hyprland.focusedMonitor.name)

        PanelWindow {
            required property var modelData
            screen: modelData
            visible: calendar.open
            anchors { top: true }
            margins.top: 30
            exclusiveZone: 0
            color: "transparent"
            WlrLayershell.keyboardFocus: calendar.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
            implicitWidth: 280
            implicitHeight: calBg.height

            onVisibleChanged: if (visible) calBg.forceActiveFocus()

            Rectangle {
                id: calBg
                width: parent.width
                height: calCol.implicitHeight + 24
                radius: 8
                color: "#000000"
                border.width: 1
                border.color: "#3b4261"
                focus: true

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_H) { calendar.moveSelection(-1); event.accepted = true; }
                    else if (event.key === Qt.Key_L) { calendar.moveSelection(1); event.accepted = true; }
                    else if (event.key === Qt.Key_J) { calendar.moveSelection(7); event.accepted = true; }
                    else if (event.key === Qt.Key_K) { calendar.moveSelection(-7); event.accepted = true; }
                    else if (event.key === Qt.Key_Escape) {
                        calendar.open = false;
                        notifPanel.open = false;
                        event.accepted = true;
                    }
                    else if (event.key === Qt.Key_I) {
                        newEventField.forceActiveFocus();
                        event.accepted = true;
                    }
                }

                Column {
                    id: calCol
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 12
                    spacing: 8

                    Row {
                        width: parent.width

                        Text {
                            width: 20
                            text: "‹"
                            color: "#c0caf5"
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 14

                            MouseArea {
                                anchors.fill: parent
                                onClicked: calendar.viewMonth = new Date(calendar.viewMonth.getFullYear(), calendar.viewMonth.getMonth() - 1, 1)
                            }
                        }

                        Text {
                            width: parent.width - 40
                            horizontalAlignment: Text.AlignHCenter
                            text: Qt.formatDate(calendar.viewMonth, "MMMM yyyy")
                            color: "#c0caf5"
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 14
                        }

                        Text {
                            width: 20
                            text: "›"
                            color: "#c0caf5"
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 14

                            MouseArea {
                                anchors.fill: parent
                                onClicked: calendar.viewMonth = new Date(calendar.viewMonth.getFullYear(), calendar.viewMonth.getMonth() + 1, 1)
                            }
                        }
                    }

                    Grid {
                        columns: 7
                        columnSpacing: 4
                        rowSpacing: 4

                        Repeater {
                            model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                            delegate: Text {
                                required property string modelData
                                width: 28
                                height: 18
                                horizontalAlignment: Text.AlignHCenter
                                text: modelData
                                color: "#a9b1d6"
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 11
                            }
                        }
                    }

                    Grid {
                        columns: 7
                        columnSpacing: 4
                        rowSpacing: 4

                        Repeater {
                            model: calendar.cells
                            delegate: Rectangle {
                                id: dayCell
                                required property var modelData
                                width: 28
                                height: 24
                                radius: 4
                                color: modelData.today ? "#7aa2f7" : (calendar.selectedDay === modelData.dateStr && modelData.dateStr !== "" ? "#3b4261" : "transparent")

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.day
                                    color: modelData.today ? "#1a1b26" : "#c0caf5"
                                    font.family: "JetBrainsMono Nerd Font Mono"
                                    font.pixelSize: 12
                                }

                                Rectangle {
                                    visible: calendar.eventDays[dayCell.modelData.dateStr] === true
                                    width: 4
                                    height: 4
                                    radius: 2
                                    color: dayCell.modelData.today ? "#1a1b26" : "#7aa2f7"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 2
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    enabled: dayCell.modelData.dateStr !== ""
                                    onClicked: calendar.selectDay(dayCell.modelData.dateStr)
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#3b4261"
                    }

                    Column {
                        width: parent.width
                        spacing: 4

                        Text {
                            text: calendar.selectedDay
                            color: "#a9b1d6"
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 11
                        }

                        Text {
                            visible: calendar.dayEvents.length === 0
                            text: "sin eventos"
                            color: "#565f89"
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 12
                        }

                        Repeater {
                            model: calendar.dayEvents

                            delegate: Text {
                                required property var modelData
                                width: parent.width
                                elide: Text.ElideRight
                                text: (modelData["start-time"] ? modelData["start-time"] + " " : "") + modelData.title
                                color: "#c0caf5"
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 12
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 26
                            radius: 4
                            color: "#24283b"
                            border.width: 1
                            border.color: "#3b4261"

                            TextInput {
                                id: newEventField
                                anchors.fill: parent
                                anchors.margins: 6
                                clip: true
                                color: "#c0caf5"
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 12
                                onAccepted: {
                                    calendar.createEvent(text);
                                    text = "";
                                }
                            }

                            Text {
                                visible: newEventField.text === ""
                                anchors.left: parent.left
                                anchors.leftMargin: 6
                                anchors.verticalCenter: parent.verticalCenter
                                text: "+ nuevo evento"
                                color: "#565f89"
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 12
                            }
                        }
                    }
                }
            }
        }
    }
}
