import QtQuick 
import QtQuick.Layouts 
import QtQuick.Window 
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
                // Layout.fillWidth:true
                Layout.preferredWidth: 250
                ColumnLayout{
                    spacing:10
                    width:parent.width
                    RowLayout
                    {
                        Text{text:"COM Port"; Layout.fillWidth:true}
                        TextField{
                            id:comPort
                            text:"COM8"
                            Layout.preferredWidth:130
                        }
                    }
                    RoundButton
                    {
                        id:connectSerial
                        Layout.alignment: Qt.AlignCenter
                        Layout.fillWidth:true
                        Layout.preferredHeight:30
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
                Layout.preferredWidth: 250
                // Layout.fillWidth:true
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
        
    }
}

    