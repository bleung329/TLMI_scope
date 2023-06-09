import QtQuick 
import QtQuick.Layouts 
import QtQuick.Controls 
import QtQuick.Window 
import QtCharts

import io.qt.bridges 1.0

ApplicationWindow {   
    id:root 
    visible: true
    width: 680 
    height: 400
    title: "TLMI Corp Scope Controller"
    flags: Qt.Window
    
    StageBridge{
        id:stageBridge
    }
    
    //Tab bar object to change between devices
    ColumnLayout
    {
        spacing:20
        RowLayout
        {
            GroupBox
            {
                Layout.preferredWidth:120
                Layout.preferredHeight:75
                Layout.alignment: Qt.AlignCenter
                GridLayout
                {
                    anchors.fill:parent
                    columns: 2
                    rows: 3
                    flow: GridLayout.TopToBottom
                    Text{text:"Status:"}
                    Text{text:"X:"}
                    Text{text:"Y:"}
                    Text{id:statusText;text:"---"; Layout.alignment: Qt.AlignHCenter}
                    Text{id:xText;text:"---"; Layout.alignment: Qt.AlignHCenter}
                    Text{id:yText;text:"---"; Layout.alignment: Qt.AlignHCenter}
                    Timer{
                        id:statusCheckTimer
                        interval: 50 //Update every 100 ms
                        running: false
                        repeat: true
                        onTriggered: {
                            statusText.text = stageBridge.getStatus()
                            xText.text = stageBridge.getX()
                            yText.text = stageBridge.getY()
                        }
                    }
                    Component.onCompleted: {
                        statusCheckTimer.running = true
                    }
                }
            }

            TabBar {   
                id: tabBar
                // Layout.preferredWidth: 300
                Layout.alignment: Qt.AlignBottom
                // Layout.height:30
                contentHeight:40
                contentWidth:300
                // position: Page.footer
                //Device Tabs
                TabButton {
                    height: parent.height
                    text: qsTr("Setup")
                    background: Rectangle
                    {
                        id:tabbyo
                        color: {"green"}
                        opacity: 0.3
                        radius: 5   
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                parent.color = "red"
                            }
                            onExited:
                            {
                                parent.color = "green"
                            }
                        }
                    }
                }
                TabButton {
                    
                    text: qsTr("Main")
                    background: Rectangle
                    {
                        id:tabby
                        color: {"green"}
                        opacity: 0.3
                        radius: 5   
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                parent.color = "red"
                            }
                            onExited:
                            {
                                parent.color = "green"
                            }
                        }
                    }
                }
            }
        }
        
        StackLayout {
            currentIndex: tabBar.currentIndex
            SetupPanel{}
            MainPanel{}
        }
    }
}