import QtQuick //2.15
import QtQuick.Layouts //1.11
import QtQuick.Window //2.1
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    id: root
    property int passed_height: 600
    RowLayout{
        // columnSpacing: 20
        anchors.fill: parent
        // columns: 3
        // rows:1
        width: parent.width
        height: root.passed_height
        GroupBox{
            title: qsTr("Image Feed")
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth:200
            // Layout.fillWidth : true
            ColumnLayout{
                width:parent.width
                Rectangle{
                    Layout.preferredHeight:200
                    Layout.preferredWidth: parent.width
                    color:"dimgray"
                }
            }
        }
        GroupBox{
            title: qsTr("Defect Logging")
            Layout.alignment: Qt.AlignTop
            ColumnLayout
            {
                id: controlColumn
                spacing:10
                width: parent.width
                GroupBox{
                    title:qsTr("Filename")
                    Layout.fillWidth: true
                    TextField{
                        id:defectFilename
                        width:parent.width
                    }
                }
                GroupBox{
                    title:qsTr("Comment")
                    Layout.preferredHeight:100
                    Layout.fillWidth:true
                    TextField{
                        id:defectComments
                        height:parent.height
                        width:parent.width
                        wrapMode: TextField.WordWrap
                    }
                }
                RowLayout{
                    Layout.alignment:Qt.AlignHCenter
                    spacing:20
                    ComboBox{
                        Layout.alignment:Qt.AlignHCenter
                        id:defectCode
                        model: ["Defect Code 0", "Defect Code 1", "Defect Code 2"]
                    }
                    RoundButton
                    {
                        id:logDefectButton
                        Layout.alignment:Qt.AlignHCenter
                        Layout.preferredHeight:40
                        Layout.preferredWidth:70
                        text: qsTr("Log")
                        radius: 5
                    }
                }
            }
        }
        GroupBox{
            Layout.alignment: Qt.AlignTop
            title:"Preset Moves"
            // Layout.fillWidth:true
            ColumnLayout{
                width:parent.width
                id: presetMoveColumn
                GroupBox{
                    title:"Filename"
                    Layout.fillWidth:true
                    ColumnLayout{
                        width:parent.width
                        TextField{
                            id:presetMoveFilename
                            width:parent.width
                            Layout.fillWidth:true
                        }
                        RoundButton{
                            Layout.alignment:Qt.AlignHCenter
                            id:parsePresetMoveFile
                            text:"Parse File"
                            Layout.preferredHeight:25
                            radius:4
                        }
                    }
                }
                GroupBox{
                    title:"Position Index"
                    Layout.preferredWidth:parent.width
                    ColumnLayout{
                        width:parent.width
                        TextField{
                            Layout.alignment:Qt.AlignHCenter
                            Layout.preferredWidth:parent.width/2
                            width:parent.width/2
                            horizontalAlignment: TextField.AlignHCenter
                            id:idx
                        }
                        RowLayout{
                            Layout.alignment:Qt.AlignHCenter
                            Layout.fillWidth:true
                            RoundButton{text:String.fromCodePoint(0x21e6)
                            radius:4}
                            RoundButton{
                                text:"Go "+String.fromCodePoint(0x21b5)
                                radius:4
                            }
                            RoundButton{text:String.fromCodePoint(0x21e8)
                            radius:4}
                        }
                    }
                }
            }
        }
        
    }
}

    