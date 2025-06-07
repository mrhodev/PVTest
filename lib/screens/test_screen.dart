import 'dart:async';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/reaction_event.dart';

class TestScreen extends StatefulWidget {
  final int durationMinutes;

  const TestScreen({super.key, required this.durationMinutes});

  @override
  TestScreenState createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  final dbHelper = DatabaseHelper();

  late final int maxStimuli;

  static const Duration minDelay = Duration(seconds: 2);
  static const Duration maxDelay = Duration(seconds: 5);
  static const Duration lapseThreshold = Duration(milliseconds: 500);

  int currentStimulusNumber = 0;
  int stimuliShown = 0;
  bool waitingForReaction = false;
  bool showingStimulus = false;
  int sessionId = DateTime.now().millisecondsSinceEpoch;

  Timer? _stimulusTimer;
  int? _stimulusTimestamp;
  int? _reactionTime;

  @override
  void initState() {
    super.initState();
    maxStimuli = ((widget.durationMinutes != 0 ? widget.durationMinutes : 0.5) * 60).toInt() ~/ 2; // 1 estímulo cada 2 segundos aprox
    _startTest();
  }

  void _startTest() {
    _scheduleNextStimulus();
  }

  void _scheduleNextStimulus() {
    final randomDelay = minDelay.inMilliseconds +
        (maxDelay.inMilliseconds - minDelay.inMilliseconds) *
            (DateTime.now().millisecondsSinceEpoch % 1000) ~/
            1000;

    _stimulusTimer = Timer(Duration(milliseconds: randomDelay), _showStimulus);
  }

  void _showStimulus() {
    setState(() {
      currentStimulusNumber++;
      showingStimulus = true;
      waitingForReaction = true;
      _reactionTime = null;
      _stimulusTimestamp = DateTime.now().millisecondsSinceEpoch;
    });
  }

  void _registerReaction() async {
    if (waitingForReaction && _stimulusTimestamp != null) {
      // Reacción válida al estímulo
      final now = DateTime.now().millisecondsSinceEpoch;
      final reactionTime = now - _stimulusTimestamp!;

      final event = ReactionEvent(
        sessionId: sessionId,
        timestamp: now,
        reactionTime: reactionTime,
        type: reactionTime > lapseThreshold.inMilliseconds ? 'lapse' : 'normal',
      );

      await dbHelper.insertEvent(event);

      setState(() {
        waitingForReaction = false;
        showingStimulus = false;
        stimuliShown++;
        _reactionTime = reactionTime;
      });

      if (stimuliShown >= maxStimuli) {
        _endTest();
      } else {
        _scheduleNextStimulus();
      }
    } else if (!showingStimulus) {
      // Toque anticipado (antes del estímulo)
      final now = DateTime.now().millisecondsSinceEpoch;
      final event = ReactionEvent(
        sessionId: sessionId,
        timestamp: now,
        reactionTime: -1,
        type: 'anticipado',
      );
      await dbHelper.insertEvent(event);

      // Cierra el SnackBar anterior antes de mostrar uno nuevo
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡No te adelantes! Espera el estímulo.')),
      );
    }
  }

  void _endTest() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _stimulusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stimulusText = showingStimulus
        ? '$currentStimulusNumber'
        : '...';

    final reactionInfo = _reactionTime != null
        ? 'Reacción: $_reactionTime ms'
        : '';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _registerReaction,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test de Vigilancia'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stimulusText,
                style: const TextStyle(fontSize: 80, color: Colors.blueAccent),
              ),
              const SizedBox(height: 24),
              Text(
                reactionInfo,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 48),
              Text(
                'Estimulo ${stimuliShown + 1} de $maxStimuli',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
