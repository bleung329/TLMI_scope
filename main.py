#WZs64s7iQPstNXrBvVQ3fnyzKDxeEMI2
import sys
import csv
import threading
import time
import configparser

from pathlib import Path

from zaber_motion.ascii import Connection
from zaber_motion import Units

from PySide6.QtCore import QObject, Slot
from PySide6.QtWidgets import QApplication #Has to be QApplication to use QtCharts
from PySide6.QtQml import QQmlApplicationEngine, QmlElement

QML_IMPORT_NAME = "io.qt.bridges"
QML_IMPORT_MAJOR_VERSION = 1

class positionPollingThread(threading.Thread):
    def __init__(self, stage):
        super(positionPollingThread, self).__init__(None)
        self.stage = stage
        
    def run(self):
        while self.stage.runThreadsFlag.is_set():
            time.sleep(0.1)
            self.stage.updatePos()

class stageModel():
    def __init__(self):
        self.x = -1
        self.y = -1
        self.defectFilename = ""
        self.defectFile = None
        self.defectWriter = None
        
        #Open the config file and get all the defect codes.
        self.configReader = configparser.ConfigParser()
        self.configReader.read("stageConfig.cfg")
        temp = self.configReader["DEFECT_CODES"]["defectCodes"]
        self.defectCodes = temp.split(',')

        self.status = "None"
        self.movePoints = []
        self.stageXAxis = None
        self.stageYAxis = None
        self.joystickDevice = None
        self.runThreadsFlag = threading.Event()
        self.runThreadsFlag.set()
        self.pollThread = positionPollingThread(self)
        self.pollThread.start()
    
    def _move(self,x,y):
        #Send move command to x axis
        self.stageXAxis.move_absolute(position=x + 152.5,
                                  unit=Units.LENGTH_MILLIMETRES,
                                  wait_until_idle=False)
        #Send move command to y axis and wait to complete
        self.stageYAxis.move_absolute(position=y + 152.5,
                                  unit=Units.LENGTH_MILLIMETRES,
                                  wait_until_idle=True)

    def connect(self,com):
        #Open connection to the device chain
        connection = Connection.open_serial_port(com)

        #Renumber devices
        connection.renumber_devices()

        #Identify all the devices on the chain.
        connection.detect_devices()

        #Set up stage
        self.stageXAxis = connection.get_device(2).get_axis(1)
        self.stageYAxis = connection.get_device(2).get_axis(2)
        
        # self.stageXAxis = connection.get_device(1).get_axis(1)
        # self.stageYAxis = connection.get_device(2).get_axis(1)
        #Set up joystick
        self.joystickDevice = connection.get_device(1)
        
        #Set joystick axis 1 to device 2 axis 1
        self.joystickDevice.generic_command("joystick 1 target 2 1")
        
        #Set joystick axis 2 to device 2 axis 2
        self.joystickDevice.generic_command("joystick 2 target 2 2")

        
    def setJoystickMove(self,buttonIdx,mm):
        #If 1 or 4, left or right
        #If 2 or 3, down or up
        ...
        # self.joystickDevice.generic_command("key {i}".format)
    
    def getJoystickMove(self,buttonIdx):
        #Ask joystick for current command attached to current button.
        resp = self.joystickDevice.generic_command("key {i} info".format(i=buttonIdx))
        
    def home(self):
        #Home both axes if they're available.
        if self.stageXAxis != None:
            self.stageXAxis.home(wait_until_idle=False)
            self.stageYAxis.home(wait_until_idle=True)
            #Then move to center of stage
            self._move(0,0)
            self.x = 0.0
            self.y = 0.0
            self.status = "Active"

    def logDefect(self,filename,defectCode,comment):
        #If the file argument is different from the last one, open the file as a csv writer and store as a property.
        if filename != self.defectFilename:
            self.defectFilename = filename
            if self.defectFile != None:
                self.defectFile.close()
            self.defectFile = open(filename,'w',newline="\n")
            self.defectWriter = csv.writer(self.defectFile,delimiter=',',quotechar='|', quoting=csv.QUOTE_MINIMAL)
            self.defectWriter.writerow([self.x,self.y,defectCode,comment])
        else:
            #Else just write the data point in normally
            if self.defectWriter != None:
                self.defectWriter.writerow([self.x,self.y,defectCode,comment])

    def updatePos(self):
        if self.stageXAxis != None:
            self.x = round(self.stageXAxis.get_position(unit=Units.LENGTH_MILLIMETRES) - 152.5,3)
            self.y = round(self.stageYAxis.get_position(unit=Units.LENGTH_MILLIMETRES) - 152.5,3)

    def parseMoveFile(self,filename):
        self.movePoints = []
        with open(filename,newline='\n') as file:
            reader = csv.reader(file,delimiter=',',quotechar='|')
            for row in reader:
                self.movePoints.append([float(row[0]),float(row[1])])
        return len(self.movePoints)
        
    def __del__(self):
        self.runThreadsFlag.clear()
        if self.stageXAxis != None:
            self.stageXAxis.stop()
            self.stageYAxis.stop()
        #Close the file to save it.
        if self.defectFile != None:
            self.defectFile.close()

stage = stageModel()

@QmlElement
class StageBridge(QObject):
    def __init__(self, parent=None):
        super(StageBridge, self).__init__(parent)
        self.index = -1

    @Slot(str)
    def connect(self,com):
        stage.connect(com)

    @Slot()
    def home(self):
        stage.home()

    @Slot(str,str,str)
    def logDefect(self,filename,defectCode,comment):
        stage.logDefect(filename[len("file:///"):],defectCode,comment)

    @Slot(str,result=int)
    def parseMoveFile(self,filename):
        return stage.parseMoveFile(filename[len("file:///"):])

    @Slot(int)
    def moveToIdx(self,idx):
        if len(stage.movePoints) > 0:
            stage._move(stage.movePoints[idx][0],stage.movePoints[idx][1])
    
    @Slot(result=str)
    def getStatus(self):
        return stage.status
    
    @Slot(result=str)
    def getX(self):
        return str(stage.x)

    @Slot(result=str)
    def getY(self):
        return str(stage.y)
    
    @Slot(int,result=str)
    def getJoystickMove(self,idx):
        return str(stage.getJoystickMove(idx))
    
    @Slot(result=int)
    def getNumDefectCodes(self):
        return len(stage.defectCodes)

    @Slot(int,result=str)
    def getDefectCode(self,idx):
        return stage.defectCodes[idx]
    
    @Slot(str,str)
    def jog(self,direction,distance):
        print(direction,distance)
        if direction == 'L':
            stage._move(stage.x-float(distance),stage.y)
        if direction == 'R':
            stage._move(stage.x+float(distance),stage.y)
        if direction == 'U':
            stage._move(stage.x,stage.y+float(distance))
        if direction == 'D':
            stage._move(stage.x,stage.y-float(distance))

    @Slot(str,result=str)
    def getDefaultJog(self,direction):
        if direction == 'L':
            return stage.configReader["DEFAULT_JOG_VALUES"]['left']
        if direction == 'R':
            return stage.configReader["DEFAULT_JOG_VALUES"]['right']
        if direction == 'U':
            return stage.configReader["DEFAULT_JOG_VALUES"]['up']
        if direction == 'D':
            return stage.configReader["DEFAULT_JOG_VALUES"]['down']
        
    @Slot(int,str)
    def setJoystickMove(self,idx,mm):
        stage.setJoystickMove(idx,float(mm))

if __name__ == '__main__':
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    engine.quit.connect(app.quit)

    qml_file = Path(__file__).parent / 'main.qml'
    engine.load(qml_file)
    app.exec()
    stage.__del__()
    