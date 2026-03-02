import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:peoplepro/models/bus_employee_model.dart';
import 'package:peoplepro/services/hive_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/widgets/background_widget.dart';

class BusLateScreen extends StatefulWidget {
  const BusLateScreen({Key? key}) : super(key: key);

  @override
  State<BusLateScreen> createState() => _BusLateScreenState();
}

class _BusLateScreenState extends State<BusLateScreen> {
  List<BusEmployeeModel> employees = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadBusEmployees());
  }

  Future<void> loadBusEmployees() async {
    employees = await HiveService.getBusEmployees();
    for (var emp in employees) {
      emp.color = UserColors.primaryColor;
    }
    setState(() {});
  }

  LatLng getRandomLatLng() {
    double radius = 40.0;
    Random random = Random();
    List<LatLng> randomLatLngs = [];
    var zones = Session.userData.attendanceZones!;
    while (randomLatLngs.length < 10) {
      var zone = zones[random.nextInt(zones.length)];
      var baseLat = zone.latitude!;
      var baseLng = zone.longitude!;

      var latDegreeDelta = radius / 111319.9;
      var lngDegreeDelta = radius / (111319.9 * cos(baseLat * pi / 180.0));

      var randomLat =
          baseLat + (random.nextDouble() - 0.5) * 2 * latDegreeDelta;
      var randomLng =
          baseLng + (random.nextDouble() - 0.5) * 2 * lngDegreeDelta;

      var latLng = LatLng(randomLat, randomLng);
      randomLatLngs.add(latLng);
    }
    var outputLatLng = randomLatLngs[random.nextInt(randomLatLngs.length)];
    return outputLatLng;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          title: "Bus Late",
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        var employee = employees[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius:
                                  BorderRadiusDirectional.circular(4.0)),
                          child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.name,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 2.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 0.0),
                                  decoration: BoxDecoration(
                                      color: UserColors.primaryColor,
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Text(
                                    employee.designation,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  employee.department,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
                            trailing: InkWell(
                              child: Icon(
                                Icons.access_time,
                                color: employee.color,
                              ),
                            ),
                            onTap: () async {
                              var outputLatLng = getRandomLatLng();
                              var zoneId = Random().nextInt(10) + 1;
                              var latLng =
                                  "${outputLatLng.latitude},${outputLatLng.longitude}";
                              var clientTime = DateTime.now();
                              var attendTime = await HiveService.take(
                                  employee.empCode, latLng, zoneId, clientTime);
                              print(attendTime);
                              if (attendTime != null) {
                                employee.color = UserColors.green;
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                          child: SizedBox(),
                        );
                      },
                      itemCount: employees.length),
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          employees.shuffle(Random());
                          for (var emp in employees) {
                            var outputLatLng = getRandomLatLng();
                            var zoneId = Random().nextInt(10) + 1;

                            await Future.delayed(Duration(
                                milliseconds: Random().nextInt(800) + 100));

                            var latLng =
                                "${outputLatLng.latitude},${outputLatLng.longitude}";
                            var clientTime = DateTime.now();
                            var attendTime = await HiveService.take(
                                emp.empCode, latLng, zoneId, clientTime);
                            if (attendTime != null) {
                              emp.color = UserColors.green;
                            }
                          }
                          setState(() {});
                        },
                        child: const Text("All")))
              ],
            ),
          )),
    );
  }
}
