import QtQuick //2.15
import QtQuick.Layouts //1.11
import QtQuick.Window //2.1
import QtQuick.Controls

Item {
    id: root
    property int deviceIdx: -1
    property int passed_height: 600
    GridLayout{
        columnSpacing: 20
        anchors.fill: parent
        columns: 3
        Layout.preferredWidth: parent.width
        height: root.passed_height
        ColumnLayout{
            id: boot
            property int deviceIdx: -1
            spacing:10
            Layout.alignment: Qt.AlignTop

            RoundButton
            {
                Layout.alignment: Qt.AlignCenter
                Layout.preferredHeight:100
                Layout.preferredWidth:200
                text: qsTr("Home")
                
                radius: 10
            }
            GroupBox{

            }
        }
        ColumnLayout{   
               
        }
        // DataVisColumn{deviceIdx: root.deviceIdx}
        // ControlColumn{deviceIdx: root.deviceIdx}
        ExperimentSetupColumn{deviceIdx: root.deviceIdx}
    }
}

    