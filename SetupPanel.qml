import QtQuick //2.15
import QtQuick.Layouts //1.11
import QtQuick.Window //2.1
import QtQuick.Controls

Item {
    id: root
    RowLayout{
        spacing: 20
        anchors.fill: parent
        // Layout.preferredWidth: parent.width/2
        // height: root.passed_height
        ColumnLayout{
            id: connSetupColumn
            spacing:10
            Layout.alignment: Qt.AlignTop

            GroupBox{
                title:"Serial Setup"
                ColumnLayout{
                    spacing:10
                    GridLayout
                    {
                        columns:2
                        rows:2
                        flow:GridLayout.TopToBottom
                        Text{text:"COM Port"}
                        Text{text:"Baud"}
                        TextField{
                            id:comPort
                        }
                        TextField{
                            id:baudRate
                        }
                    }
                    RoundButton
                    {
                        Layout.alignment: Qt.AlignCenter
                        Layout.fillWidth:true
                        Layout.preferredHeight:30
                        // Layout.preferredWidth:100
                        text: qsTr("Connect")
                        
                        radius: 4
                    }
                }
            }
            GroupBox
            {
                Layout.fillWidth:true
                title:"Home Stage"
                RoundButton
                {
                    height:parent.height
                    width:parent.width
                    text: qsTr("Home")
                    radius: 4
                }
            }
        }
        ColumnLayout{
            id: jogColumn
            Layout.alignment: Qt.AlignTop
            GroupBox {
                title: "Joystick Jog Buttons"
                // Layout.fillWidth: true
                // Layout.minimumWidth: grood.Layout.minimumWidth + 30
                GridLayout{
                    // id:grood
                    rows:6
                    columns:2
                    flow: GridLayout.TopToBottom
                    anchors.fill:parent
                    Text {
                        text: "Button"
                    }
                    Text{
                        // id: belowTempStartEn
                        text: "1 (L)"
                    }
                    Text{
                        id: timeTilStartStartEn
                        text: "2 (D)"
                    }
                    Text{
                        // id: belowTempStartEn
                        text: "3 (U)"
                    }
                    Text{
                        // id: belowTempStartEn
                        text: "4 (R)"
                    }
                    RoundButton{
                        Layout.fillWidth: true
                        text:"Get"
                        radius:4
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "mm"
                    }
                    TextField {
                        id: belowTempStartVal
                        validator: DoubleValidator {}
                        color: (acceptableInput) ? "#17b01f" : "#b40000"
                    }
                    TextField {
                        id: awdaw
                        validator: DoubleValidator {}
                        color: (acceptableInput) ? "#17b01f" : "#b40000"
                    }
                    TextField {
                        id: awd
                        validator: DoubleValidator {}
                        color: (acceptableInput) ? "#17b01f" : "#b40000"
                    }
                    TextField { 
                        id: timeTilStartStartVal
                        validator: DoubleValidator {}
                        color: (acceptableInput) ? "#17b01f" : "#b40000"
                    }
                    RoundButton{
                        Layout.fillWidth: true
                        text:"Set"
                        radius:4
                    }
                }
            }
        }
        ColumnLayout{
            Layout.alignment: Qt.AlignTop
            GroupBox{
                title:"Debug Output"
                Layout.preferredWidth:300
                Layout.preferredHeight:300
                Rectangle{
                    anchors.fill:parent
                    color:"black"
                    Text{
                        height:parent.height
                        width:parent.width
                        wrapMode: Text.WordWrap
                        verticalAlignment: Text.AlignBottom
                        color:"yellow"
                        text:
                            ">Example debug message \n" +
                            ">Another example debug message \n"+
                            ">The quick brown fox jumps over the lazy dog. ";
                    }   
                }            
            }
        }
        // DataVisColumn{deviceIdx: root.deviceIdx}
        // ControlColumn{deviceIdx: root.deviceIdx}
        // ExperimentSetupColumn{deviceIdx: root.deviceIdx}
    }
}

    