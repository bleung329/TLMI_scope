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
        columns: 2
        width: parent.width
        height: root.passed_height
        ColumnLayout{
            id: statusColumn
        }
        ColumnLayout{
            id: controlColumn
            property int deviceIdx: -1
            spacing:10
            Layout.alignment: Qt.AlignTop
            // Text {
            //     Layout.alignment: Qt.AlignCenter
            //     text: "Defect Logging"
            //     font.pointSize: 12
            // }
            GroupBox{
                title: qsTr("Defect Comments")
                Layout.fillWidth : true
                ColumnLayout
                {
                    spacing:10
                    Layout.alignment: Qt.AlignTop
                    TextInput{
                        id:defectFilename
                        Layout.preferredHeight:100
                        Layout.preferredWidth:100
                    }
                    TextInput{
                        id:defectComments
                        Layout.preferredHeight:100
                        Layout.preferredWidth:100
                    }
                    // }
                    ComboBox{
                        id:defectCode
                        model: ["DEFECT CODE 0", "DEFECT CODE 1", "DEFECT CODE 2"]
                    }
                    RoundButton
                    {
                        id:logDefectButton
                        Layout.preferredHeight:50
                        Layout.preferredWidth:100
                        text: qsTr("Log")
                        radius: 10
                    }
                }
            }
        }
    }
}

    