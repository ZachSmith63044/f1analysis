import sys
import fastf1
import json
import tempfile
import pandas as pd
from json import JSONEncoder
import numpy as np
import os

# Define a custom JSONEncoder to handle NumPy int64
class NumpyEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.integer):
            return int(obj)
        return super(NumpyEncoder, self).default(obj)


def extract(arr):
    newArr = []
    for i in range(len(arr)):
        newArr.append(float(arr[i]))
    return newArr
def extractDrs(arr):
    newArr = []
    for i in range(len(arr)):
        if arr[i] >= 10:
            newArr.append(1.0)
        else:
            newArr.append(0.0)
    return newArr
def extractSeconds(arr):
    newArr = []
    for i in range(len(arr)):
        newArr.append(arr[i].total_seconds())
    return newArr
def extractDate(arr):
    newArr = []
    for i in range(len(arr)):
        newArr.append([arr[i].year, arr[i].month, arr[i].day, arr[i].hour, arr[i].second, arr[i].microsecond])
    return newArr

def changeNan(data):
    if pd.isnull(data):
        return -1
    else:
        return data.total_seconds()

def unNan(data):
    if pd.isnull(data):
        return -1
    else:
        return data

def unBool(data):
    if pd.isnull(data):
        return -1
    else:
        if data:
            return 1
        else:
            return 0

def getDriverInfo(driver):
    laps = session.laps.pick_driver(driver)
    allLaps = []
    run = True
    count = 1
    while run:
        try:
            allLaps.append(laps[laps['LapNumber'] == count].iloc[0])
        except:
            run = False

        count += 1
    # [Time,                                                     DriverNumber,           LapTime,                            LapNumber,                  Stint,                  PitOutTime,                             PitInTime,                              Sector1Time,                                Sector2Time,                            Sector3Time,                                Sector1SessionTime,                                 Sector2SessionTime,                                 Sector3SessionTime,                         SpeedI1,            SpeedI2,        SpeedFL, SpeedST, IsPersonalBest, Compound, TyreLife, FreshTyre, Team, LapStartTime, LapStartDate, TrackStatus, IsAccurate]

    lapData = []
    speedData = []
    rpmData = []
    gearData = []
    throttleData = []
    brakeData = []
    drsData = []
    timeData = []
    sessionTimeData = []
    distanceData = []
    relativeDistanceData = []
    xData = []
    yData = []
    zData = []
    weatherData = []
    tyreData = []
    for i in range(len(allLaps)):
        largeArr = []
        try:
            arr = [changeNan(allLaps[i]["Time"]), int(allLaps[i]["DriverNumber"]), changeNan(allLaps[i]["LapTime"]), allLaps[i]["LapNumber"], allLaps[i]["Stint"], changeNan(allLaps[i]["PitOutTime"]), changeNan(allLaps[i]["PitInTime"]), changeNan(allLaps[i]["Sector1Time"]), changeNan(allLaps[i]["Sector2Time"]), changeNan(allLaps[i]["Sector3Time"]), changeNan(allLaps[i]["Sector1SessionTime"]), changeNan(allLaps[i]["Sector2SessionTime"]), changeNan(allLaps[i]["Sector3SessionTime"]), unNan(allLaps[i]["SpeedI1"]), unNan(allLaps[i]["SpeedI2"]), unNan(allLaps[i]["SpeedFL"]), unNan(allLaps[i]["SpeedST"]), int(allLaps[i]["IsPersonalBest"]), ["SOFT", "MEDIUM", "HARD", "INTERMEDIATE", "WET"].index(allLaps[i]["Compound"]), allLaps[i]["TyreLife"], int(allLaps[i]["FreshTyre"]), changeNan(allLaps[i]["LapStartTime"]), allLaps[i]["LapStartDate"].day, allLaps[i]["LapStartDate"].month, allLaps[i]["LapStartDate"].year, int(allLaps[i]["IsAccurate"])]
            lapData.append(arr)
            lapInfo = allLaps[i].get_car_data().add_distance().add_relative_distance()
            speedData.append(extract(lapInfo["Speed"]))
            rpmData.append(extract(lapInfo["RPM"]))
            gearData.append(extract(lapInfo["nGear"]))
            throttleData.append(extract(lapInfo["Throttle"]))
            brakeData.append(extract(lapInfo["Brake"]))
            drsData.append(extractDrs(lapInfo["DRS"]))
            timeData.append(extractSeconds(lapInfo["Time"]))
            sessionTimeData.append(extractSeconds(lapInfo["SessionTime"]))
            distanceData.append(extract(lapInfo["Distance"]))
            relativeDistanceData.append(extract(lapInfo["RelativeDistance"]))
            lapInfo = allLaps[i].get_pos_data()
            xData.append(extract(lapInfo["X"]))
            yData.append(extract(lapInfo["Y"]))
            zData.append(extract(lapInfo["Z"]))
            lapInfo = allLaps[i].get_weather_data()
            tyreData.append([allLaps[i]["Stint"]])
            arr = [changeNan(lapInfo["Time"]), unNan(lapInfo["AirTemp"]), unNan(lapInfo["Humidity"]), unNan(lapInfo["Pressure"]), unBool(lapInfo["Rainfall"]), unNan(lapInfo["TrackTemp"]), unNan(lapInfo["WindDirection"]), unNan(lapInfo["WindSpeed"])]
            weatherData.append(arr)
            
        except Exception as error:
            pass
            #print("error with " + driver)
    return [lapData, speedData, rpmData, gearData, throttleData, brakeData, drsData, timeData, sessionTimeData, distanceData, relativeDistanceData, xData, yData, zData, tyreData, weatherData]


# Check if the correct number of arguments is provided
if len(sys.argv) != 5:
    print("Usage: give.py <year> <track> <session> <drivers>")
    sys.exit(1)

# Retrieve command-line arguments
year = sys.argv[1]
track = sys.argv[2]
session = sys.argv[3]
drivers = sys.argv[4]

# Print the arguments
print("Year:", year)
print("Track:", track)
print("Session:", session)
print("Drivers:", drivers)


session = fastf1.get_session(int(year), track, session)
session.load()

driverNum = session.drivers

print(driverNum)

data = {

}
#results = session.results
for i in range(len(driverNum)):
    data[driverNum[i]] = getDriverInfo(driverNum[i])

results = session.results
driverNumbers = results["DriverNumber"]
driverNumbers2 = []
print(driverNumbers)
for i in range(len(driverNumbers)):
    print(driverNumbers[i])
    driverNumbers2.append(int(driverNumbers[i]))
data["results"] = driverNumbers2

print(driverNumbers2)

teams = []
for i in range(len(driverNumbers2)):
    laps = session.laps.pick_driver(driverNumbers2[i])
    allLaps = []
    count = 1
    run = True
    print("run")
    while run:
        try:
            lap = laps[laps['LapNumber'] == count].iloc[0]
            if lap["Team"] != "nan":
                teams.append(["Red Bull Racing", "McLaren", "Ferrari", "Mercedes", "Aston Martin", "Alpine", "AlphaTauri", "Alfa Romeo", "Haas F1 Team", "Williams"].index(lap["Team"]))
                run = False
            print(lap["Team"], "team")
        except:
            run = False

data["teams"] = teams

drivers3 = []
for i in range(len(driverNumbers2)):
    laps = session.laps.pick_driver(driverNumbers2[i])
    allLaps = []
    count = 1
    run = True
    print("run")
    while run:
        try:
            lap = laps[laps['LapNumber'] == count].iloc[0]
            if lap["Driver"] != "nan":
                drivers3.append(["ALB", "ALO", "BOT", "DEV", "GAS", "GIO", "HAM", "HUL", "KUB", "LAT", "LAW", "LEC", "MAG", "MAZ", "NOR", "OCO", "PER", "PIA", "RIC", "RUS", "SAI", "SAR", "SCH", "STR", "TSU", "VER", "ZHO", "GIO", "RAI", "VET", "MAZ"].index(lap["Driver"]))
                run = False
            print(lap["Driver"], "name")
        except:
            run = False

        count += 1
data["driver3"] = drivers3
folder_path = drivers + '\\f1dataanalysisappdata'

# Check if the folder already exists
if not os.path.exists(folder_path):
    # If it doesn't exist, create the folder
    os.makedirs(folder_path)
    print(f"Folder '{folder_path}' created successfully.")
    
else:
    print(f"Folder '{folder_path}' already exists.")



with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.json', dir=drivers + "\\f1dataanalysisappdata") as temp_file:
    json.dump(data, temp_file, indent=4, cls=NumpyEncoder)

print(f"JSON data saved to: {temp_file.name}")


data = {"name": temp_file.name}
json_file_path = os.path.join(folder_path, 'names.json')
with open(json_file_path, 'w') as json_file:
    json.dump(data, json_file, indent=4)