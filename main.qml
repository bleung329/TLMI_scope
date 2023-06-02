import QtQuick 
import QtQuick.Layouts 
import QtQuick.Controls 
import QtQuick.Window 
import QtQuick.Controls.Material 
import QtCharts

ApplicationWindow {   
    id:root 
    visible: true
    width: 900 
    height: 650
    title: "TLMI Scope Controller"
    flags: Qt.Window
    
    //Tab bar object to change between devices
    TabBar {   
        id: tabBar
        width: parent.width/2

        //Device Tabs
        TabButton {
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
                color: {"green"}
                opacity: 0.3
                radius: 5   
            }
        }
    }
    
    StackLayout {
        currentIndex: tabBar.currentIndex
        y: tabBar.y + tabBar.height + 10;
        SetupPanel{deviceIdx:1}
        MainPanel{}
    }
}