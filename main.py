#WZs64s7iQPstNXrBvVQ3fnyzKDxeEMI2
import sys
import csv
import threading
import time

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
        #TODO: Will this actually work?
        self.status = "Moving"
        #Send move command to x axis
        self.stageXAxis.move_absolute(position=x + 152.5,
                                  unit=Units.LENGTH_MILLIMETRES,
                                  wait_until_idle=False)
        #Send move command to y axis and wait to complete
        self.stageYAxis.move_absolute(position=y + 152.5,
                                  unit=Units.LENGTH_MILLIMETRES,
                                  wait_until_idle=True)
        self.status = "Idle"

    def connect(self,com):
        #Open connection to the device chain
        connection = Connection.open_serial_port(com)
        #Renumber devices
        connection.renumber_devices()
        #Identify all the devices on the chain.
        connection.detect_devices()
        #Set up all the devices.
        self.joystickDevice = connection.get_device(1)
        self.stageXAxis = connection.get_device(2).get_axis(1)
        self.stageYAxis = connection.get_device(2).get_axis(2)
        
    def setJoystickButton(self,buttonIdx,mm):
        [1,2,3,4]
        
        ...
        
    def home(self):
        #Home both axes if they're available.
        if self.stageXAxis != None:
            self.stageXAxis.home(wait_until_idle=False)
            self.stageYAxis.home(wait_until_idle=True)
            #Then move to center of stage
            self._move(0,0)
            self.x = 0.0
            self.y = 0.0
            self.status = "Idle"

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
            self.x = self.stageXAxis.get_position(unit=Units.LENGTH_MILLIMETRES) - 152.5
            self.y = self.stageYAxis.get_position(unit=Units.LENGTH_MILLIMETRES) - 152.5

    def parseMoveFile(self,filename):
        self.movePoints = []
        with open(filename,newline='\n') as file:
            reader = csv.reader(file,delimiter=',',quotechar='|')
            for row in reader:
                self.movePoints.append([float(row[0]),float(row[1])])
        return len(self.movePoints)

    def moveToIdx(self,idx):
        if len(self.movePoints) > 0:
            self._move(self.movePoints[idx][0],self.movePoints[idx][1])
    
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
        stage.moveToIdx(idx)
    
    @Slot(result=str)
    def getStatus(self):
        return stage.status
    
    @Slot(result=str)
    def getX(self):
        return str(stage.x)

    @Slot(result=str)
    def getY(self):
        return str(stage.y)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    engine.quit.connect(app.quit)

    qml_file = Path(__file__).parent / 'main.qml'
    engine.load(qml_file)
    app.exec()
    stage.__del__()
    