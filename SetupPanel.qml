import QtQuick //2.15
import QtQuick.Layouts //1.11
import QtQuick.Window //2.1
import QtQuick.Controls

import io.qt.bridges 1.0

Item {
    id: root

    StageBridge{
        id:stageBridge
    }

    RowLayout{
        spacing: 20
        anchors.fill: parent

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
                        rows:1
                        flow:GridLayout.TopToBottom
                        Text{text:"COM Port"}
                        TextField{id:comPort}
                    }
                    RoundButton
                    {
                        id:connectSerial
                        Layout.alignment: Qt.AlignCenter
                        Layout.fillWidth:true
                        Layout.preferredHeight:30
                        // Layout.preferredWidth:100
                        text: qsTr("Connect")
                        onClicked: {
                            stageBridge.connect(comPort.text)
                        }
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
                    id:homeStage
                    height:parent.height
                    width:parent.width
                    text: qsTr("Home")
                    radius: 4
                    onClicked: {
                        stageBridge.home()
                    }
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
                        id:getJogs
                        Layout.fillWidth: true
                        text:"Get"
                        radius:4
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "mm"
                    }
                    TextField {
                        id: jogLeftVal
                        validator: DoubleValidator {bottom:0}
                        color: (acceptableInput) ? "#17b01f" : "#b40000"
                    }
                    TextField {
                        id: jogDownVal
                        validator: DoubleValidator {bottom:0}
                        color: (acceptableInput) ? "#17b01f" : "#b40000"
                    }
                    TextField {
                        id: jogUpVal
                        validator: DoubleValidator {bottom:0}
                        color: (acceptableInput) ? "#17b01f" : "#b40000"
                    }
                    TextField { 
                        id: jogRightVal
                        validator: DoubleValidator {bottom:0}
                        color: (acceptableInput) ? "#17b01f" : "#b40000"
                    }
                    RoundButton{
                        id:setJogs
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
                        id:debugOut
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
    }
}

    