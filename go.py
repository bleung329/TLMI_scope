#WZs64s7iQPstNXrBvVQ3fnyzKDxeEMI2
import sys
from pathlib import Path

from PySide6.QtGui import QIcon
from PySide6.QtCore import QObject, Slot, QPointF
from PySide6.QtWidgets import QApplication #Has to be QApplication to use QtCharts
from PySide6.QtQml import QQmlApplicationEngine, QmlElement
from PySide6.QtCharts import QAbstractSeries, QValueAxis

#The LTORs_model holds all the logic.
# from controller import LTORs_model

QML_IMPORT_NAME = "io.qt.bridges"
QML_IMPORT_MAJOR_VERSION = 1

# LTORs = LTORs_model()

# @QmlElement
# class DataVisColBridge(QObject):

#     def __init__(self, parent=None):
#         super(DataVisColBridge, self).__init__(parent)
#         self.index = -1

#     @Slot(QAbstractSeries,QValueAxis,int)
#     def update_mass(self,series:QAbstractSeries,valueAxis:QValueAxis,deviceIdx:int):

#         #Try getting the device's mass
#         masses = LTORs.get_masses(deviceIdx)

#         #If it doesn't exist, don't display anything.
#         if masses is None:
#             series.replace([])
#             return
        
#         #Adjust the y axis bounds
#         valueAxis.setMax(max(masses)+5)
#         valueAxis.setMin(min(masses)-5)

#         mass_points = []
#         for x,y in enumerate(masses):
#             if y is None:
#                 continue
#             else:
#                 mass_points.append(QPointF(-9+x,y))
#         series.replace(mass_points)

#     @Slot(QAbstractSeries,QValueAxis,int)
#     def update_temp(self,series:QAbstractSeries,valueAxis:QValueAxis,deviceIdx:int):
#         temps = LTORs.get_temperatures(deviceIdx)
#         #If it doesn't exist, don't display anything.
#         if temps is None:
#             series.replace([])
#             return
        
#         #Adjust the y axis bounds
#         valueAxis.setMax(max(temps)+5)
#         valueAxis.setMin(min(temps)-5)

#         mass_points = []
#         for x,y in enumerate(temps):
#             if y is None:
#                 continue
#             else:
#                 mass_points.append(QPointF(-4+x,y))
#         series.replace(mass_points)

#     @Slot(QAbstractSeries,QAbstractSeries,QValueAxis,int)
#     def update_pres(self,series0:QAbstractSeries,series1:QAbstractSeries,valueAxis:QValueAxis,deviceIdx:int):
#         #Get both pressures
#         p1,p2 = LTORs.get_pressures(deviceIdx)
        
#         #Adjust the y axis bounds
#         if p1 is None or p2 is None:
#             series0.replace([])
#             series1.replace([])
#             return
        
#         #Adjust the y axis bounds
#         valueAxis.setMax(max(p1)+5 if max(p1) > max(p2) else max(p2)+5)
#         valueAxis.setMin(min(p1)-5 if min(p1) < min(p2) else min(p2)-5)

#         p1_points = []
#         for x,y in enumerate(p1):
#             if y is None:
#                 continue
#             else:
#                 p1_points.append(QPointF(-4+x,y))
#         p2_points = []
#         for x,y in enumerate(p2):
#             if y is None:
#                 continue
#             else:
#                 p2_points.append(QPointF(-4+x,y))
                
#         series0.replace(p1_points)
#         series1.replace(p2_points)

# @QmlElement
# class ControlColBridge(QObject):
#     def __init__(self, parent=None):
#         super(ControlColBridge, self).__init__(parent)

#     @Slot(int)
#     def pump_on(self,deviceIdx):
#         LTORs.turn_pump_on(deviceIdx)
        
#     @Slot(int)
#     def pump_off(self,deviceIdx):
#         LTORs.turn_pump_off(deviceIdx)
    
#     @Slot(int, result=str)
#     def get_mass(self,deviceIdx):
#         temp = LTORs.get_masses(deviceIdx)
#         if temp is None:
#             return '-'
#         else:
#             return str(temp[-1])
    
#     @Slot(int, result=str)
#     def get_temp(self,deviceIdx):
#         temp = LTORs.get_temperatures(deviceIdx)
#         if temp is None:
#             return '-'
#         else:
#             return str(temp[-1])
    
#     @Slot(int, result=str)
#     def get_p1(self,deviceIdx):
#         temp1,temp2 = LTORs.get_pressures(deviceIdx)
#         if temp1 is None:
#             return '-'
#         else:
#             return str(temp1[-1])
    
#     @Slot(int, result=str)
#     def get_p2(self,deviceIdx):
#         temp1,temp2 = LTORs.get_pressures(deviceIdx)
#         if temp2 is None:
#             return '-'
#         else:
#             return str(temp2[-1])
        
#     @Slot(int, result=str)
#     def get_expStatus(self,deviceIdx):
#         temp = LTORs.get_experiment_status(deviceIdx)
#         if temp is None:
#             return '-'
#         else:
#             return temp
        
#     @Slot(int, result=str)
#     def get_loadCellScale(self,deviceIdx):
#         temp = LTORs.get_load_cell_scale(deviceIdx)
#         if temp is None:
#             return '-1'
#         else:
#             return temp.strip()
#     @Slot(int, result=str)
#     def get_p1Slope(self,deviceIdx):
#         temp = LTORs.get_p1_slope(deviceIdx)
#         if temp is None:
#             return '-1'
#         else:
#             return temp.strip()
#     @Slot(int, result=str)
#     def get_p1Intercept(self,deviceIdx):
#         temp = LTORs.get_p1_intercept(deviceIdx)
#         if temp is None:
#             return '-1'
#         else:
#             return temp.strip()
#     @Slot(int, result=str)
#     def get_p2Slope(self,deviceIdx):
#         temp = LTORs.get_p2_slope(deviceIdx)
#         if temp is None:
#             return '-1'
#         else:
#             return temp.strip()
#     @Slot(int, result=str)
#     def get_p2Intercept(self,deviceIdx):
#         temp = LTORs.get_p2_intercept(deviceIdx)
#         if temp is None:
#             return '-1'
#         else:
#             return temp.strip()

#     @Slot(int, result=str)
#     def get_tempOffset(self,deviceIdx):
#         temp = LTORs.get_temp_offset(deviceIdx)
#         if temp is None:
#             return '-1'
#         else:
#             return temp.strip()
        
#     @Slot(str, int)
#     def set_loadCellScale(self,val,deviceIdx):
#         LTORs.set_load_cell_scale(val,deviceIdx)
#     @Slot(str, int)
#     def set_p1Slope(self,val,deviceIdx):
#         LTORs.set_p1_slope(val,deviceIdx)
#     @Slot(str, int)
#     def set_p1Intercept(self,val,deviceIdx):
#         LTORs.set_p1_intercept(val,deviceIdx)
#     @Slot(str, int)
#     def set_p2Slope(self,val,deviceIdx):
#         LTORs.set_p2_slope(val,deviceIdx)
#     @Slot(str, int)
#     def set_p2Intercept(self,val,deviceIdx):
#         LTORs.set_p2_intercept(val,deviceIdx)
#     @Slot(str, int)
#     def set_tempOffset(self,val,deviceIdx):
#         LTORs.set_temp_offset(val,deviceIdx)
    

#     @Slot(int)
#     def tare(self,deviceIdx):
#         LTORs.tare(deviceIdx)

#     @Slot(int, result=str)
#     def get_pumpStatus(self,deviceIdx):
#         temp = LTORs.get_pump_status(deviceIdx)
#         if temp is None:
#             return '-'
#         else:
#             return temp

@QmlElement
class ExperimentSetupColBridge(QObject):
    def __init__(self, parent=None):
        super(ExperimentSetupColBridge, self).__init__(parent)

    @Slot(dict)
    def write_file(self,bleh):
        print(bleh)

    @Slot(int,str,str,str,str,str,str,str)
    def start_experiment(self, 
                        device_idx : int,
                        log_file_name : str,
                        temp_start : str,
                        time_start : str,
                        mass_change_stop : str,
                        no_mass_change_dur_stop : str,
                        no_mass_change_tol : str,
                        run_timeout_stop : str):
        
        # LTORs.start_experiment(device_idx,
        #                log_file_name,
        #                temp_start,
        #                time_start,
        #                mass_change_stop,
        #                no_mass_change_dur_stop,
        #                no_mass_change_tol,
        #                run_timeout_stop)
        print("Yeet")
    
    @Slot(int)
    def stop_experiment(self):
        # LTORs.stop_experiment(device_idx)
        print("Yeet")
    

if __name__ == '__main__':
    app = QApplication(sys.argv)
    # icon = QIcon("./innospec.png")
    # app.setWindowIcon(icon)
    engine = QQmlApplicationEngine()

    engine.quit.connect(app.quit)

    qml_file = Path(__file__).parent / 'main.qml'
    engine.load(qml_file)
    # LTORs.setup_devices()
    app.exec()
    # LTORs.kill_threads()