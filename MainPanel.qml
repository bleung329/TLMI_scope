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
                    RowLayout{
                        Layout.alignment:Qt.AlignHCenter
                        TextField{
                            id:defectFilename
                            Layout.preferredWidth:150
                            readOnly : true
                            text:"---"
                        }
                        RoundButton{
                            id:getDefectFile
                            Layout.preferredWidth:30
                            Layout.preferredHeight:20
                            radius:5
                            text:"..."
                            onClicked:{
                                defectFileDialog.open()
                            }
                        }
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
                        id:defectCode
                        Layout.alignment:Qt.AlignHCenter
                        model: ["Defect Code 0", "Defect Code 1", "Defect Code 2"]
                    }
                    RoundButton
                    {
                        id:logDefect
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
            Layout.preferredWidth:200
            // Layout.fillWidth:true
            ColumnLayout{
                width:parent.width
                id: presetMoveColumn
                GroupBox{
                    title:"Filename"
                    Layout.fillWidth:true
                    ColumnLayout{
                        width:parent.width
                        RowLayout{
                            Layout.alignment:Qt.AlignHCenter
                            TextField{
                                id:presetMoveFilename
                                Layout.preferredWidth:100
                                readOnly : true
                                text:"---"
                            }
                            RoundButton{
                                id:getPresetMoveFile
                                Layout.preferredWidth:30
                                Layout.preferredHeight:20
                                radius:5
                                text:"..."
                                onClicked:{
                                    presetFileDialog.open()
                                }
                            }
                        }
                        RoundButton{
                            id:parsePresetMoveFile
                            Layout.alignment:Qt.AlignHCenter
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
                            id:currentIdx
                            Layout.alignment:Qt.AlignHCenter
                            Layout.preferredWidth:parent.width/2
                            width:parent.width/2
                            horizontalAlignment: TextField.AlignHCenter
                        }
                        RowLayout{
                            Layout.alignment:Qt.AlignHCenter
                            Layout.fillWidth:true
                            RoundButton{
                                id:goPrevIdx
                                text:String.fromCodePoint(0x21e6)
                                radius:4
                            }
                            RoundButton{
                                id:goCurrentIdx
                                text:"Go "+String.fromCodePoint(0x21b5)
                                radius:4
                            }
                            RoundButton{
                                id:goNextIdx
                                text:String.fromCodePoint(0x21e8)
                                radius:4
                            }
                        }
                    }
                }
            }
        }
    }
    FileDialog{
        id:presetFileDialog
        title: "Please choose a preset move file"
        onAccepted:{
            presetMoveFilename.text = presetFileDialog.currentFile
        }
    }
    FileDialog{
        id:defectFileDialog
        title: "Please choose a defect file"
        onAccepted:{
            defectFilename.text = defectFileDialog.currentFile
        }
    }
}

    