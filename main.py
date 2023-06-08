#WZs64s7iQPstNXrBvVQ3fnyzKDxeEMI2
import sys
import csv
from pathlib import Path

from zaber_motion.ascii import Connection
from zaber_motion import Units

from PySide6.QtGui import QIcon
from PySide6.QtCore import QObject, Slot, QPointF
from PySide6.QtWidgets import QApplication #Has to be QApplication to use QtCharts
from PySide6.QtQml import QQmlApplicationEngine, QmlElement
# from PySide6.QtCharts import QAbstractSeries, QValueAxis

#The LTORs_model holds all the logic.
# from controller import LTORs_model

QML_IMPORT_NAME = "io.qt.bridges"
QML_IMPORT_MAJOR_VERSION = 1

class stageModel():

    def __init__(self):
        self.x = -1
        self.y = -1
        self.defectFilename = ""
        self.defectFile = None
        self.defectWriter = None
        self.status = "None"
        ...
    
    def connect(self,com):
        print(com)
        # connection = Connection.open_serial_port(com)
        ...
    
    def home(self):
        ...

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
            # zaberModel.startLog(filename[len("file:///"):],float(freq))

    def parseMoveFile(self,filename):
        print(filename)

    def moveToIdx(self,idx):
        print(idx)
    
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

if __name__ == '__main__':
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    engine.quit.connect(app.quit)

    qml_file = Path(__file__).parent / 'main.qml'
    engine.load(qml_file)
    app.exec()