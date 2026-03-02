import 'package:peoplepro/widgets/background_widget.dart';

import 'package:flutter/material.dart';

class JobHistoryScreen extends StatefulWidget {
  const JobHistoryScreen({Key? key}) : super(key: key);

  @override
  State<JobHistoryScreen> createState() => _JobHistoryScreenState();
}

class _JobHistoryScreenState extends State<JobHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Job History",
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Job history currently unavailable."),

                // SpinKitRotatingCircle(color: Colors.white),
                // SpinKitRotatingPlain(color: Colors.white),
                // SpinKitChasingDots(color: Colors.white),
                // SpinKitPumpingHeart(color: Colors.white),
                // SpinKitPulse(color: Colors.white),
                // SpinKitDoubleBounce(color: Colors.white),
                // SpinKitWave(color: Colors.white, type: SpinKitWaveType.start),
                // SpinKitWave(color: Colors.white, type: SpinKitWaveType.center),
                // SpinKitWave(color: Colors.white, type: SpinKitWaveType.end),
                // SpinKitPianoWave(
                //     color: Colors.white, type: SpinKitPianoWaveType.start),
                // SpinKitPianoWave(
                //     color: Colors.white, type: SpinKitPianoWaveType.center),
                // SpinKitPianoWave(
                //     color: Colors.white, type: SpinKitPianoWaveType.end),
                // SpinKitThreeBounce(
                //   color: UserColors.primaryColor,
                //   size: 40.0,
                // ),
                // SpinKitThreeInOut(color: Colors.white),
                // SpinKitWanderingCubes(
                //   color: UserColors.primaryColor,
                //   size: 40.0,
                // ),
                // SpinKitWanderingCubes(
                //     color: Colors.white, shape: BoxShape.circle),
                // SpinKitCircle(
                //   color: UserColors.primaryColor,
                //   size: 40.0,
                // ),
                // SpinKitFadingFour(color: Colors.white),
                // SpinKitFadingFour(
                //     color: Colors.white, shape: BoxShape.rectangle),
                // SpinKitFadingCube(color: Colors.white),
                // SpinKitCubeGrid(size: 51.0, color: Colors.white),
                // SpinKitFoldingCube(
                //   color: UserColors.primaryColor,
                //   size: 40.0,
                // ),
                // SpinKitRing(
                //   color: UserColors.primaryColor,
                //   size: 40.0,
                // ),
                // SpinKitDualRing(color: Colors.white),
                // SpinKitSpinningLines(
                //   color: UserColors.primaryColor,
                //   size: 40.0,
                // ),
                // SpinKitFadingGrid(color: Colors.white),
                // SpinKitFadingGrid(
                //     color: Colors.white, shape: BoxShape.rectangle),
                // SpinKitSquareCircle(color: Colors.orange),
                // SpinKitSpinningCircle(color: Colors.deepOrange),
                // SpinKitSpinningCircle(
                //     color: Colors.white, shape: BoxShape.rectangle),
                // SpinKitFadingCircle(color: Colors.green),
                // SpinKitHourGlass(color: Colors.white),
                // SpinKitPouringHourGlass(color: Colors.white),
                // SpinKitPouringHourGlassRefined(color: Colors.white),
                // SpinKitRipple(color: Colors.white),
                // SpinKitDancingSquare(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
