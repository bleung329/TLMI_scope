import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Window 

//Defined by the user, see main.py
import io.qt.bridges 1.0

ColumnLayout {
    id: root
    property int deviceIdx: -1
    spacing:10
    Layout.alignment:Qt.AlignTop

    ExperimentSetupColBridge {
        id: experimentCon;
    }

    Text {
        Layout.alignment: Qt.AlignCenter
        text: "Experiment Setup " + root.deviceIdx
        font.pointSize: 12
    }
    GroupBox {
        title:"Log File Name"
        Layout.fillWidth: true
        TextField{
            id:logFileInput
            width:parent.width
            validator: RegularExpressionValidator { regularExpression: /^[\w,\s-]+\.[A-Za-z]{3}$/ }
            color: (logFileInput.acceptableInput) ? "#17b01f" : "#b40000"
        }
    }
    // Regex for the filename ^[\w,\s-]+\.[A-Za-z]{3}$

    GroupBox {
        title: "Pump Start Triggers"
        Layout.fillWidth: true
        Layout.minimumWidth: grood.Layout.minimumWidth + 30
        GridLayout{
            id:grood
            rows:2
            flow: GridLayout.TopToBottom
            anchors.fill:parent

            RadioButton{
                id: belowTempStartEn
                text: "Below Temp (C)"
            }
            RadioButton{
                id: timeTilStartStartEn
                text: "Time (HH:MM:SS)"
            }
            TextField {
                id: belowTempStartVal
                validator: DoubleValidator {}
                color: (acceptableInput) ? "#17b01f" : "#b40000"
            }
            TextField { 
                id: timeTilStartStartVal
                validator: RegularExpressionValidator { regularExpression: /[0-9]{2}:[0-9]{2}:[0-9]{2}/ }
                color: (acceptableInput) ? "#17b01f" : "#b40000"
            }
            //For time stuff [0-9]{2}:[0-9]{2}:[0-9]{2}
        }
    }
    GroupBox {
        title: "Pump Stop Triggers"
        Layout.fillWidth: true
        Layout.minimumWidth: gridLayout.Layout.minimumWidth + 30
        GridLayout {
            id: gridLayout
            rows: 4
            flow: GridLayout.TopToBottom
            anchors.fill: parent
            
            CheckBox {
                id:massChangeStopEn
                text: qsTr("Change in Mass\n(g)") 
            }
            CheckBox {
                id:noMassChangeDurStopEn
                text: qsTr("No Mass Change Dur.\n(HH:MM:SS)") 
            }

            Text{ text: "No Mass Change Dur.\nAvg Tolerance (g)" }

            CheckBox { 
                id: runTimeoutDurStopEn
                text: qsTr("Run Timeout Dur.\n(HH:MM:SS)") 
            }
            TextField {
                id:massChangeStopVal
                validator: DoubleValidator {bottom:0}
                color: (acceptableInput) ? "#17b01f" : "#b40000"
            } 
            TextField {
                id:noMassChangeDurStopVal
                validator: RegularExpressionValidator { regularExpression: /[0-9]{2}:[0-9]{2}:[0-9]{2}/ }
                color: (acceptableInput) ? "#17b01f" : "#b40000"
            }
            TextField {
                id:noMassChangeToleranceVal
                text: "0.5"
                validator: DoubleValidator {bottom:0.1}
                color: (acceptableInput) ? "#17b01f" : "#b40000"
            }
            TextField {
                id:runTimeoutDurStopVal
                validator: RegularExpressionValidator { regularExpression: /[0-9]{2}:[0-9]{2}:[0-9]{2}/ }
                color: (acceptableInput) ? "#17b01f" : "#b40000"
            }
        }
    }
    GroupBox{
        Layout.fillWidth: true;
        GridLayout{
            columns: 2
            anchors.fill: parent
            RoundButton{
                id: startExpButton
                background: Rectangle{
                    color: (parent.down) ? "#bbbbbb" :
                        (parent.hovered ? "#d6d6d6" : "#f6f6f6")
                }
                Layout.fillWidth: true
                text: "Start"
                radius: 3
                onClicked: {
                    const start_temp = belowTempStartVal.acceptableInput ? belowTempStartVal.text : '?';
                    const start_time = timeTilStartStartVal.acceptableInput ? timeTilStartStartVal.text : '?';
                    const mass_change_stop = massChangeStopVal.acceptableInput ? massChangeStopVal.text : '?';
                    const no_mass_change_duration_stop = noMassChangeDurStopVal.acceptableInput ? noMassChangeDurStopVal.text : '?';
                    const no_mass_change_tol = noMassChangeToleranceVal.acceptableInput ? noMassChangeToleranceVal.text : '?';
                    const stop_time = runTimeoutDurStopVal.acceptableInput ? runTimeoutDurStopVal.text : '?';
                    experimentCon.start_experiment(
                        root.deviceIdx,
                        logFileInput.text,
                        start_temp,
                        start_time,
                        mass_change_stop,
                        no_mass_change_duration_stop,
                        no_mass_change_tol,
                        stop_time);
                }
                enabled : {
                    //Ensure that the experiment parameters can only be send if everything
                    //is filled out properly.
                    logFileInput.acceptableInput &&
                    !(belowTempStartEn.checked && !belowTempStartVal.acceptableInput) &&
                    !(timeTilStartStartEn.checked && !timeTilStartStartVal.acceptableInput) &&
                    !(massChangeStopEn.checked && !massChangeStopVal.acceptableInput) &&
                    !(noMassChangeDurStopEn.checked && !noMassChangeDurStopVal.acceptableInput) &&
                    !(noMassChangeDurStopEn.checked && !noMassChangeToleranceVal.acceptableInput) &&
                    !(runTimeoutDurStopEn.checked && !runTimeoutDurStopVal.acceptableInput) &&
                    (belowTempStartEn.checked || timeTilStartStartEn.checked) &&
                    (massChangeStopEn.checked || noMassChangeDurStopEn.checked || runTimeoutDurStopEn.checked);
                }
            }
            RoundButton{
                id: stopExpButton
                background: Rectangle{
                    color: (parent.down) ? "#bbbbbb" :
                        (parent.hovered ? "#d6d6d6" : "#f6f6f6")
                }
                onClicked:{
                    experimentCon.stop_experiment(root.deviceIdx);
                }
                Layout.fillWidth: true
                text: "Stop"
                radius: 3
            }
        }
    }
    // GroupBox{
    //     Layout.fillWidth : true
    //     GridLayout{
    //         columns : 2
    //         anchors.fill : parent
    //         RoundButton{
    //             id: spoofButton
    //             text: "Spoof Data"
    //             onClicked:{
    //                 experimentCon.spoof_data(root.deviceIdx,spoofFilename.text);
    //             }
    //         }
    //         TextField{
    //             id: spoofFilename
    //         }
    //     }
    // }
}
