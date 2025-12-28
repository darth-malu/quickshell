import QtQuick
import QtQuick.Layouts
import qs.customItems
import qs.services

Item {
    id: root

    implicitWidth: resourceLoader.item ? resourceLoader.item.implicitWidth : 0

    implicitHeight: resourceLoader.item ? resourceLoader.item.implicitHeight : 0

    Loader {
        id: resourceLoader

        active: ResourcesState.resourcesVisible

        visible: active

        sourceComponent: RowLayout {
            id: resourcesRow

            spacing: 16

            PipewireBlock {}

            DiskBlock {}

            MemoryBlock {}

            CpuBlock {}
        }
    }
}
