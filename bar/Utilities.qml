import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import qs.utils
import qs.components

WrapperMouseArea {
    onClicked: Opener.togglePanelRight()
    cursorShape: Qt.PointingHandCursor
    WrapperRectangle {
        color: Colors.surface
        radius: 11
        height: 22
        leftMargin: 10
        rightMargin: 10
        RowLayout {
            spacing: 5
            ImageColor {
                inputAsset: {
                    if (Network.currentNetwork) {
                        const bars = Network.currentNetwork.bars;
                        return `wifi_${bars}.svg`;
                    }
                    return "nowifi.svg";
                }
                color: Colors.on_surface.toString()
                Layout.preferredHeight: 15
                Layout.preferredWidth: 15
            }

            Text {
                color: Colors.on_surface
                text: {
                    const sink = Pipewire.defaultAudioSink;
                    const volume = Math.round((sink?.audio.volume ?? 0) * 100);
                    if (sink?.audio.muted ?? false) {
                        return "\ueee8";
                    }
                    const icon = (volume == 0) ? "\uf026" : (volume <= 50) ? "\uf027" : "\uf028";
                    return icon + "  " + (volume > 50 ? " " : "") + volume; // the conditional is that it adds some extra space where the volume bands are bigger
                }
                PwObjectTracker {
                    objects: [Pipewire.defaultAudioSink]
                }
            }
            ImageColor {
                id: batteryImage
                readonly property UPowerDevice device: UPower.displayDevice
                color: device.state == UPowerDeviceState.Charging ? "#4DAE51" : (device.percentage < 0.15) ? Colors.on_error : Colors.on_surface
                inputAsset: {
                    switch (device.state) {
                    case UPowerDeviceState.Charging:
                        return "battery_charging.svg";
                    case UPowerDeviceState.Empty:
                        return "battery_dead.svg";
                    default:
                        const percentage = device.percentage;
                        if (percentage < 0.15)
                            return "battery_urgent.svg";
                        const index = Math.ceil(percentage / 0.25);
                        return `battery_${index}.svg`;
                    }
                    return "battery_1.svg";
                }
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                Layout.rightMargin: -5
            }
            Text {
                id: battery_text
                readonly property UPowerDevice device: UPower.displayDevice
                color: device.state == UPowerDeviceState.Charging ? "#4DAE51" : (device.percentage < 0.15) ? Colors.on_error : Colors.on_surface
                text: {
                    const batteries = ["\uf244", "\uf243", "\uf242", "\uf241", "\uf240"];
                    return Math.round(device.percentage * 100) + (device.percentage < 0.15 ? "!" : "");
                }
            }
        }
    }
}
