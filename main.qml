import QtQuick 
import QtQuick.Layouts 
import QtQuick.Controls 
import QtQuick.Window 
import QtCharts

ApplicationWindow {   
    id:root 
    visible: true
    width: 750 
    height: 400
    title: "TLMI Scope Controller"
    flags: Qt.Window
    
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
                    Text{text:"---"; Layout.alignment: Qt.AlignHCenter}
                    Text{text:"---"; Layout.alignment: Qt.AlignHCenter}
                    Text{text:"---"; Layout.alignment: Qt.AlignHCenter}
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
                        color: {"green"}
                        opacity: 0.3
                        radius: 5   
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
                                tabby.color = "red"
                            }
                            onExited:
                            {
                                tabby.color = "green"
                            }
                        }
                    }
                }
            }
        }
        
        StackLayout {
            currentIndex: tabBar.currentIndex
            // y: tabBar.y + tabBar.height + 50;
            SetupPanel{}
            MainPanel{}
        }
    }
}