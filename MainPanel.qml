import QtQuick 
import QtQuick.Layouts 
import QtQuick.Window 
import QtQuick.Controls
import QtQuick.Dialogs

import io.qt.bridges 1.0


Item {

    id: root
    property int passed_height: 600

    StageBridge{
        id:stageBridge
    }
    
    Item{
        id:keypressHandler
        focus: tabBar.currentIndex === 1

        Keys.onPressed: (event)=> {
            if (!event.isAutoRepeat){
                switch(event.key){
                    case Qt.Key_Left:
                        // console.log("move left")
                        stageBridge.jog("L",jogLeftVal.text)
                        jogLeft.highlighted = true
                        break;
                    case Qt.Key_Right:
                        // console.log("move right")
                        stageBridge.jog("R",jogRightVal.text)
                        jogRight.highlighted = true
                        break;
                    case Qt.Key_Up:
                        // console.log("move up")    
                        stageBridge.jog("U",jogUpVal.text)
                        jogUp.highlighted = true
                        break;
                    case Qt.Key_Down:
                        // console.log("move down")
                        stageBridge.jog("D",jogDownVal.text)
                        jogDown.highlighted = true
                        break;
                    case Qt.Key_PageUp:
                        goNextIdx.highlighted = true
                        goNextIdx.moveNextIdx();
                        break;
                    case Qt.Key_PageDown:
                        goPrevIdx.highlighted = true
                        goPrevIdx.movePrevIdx();
                        break;
                    default:
                }
            }
            
        }
        Keys.onReleased:
        {
            jogUp.highlighted = false
            jogLeft.highlighted = false
            jogRight.highlighted = false
            jogDown.highlighted = false
            goNextIdx.highlighted = false
            goPrevIdx.highlighted = false
        }
    }

    GridLayout{
        columnSpacing: 20
        anchors.fill: parent
        columns: 3
        rows:1
        width: parent.width
        height: root.passed_height
        flow: GridLayout.LeftToRight
        
        ColumnLayout{
            Layout.alignment: Qt.AlignHCenter
            GroupBox{
                title:"Jog"
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter 
                GridLayout{
                    rows:3
                    columns:3
                    flow: GridLayout.LeftToRight
                    anchors.fill:parent
                    Item{}
                    RoundButton{
                        id: jogUp
                        text: "U"
                        onClicked:{
                            stageBridge.jog("U",jogUpVal.text)
                        }
                    }
                    Item{}
                    RoundButton{
                        id: jogLeft
                        text: "L"
                        onClicked:{
                            stageBridge.jog("L",jogLeftVal.text)
                        }
                    }
                    Item{}
                    RoundButton{
                        id: jogRight
                        text: "R"
                        onClicked:{
                            stageBridge.jog("R",jogRightVal.text)
                        }
                    }
                    Item{}
                    RoundButton{
                        id: jogDown
                        text: "D"
                        onClicked:{
                            stageBridge.jog("D",jogDownVal.text)
                        }
                    }
                    Item{}

                }
            }
            GroupBox {
                title: "Jog Settings"

                GridLayout{
                    rows:5
                    columns:2
                    flow: GridLayout.TopToBottom
                    anchors.fill:parent
                    Text {
                        text: "Button"
                    }
                    Text{
                        text: "1 (L)"
                    }
                    Text{
                        text: "2 (D)"
                    }
                    Text{
                        text: "3 (U)"
                    }
                    Text{
                        text: "4 (R)"
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

                    Component.onCompleted:{
                        jogUpVal.text = stageBridge.getDefaultJog('U')
                        jogDownVal.text = stageBridge.getDefaultJog('D')
                        jogLeftVal.text = stageBridge.getDefaultJog('L')
                        jogRightVal.text = stageBridge.getDefaultJog('R')
                    }
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
                        model: ListModel{
                            id:comboElements
                        }
                        Component.onCompleted:{
                            var numCodes = stageBridge.getNumDefectCodes()
                            for (var i = 0; i < numCodes; i++)
                            {
                                comboElements.append({text: stageBridge.getDefectCode(i)})
                            }
                            defectCode.currentIndex = 0
                        }
                    }
                    RoundButton
                    {
                        id:logDefect
                        Layout.alignment:Qt.AlignHCenter
                        Layout.preferredHeight:40
                        Layout.preferredWidth:70
                        text: qsTr("Log")
                        radius: 5
                        onClicked:{
                            stageBridge.logDefect(defectFilename.text,defectComments.text,defectCode.currentText)
                        }
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
                            onClicked:{
                                currentIdx.validator.top = stageBridge.parseMoveFile(presetMoveFilename.text)
                                currentIdx.text = '1'
                            }
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
                            text:"1"
                            validator: IntValidator {
                                bottom: 1
                                top: 1
                            }
                        }
                        RowLayout{
                            Layout.alignment:Qt.AlignHCenter
                            Layout.fillWidth:true
                            
                            RoundButton{
                                id:goPrevIdx
                                text:String.fromCodePoint(0x21e6)
                                radius:4
                                enabled:{
                                    currentIdx.acceptableInput
                                }
                                function movePrevIdx() {
                                    console.log("MovePrev")
                                    if (parseInt(currentIdx.text) > currentIdx.validator.bottom)
                                    {
                                        currentIdx.text = parseInt(currentIdx.text)-1
                                        stageBridge.moveToIdx(parseInt(currentIdx.text))
                                    }
                                }
                                onClicked:{
                                    //Decrement move index
                                    goPrevIdx.movePrevIdx()
                                }
                            }
                            
                            RoundButton{
                                id:goCurrentIdx
                                text:"Go "+String.fromCodePoint(0x21b5)
                                radius:4
                                enabled:{
                                    currentIdx.acceptableInput
                                }
                                onClicked:{
                                    //Go to the move index of whatever is currently in the input box
                                    stageBridge.moveToIdx(parseInt(currentIdx.text))
                                }
                            }

                            RoundButton{
                                id:goNextIdx
                                text:String.fromCodePoint(0x21e8)
                                radius:4
                                enabled:{
                                    currentIdx.acceptableInput
                                }
                                function moveNextIdx() {
                                    console.log("MoveNext")
                                    if (parseInt(currentIdx.text) < currentIdx.validator.top)
                                    {
                                        currentIdx.text = parseInt(currentIdx.text)+1
                                        stageBridge.moveToIdx(parseInt(currentIdx.text))
                                    }
                                }
                                onClicked:{
                                    goNextIdx.moveNextIdx()
                                }
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