import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// Panel window
PanelWindow {
  id: root

  // Theme : Define colors and font
  property color colBg: '#e80a1128'
  property color colBgfoc: "#cc101d42"
  property color colBtnAct: "#cc101d42"
  property color coltxt: "#f2fefcfb"
  property color coltxtsec: "#cc101d42"
  property color coltrans: "#00000000"
  property string fontFamilly: "JetBrainsMono Nerd Font"
  property int fontSize: 12

  anchors.top: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 38
  color: coltrans


  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 4
    anchors.rightMargin: 4
    spacing: 0

    // Left section with rofi launcher and greeting
    Rectangle {
      Layout.fillWidth: false
      implicitWidth: rowLayout.implicitWidth + 16
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.topMargin: 4
      anchors.bottomMargin: 4
      anchors.leftMargin: 8
      anchors.rightMargin: 0
      color: colBg
      radius: 6

      RowLayout {
        id: rowLayout
        anchors.fill: parent
        anchors.margins: 4
        spacing: 4

        // Left-side launcher button (Arch logo SVG embedded). Click to open rofi.
        Rectangle {
          implicitWidth: 30
          height: 32
          radius: 6
          color: coltrans
          anchors.verticalCenter: parent.verticalCenter
          anchors.rightMargin: 0

          Image {
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 3
            anchors.rightMargin: 0
            fillMode: Image.PreserveAspectFit
            source: "file:///usr/share/pixmaps/archlinux-logo.svg"
          }

          Process {
            id: rofi
            command: ["rofi", "-show", "drun"]
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              rofi.startDetached()
            }
          }
        }

        Text {
            Layout.fillWidth: false
            anchors.topMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "|"
            color: coltxtsec
            font { pixelSize: fontSize + 2; bold: false; family: fontFamilly}
        }

        Text {
          anchors.verticalCenter: parent.verticalCenter
          text: " " + Hyprland.activeToplevel?.title ?? " Hello"
          color: coltxt
          font {
              pixelSize: fontSize
              family: fontFamilly
          }
          elide: Text.ElideRight
        }

      }
    }

    // Spacer to push right section to far right
    Item {Layout.fillWidth: true}

    // Right section with info panel
    Rectangle {
      implicitWidth: rowLayout2.implicitWidth + 16
      Layout.fillWidth: false
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.topMargin: 4
      anchors.bottomMargin: 4
      anchors.rightMargin: 0
      anchors.leftMargin: 0
      color: colBg
      radius: 6
      clip: false

      RowLayout {
        id: rowLayout2
        anchors.fill: parent
        anchors.topMargin: 2
        anchors.bottomMargin: 2
        anchors.leftMargin: 8
        anchors.rightMargin: 4
        spacing: 12
        clip: false

      
        IpcHandler {
          target: "volume"
          function update() {
            volumeProcess.running = true
          }
        }

        Process {
          id: volumeProcess
          command: [
            "wpctl",
            "get-volume",
            "@DEFAULT_AUDIO_SINK@"
          ]
          stdout: StdioCollector {
            onStreamFinished: {
              let output = this.text.trim()
              let match = output.match(/([0-9.]+)/)
              if (match) {
                let volume = parseInt(Math.round(parseFloat(match[1]) * 100))
                if (!isNaN(volume)) {
                  if (volume >= 60) {
                    volumeText.text = "  " + volume + "%"
                  } else if (volume >= 30) {
                    volumeText.text = "  " + volume + "%"
                  }  else {
                    volumeText.text = "  " + volume + "%"
                  }
                }
              }
            }
          }
        }

        Text {
          id: volumeText
          verticalAlignment: Text.AlignVCenter
          text: " N/A"
          color: coltxt
          font {
            pixelSize: fontSize
            family: fontFamilly
          }
        }

        Process {
          id: batteryProcess
          command: ["cat", "/sys/class/power_supply/BAT1/capacity"]
          stdout: StdioCollector {
            onStreamFinished: {
              let capacity = parseInt(this.text.trim())
              if (!isNaN(capacity)) {
                if (capacity >= 90) {
                  batteryText.text = "  " + capacity + "%"
                } else if (capacity >= 70) {
                  batteryText.text = "  " + capacity + "%"
                } else if (capacity >= 50) {
                  batteryText.text = "  " + capacity + "%"
                } else if (capacity >= 20) {
                  batteryText.text = "  " + capacity + "%"
                } else {
                  batteryText.text = "  " + capacity + "%"
                }
              }
            }
          }
        }


        Text {
          id: batteryText
          verticalAlignment: Text.AlignVCenter
          text: " N/A"
          color: coltxt
          font {
            pixelSize: fontSize
            family: fontFamilly
          }
        }
        
        Timer {
          interval: 30000
          running: true
          repeat: true

          onTriggered: {
            batteryProcess.running = true
          }
        }

        Timer {
          interval: 60000
          running: true
          repeat: true

          onTriggered: {
            volumeProcess.running = true
          }
        }
                
        Component.onCompleted: {
          batteryProcess.running = true
          volumeProcess.running = true
        }

        Text {
          verticalAlignment: Text.AlignVCenter
          text: Qt.formatDateTime(new Date(), "hh:mm")
          color: coltxt
          font { pixelSize: fontSize; family: fontFamilly }
          
          Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: parent.text = Qt.formatDateTime(new Date(), "hh:mm")
          }
        }

        Text {
          id: powerText
          verticalAlignment: Text.AlignVCenter
          text: "⏻ " 
          color: coltxt
          font {
            pixelSize: fontSize
            family: fontFamilly
          }
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              powerMenu.visible = !powerMenu.visible
            }
          }
        }

      }
    }
  }

  // Centered workspace section (positioned absolutely, not in layout)
  Rectangle {
    width: 10 * 31 + 4
    height: 32
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 4
    color: colBg
    radius: 6

    RowLayout {
      anchors.fill: parent
      anchors.bottomMargin: 2
      anchors.topMargin: 2
      anchors.leftMargin: 4
      anchors.rightMargin: 4
      spacing: 0
          // Repeater... Basically a for loop from 0-8
          Repeater {
          id: rep
          model: 10
 
              Rectangle {
                  width: isActive ? 28 :  25
                  height: 28
                  radius: 6
          
                  anchors.bottomMargin: 1
                  anchors.topMargin: 1
                  anchors.leftMargin: 0
                  anchors.rightMargin: 0

                  // Live data from Hyprland
                  property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                  property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                  color: isActive ? colBtnAct : coltrans

                  Text {
                  anchors.verticalCenter: parent.verticalCenter
                  anchors.horizontalCenter: parent.horizontalCenter
                  verticalAlignment: Text.AlignVCenter
                  horizontalAlignment: Text.AlignHCenter

                  // property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                  // property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                  text: index + 1
                  // color: isActive ? "#f2fefcfb" : (ws ? "#cc101d42" : "#000000")
                  color: isActive ? coltxt : coltxt
                  font { pixelSize: fontSize; bold: true; family: fontFamilly}

                  }

                  // Process for workspace switching
                  Process {
                    id: workspaceSwitch
                    command: [
                      "hyprctl",
                      "eval",
                      "hl.dispatch(hl.dsp.focus({ workspace = " + (index + 1) + " }))"
                    ]                    
                  }
 
                  // Make workspaces clickable
                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: workspaceSwitch.startDetached()
                  } 
              }
          }
      }
  }

  PanelWindow {
    id: powerMenu

    visible: false
    anchors.top: true 
    anchors.right: true 
    implicitWidth: 140 
    implicitHeight: 110
    color: coltrans

    Rectangle {
      anchors.fill: parent 
      anchors.rightMargin: 4

      color: colBg
      radius: 8

      Process {
        id: lockProcess
        command: ["hyprctl", "dispatch", "hl.dsp.exit()"]
      }

      Process {
        id: sleepProcess
        command: ["systemctl", "suspend"]
      }

      Process {
        id: hibernateProcess
        command: ["systemctl", "hibernate"]
      }

      Process {
        id: shutdownProcess
        command: ["systemctl", "poweroff"]
      }

      Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        Text {
          text: "Lock"
          color: coltxt
          font { pixelSize: fontSize; bold: true; family: fontFamilly}
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: lockProcess.startDetached()
          }
        }

        Text {
          text: "Sleep"
          font { pixelSize: fontSize; bold: true; family: fontFamilly}
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: sleepProcess.startDetached()
          }
          color: coltxt
        }

        Text {
          text: "Hibernate"
          font { pixelSize: fontSize; bold: true; family: fontFamilly}
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: hibernateProcess.startDetached()
          }
          color: coltxt
        }

        Text {
          text: "Shutdown"
          color: coltxt
          font { pixelSize: fontSize; bold: true; family: fontFamilly}
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: lockProcess.startDetached()
          }
        }
      }
    }
  }
}

