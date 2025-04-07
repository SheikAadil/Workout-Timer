import 'package:flutter/material.dart';
import 'package:workout_timer/Screens/WorkoutTimerScreen.dart';
import 'package:workout_timer/Widgets/DurationPicker.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  Duration _highIntensityDuration = const Duration(seconds: 45);
  Duration _lowIntensityDuration = const Duration(seconds: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DurationPicker(
                label: 'High Intensity Duration',
                initialDuration: _highIntensityDuration,
                onDurationChanged:
                    (duration) => _highIntensityDuration = duration,
              ),
              const SizedBox(height: 20),
              DurationPicker(
                label: 'Low Intensity Duration',
                initialDuration: _lowIntensityDuration,
                onDurationChanged:
                    (duration) => _lowIntensityDuration = duration,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  backgroundColor: const Color(0xFF32D74B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => WorkoutTimerScreen(
                              highIntensityTime:
                                  _highIntensityDuration.inSeconds,
                              lowIntensityTime: _lowIntensityDuration.inSeconds,
                            ),
                      ),
                    );
                  }
                },
                child: const Text(
                  'START TIMER',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
