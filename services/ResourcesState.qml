pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property int cpu_percent
    property real cpu_freq
    property real cpu_temp

    property int gpu_percent
    property string gpu_freq
    property real gpu_temp

    property int mem_percent
    property string mem_used
    property string darth_pool
    property bool resourcesVisible: false

    Process {
        id: process_cpu_percent
        running: false
        command: ["sh", "-c", "top -bn1 | rg '%Cpu' | awk '{print 100-$8}'"]
        stdout: SplitParser {
            onRead: data => cpu_percent = Math.round(data)
        }
    }

    Process {
        id: disk_usage
        running: false
        command: ["sh", "-c", "(zfs get -H -o value avail darthPool 2>/dev/null) || (zfs get -H -o value avail darth-pool 2>/dev/null)"]
        /* command: ["sh", "-c", "zfs get -H -o value avail darthPool darth-pool 2>/dev/null"] */
        stdout: SplitParser {
            onRead: data => darth_pool = data
        }
    }

    Process {
        id: process_cpu_freq
        running: false
        command: ["sh", "-c", "lscpu --parse=MHZ"]
        stdout: SplitParser {
            onRead: data => {
                // delete the first 4 lines (comments)
                // const lines = data.trim().split("\n").slice(4);

                // 1. Split into lines and trim whitespace
                const rawLines = data.trim().split("\n");

                // 2. Filter: Keep only lines that are NOT comments and NOT empty
                const numericLines = rawLines.filter(line => {
                    return line.trim() !== "" && !line.startsWith("#");
                });
                if (numericLines.length === 0)
                    return;

                // 3. Convert to numbers and sum
                const totalMhz = numericLines.reduce((acc, val) => {
                    const num = parseFloat(val);
                    return acc + (isNaN(num) ? 0 : num);
                }, 0);

                // 4. Update the variable
                cpu_freq = Math.round(totalMhz / numericLines.length);
            }
        }
    }

    Process {
        id: process_mem_percent
        running: false
        command: ["sh", "-c", "free | awk 'NR==2{print $3/$2*100}'"]
        stdout: SplitParser {
            onRead: data => mem_percent = Math.round(data)
        }
    }

    Process {
        id: process_mem_used
        running: false
        command: ["sh", "-c", "free --si -h | awk 'NR==2{print $3}'"]
        stdout: SplitParser {
            onRead: data => mem_used = data
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: () => {
            process_cpu_percent.running = true;
            process_cpu_freq.running = true;
            process_mem_percent.running = true;
            process_mem_used.running = true;
            process_mem_used.running = true;
        }
    }
    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: () => {
            disk_usage.running = true;
        }
    }
}
