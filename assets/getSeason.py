import sys
import fastf1
import json
import tempfile
import pandas as pd
from json import JSONEncoder
import numpy as np
import os


year = sys.argv[1]
location = sys.argv[2]

events = fastf1.get_event_schedule(int(year), include_testing=False)


print(events)

print(events)


print(len(events))

driversList = []
driverPoints = []

def getDrivers(session):
    results = session.results
    driverAbb = results["Abbreviation"]
    driverPointsR = results["Points"]
    driverAbb2 = []
    if driverPoints != []:
        driverPointsIn = list(driverPoints[-1])
    else:
        driverPointsIn = []
    for i in range(len(driverAbb)):
        driverAbb2.append(driverAbb[i])
        if not driverAbb[i] in driversList:
            driversList.append(driverAbb[i])
            for j in range(len(driverPoints)):
                driverPoints[j].append(0)
            driverPointsIn.append(0)
        driverPointsIn[driversList.index(driverAbb[i])] += driverPointsR[i]
    driverPoints.append(driverPointsIn)
    return driverAbb2



for i in range(len(events)):
    event = events[events['RoundNumber'] == i + 1].iloc[0]
    if event["EventFormat"] == "conventional":
        session = fastf1.get_session(2023, i + 1, 'Race')
        session.load(laps=False, telemetry=False, weather=False, messages=False, livedata=None)
        result = getDrivers(session)
        print(event["Location"])
    else:
        session = fastf1.get_session(2023, i + 1, 'Sprint')
        session.load(laps=False, telemetry=False, weather=False, messages=False, livedata=None)
        result = getDrivers(session)
        session = fastf1.get_session(2023, i + 1, 'Race')
        session.load(laps=False, telemetry=False, weather=False, messages=False, livedata=None)
        result = getDrivers(session)
        print(event["Location"])
    print(driverPoints)

print(driversList)
print(driverPoints)

values = []

for i in range(len(driversList)):
    driverPointsIn = []
    for j in range(len(driverPoints)):
        driverPointsIn.append(driverPoints[j][i])
    values.append(driverPointsIn)

print()

print(values)

# Create a dictionary using zip
data_map = dict(zip(driversList, values))

# Save the dictionary as a JSON file
with open(location + '/f1dataanalysisappdata/seasondata.json', 'w') as json_file:
    json.dump(data_map, json_file)

print("Data saved to data.json")
