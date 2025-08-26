import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Scope {
	id: root

	// Bind the pipewire node so its volume will be tracked
	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}

	property bool shouldShowOsd: false

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	// The OSD window will be created and destroyed based on shouldShowOsd.
	// PanelWindow.visible could be set instead of using a loader, but using
	// a loader will reduce the memory overhead when the window isn't open.
	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			// Since the panel's screen is unset, it will be picked by the compositor
			// when the window is created. Most compositors pick the current active monitor.

			anchors.bottom: true
			margins.bottom: screen.height / 5

			implicitWidth: 150
			implicitHeight: 15
			color: "transparent"

			// An empty click mask prevents the window from blocking mouse events.
			mask: Region {}

			Rectangle {
				anchors.fill: parent
				/* radius: height / 10 */
				radius: 30
				color: "#80000000"
				/* color: "transparent" */

				/* SystemTray { */

				/* } */

				RowLayout {
					anchors {
						fill: parent
						leftMargin: 5
						rightMargin: 5
					}

					IconImage {
						implicitSize: 15
						source: "root:assets/speaker/icons8-speaker-30-4.png" //docs are wack...ty outfoxx
						asynchronous: true
					}

					Rectangle { //outer volume bar
						// Stretches to fill all left-over space
						Layout.fillWidth: true

						implicitHeight: 3
						radius: 2
						/* color: "black" //#50ffffff */
						color: "#80000000"

						Rectangle { //inner volume bar
							anchors {
								left: parent.left
								top: parent.top
								bottom: parent.bottom
							}

							implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
							radius: parent.radius
							/* color: "#8B55AB" //#50ffffff */
							// match the system theme background color
							/* color: contentItem.palette.active.window */
						}
					}
				}
			}
		}
	}
}
