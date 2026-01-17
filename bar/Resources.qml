import QtQuick
import QtQuick.Layouts
import qs.customItems
import qs.services

Loader {
    id: resourceLoader

    active: ResourcesState.resourcesVisible

    visible: active

    sourceComponent: RowLayout {
        id: resourcesRow

        spacing: 7

        PipewireBlock {}

        DiskBlock {}

        MemoryBlock {}

        CpuBlock {}
    }
}
