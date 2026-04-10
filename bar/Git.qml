/* Requirements
+ Different Colors depending on if the work tree is clean or dirty
+ Easy Click to update my dots.
+
*/

import QtQuick
// import Quickshell.Io
import qs.customItems

BarBlock {
    id: gitButton

    // directory_array=(QUICKSHELL SHIBUYA DEVELOPMENT ORG USIU DOOM_CARTHAGE DOOM_TANGIER)

    property list<string> preConfigPath: ["doom", "quickshell"]
    property list<string> postConfigPath: preConfigPath.map(path => '.config' + path)

    property list<string> prePaths: ["Shibuya", "Development", "Documents/IMPORTANT/Org"]
    property list<string> postPaths: prePaths.map(path => '~/' + path)

    property list<string> gitLocations: ["~/.config/doom",]

    content: BarText {
        text: ""
        pointSize: 13
        // color: 'black'
        // verticalAlignment: Text.AlignVCenter // Center the glyph in its box
    }

    // if work tree is clean ... transparent...otherwise hot pink

    // Process {
    //     id: getGitStatus
    //     /*
    //     LOCATIONs
    //      */
    //     command: ["git status"]
    // }
}
