import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:alarm/alarm.dart';
import 'package:provider/provider.dart';
import '../providers/alarm_provider.dart';

class RingView extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const RingView({super.key, required this.alarmSettings});

  @override
  State<RingView> createState() => _RingViewState();
}

class _RingViewState extends State<RingView> {
  int _stepsTaken = 0;
  int? _initialSteps;
  late Stream<StepCount> _stepCountStream;
  bool _hasStopped = false;

  @override
  void initState() {
    super.initState();
    initPedometer();
  }

  void initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) {
      if (!mounted || _hasStopped) return;

      if (_initialSteps == null) {
        _initialSteps = event.steps;
      }

      setState(() {
        _stepsTaken = event.steps - _initialSteps!;
      });

      final req = Provider.of<AlarmProvider>(context, listen: false).requiredSteps;
      if (_stepsTaken >= req) {
        _hasStopped = true;
        Alarm.stop(widget.alarmSettings.id);
        Navigator.pop(context);
      }
    }).onError((error) {
      print("Pedometer Error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final req = Provider.of<AlarmProvider>(context).requiredSteps;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepOrange, Colors.orangeAccent]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_walk, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text("WALK TO STOP ALARM", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
            const SizedBox(height: 40),
            Text("$_stepsTaken / $req", style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text("Steps Taken", style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

