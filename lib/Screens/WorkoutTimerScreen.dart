import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WorkoutTimerScreen extends StatefulWidget {
  final int highIntensityTime;
  final int lowIntensityTime;

  const WorkoutTimerScreen({
    required this.highIntensityTime,
    required this.lowIntensityTime,
  });

  @override
  _WorkoutTimerScreenState createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen>
    with WidgetsBindingObserver {
  late int _seconds;
  late bool _isHighIntensity;
  bool _isActive = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isHighIntensity = true;
    _seconds = widget.highIntensityTime;
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
  }

  void _startTimer() {
    setState(() {
      _isActive = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _togglePhase();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isActive = false;
    });
    _timer?.cancel();
  }

  void _togglePhase() {
    setState(() {
      _isHighIntensity = !_isHighIntensity;
      _seconds =
          _isHighIntensity ? widget.highIntensityTime : widget.lowIntensityTime;
    });
  }

  String _formatTime(int seconds) {
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      WakelockPlus.disable();
    } else if (state == AppLifecycleState.resumed) {
      WakelockPlus.enable();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Timer')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C2C2E), Color(0xFF1A1A1A)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E).withOpacity(0.5),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: CircularProgressIndicator(
                        value:
                            _isHighIntensity
                                ? _seconds / widget.highIntensityTime
                                : _seconds / widget.lowIntensityTime,
                        strokeWidth: 20,
                        strokeCap: StrokeCap.round,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _isHighIntensity
                              ? const Color(0xFFFF453A)
                              : const Color(0xFF32D74B),
                        ),
                        backgroundColor: const Color(0xFF48484A),
                      ),
                    ),
                  ),
                  Text(
                    _formatTime(_seconds),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: (_isHighIntensity
                          ? const Color(0xFFFF453A)
                          : const Color(0xFF32D74B))
                      .withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isHighIntensity ? 'HIGH INTENSITY' : 'LOW INTENSITY',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color:
                        _isHighIntensity
                            ? const Color(0xFFFF453A)
                            : const Color(0xFF32D74B),
                    letterSpacing: 1.2,
                  ),
                ),
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
                  elevation: 5,
                  shadowColor: const Color(0xFF32D74B).withOpacity(0.3),
                ),
                onPressed: () {
                  _isActive ? _pauseTimer() : _startTimer();
                },
                child: Text(
                  _isActive ? 'PAUSE' : 'START',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.1,
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
