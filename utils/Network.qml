pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var networks: []
    property var currentNetwork: null

    Component {
        id: networkInformation
        QtObject {
            id: network
            required property bool in_use
            required property string bssid
            required property string ssid
            required property string mode
            required property string rate
            required property int sign
            required property int bars
        }
    }

    function mapBars(bar: string): int {
        return 4 - bar.split("_").length + 1;
    }

    function getNetworks(text: string) {
        const networksLength = root.networks.length;
        networks.forEach(nt => nt.destroy());
        networks.splice(0, networksLength);
        if (currentNetwork != null)
            currentNetwork.destroy();
        currentNetwork = null;
        for (const line of text.split("\n")) {
            if (line.trim() == "") {
                continue;
            }
            const network = getNetworkInfoFromLine(line.trim());
            if (network["in_use"]) {
                currentNetwork = network;
            }
            networks.push(network);
        }
    }

    function createNetworkInfo(in_use: bool, bssid: string, ssid: string, mode: string, rate: string, sign: int, bars: int): QtObject {
        const network = networkInformation.createObject(null, {
            in_use: in_use,
            bssid: bssid,
            ssid: ssid,
            mode: mode,
            rate: rate,
            sign: sign,
            bars: bars
        });
        return network;
    }

    function getNetworkInfoFromLine(line: string): QtObject {
        const replacement = line.replace(/\\:/g, "SOMEBIGTEXT");
        const fields = replacement.split(":");
        const in_use = fields[0] == "*";
        const bssid = fields[1].replace(/SOMEBIGTEXT/g, ":");
        const ssid = fields[2];
        const mode = fields[3];
        const rate = fields[4];
        const sign = Number.parseInt(fields[5]);
        const bars = root.mapBars(fields[6]);
        return createNetworkInfo(in_use, bssid, ssid, mode, rate, sign, bars);
    }

    // this one is fast but not accurate
    Process {
        running: true
        command: ['nmcli', '-g', 'IN-USE,BSSID,SSID,MODE,RATE,SIGNAL,BARS', 'device', 'wifi', 'list', '--rescan', 'no']

        stdout: StdioCollector {
            onStreamFinished: {
                root.getNetworks(this.text);
            }
        }
    }

    // this one is slower but accurate
    Process {
        id: getInfoProcess
        running: false
        command: ['nmcli', '-g', 'IN-USE,BSSID,SSID,MODE,RATE,SIGNAL,BARS', 'device', 'wifi', 'list']
        stdout: StdioCollector {
            onStreamFinished: {
                root.getNetworks(this.text);
            }
        }
    }
    Process {
        running: true
        command: ['nmcli', 'device', 'monitor']
        stdout: SplitParser {
            onRead: {
                getInfoProcess.running = true;
            }
        }
    }
}
