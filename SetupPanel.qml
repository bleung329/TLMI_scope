import QtQuick //2.15
import QtQuick.Layouts //1.11
import QtQuick.Window //2.1

Item {
    id: root
    property int deviceIdx: -1
    property int passed_height: 600
    GridLayout{
        columnSpacing: 20
        anchors.fill: parent
        columns: 3
        width: parent.width
        height: root.passed_height
        // DataVisColumn{deviceIdx: root.deviceIdx}
        // ControlColumn{deviceIdx: root.deviceIdx}
        ExperimentSetupColumn{deviceIdx: root.deviceIdx}
    }
}

    