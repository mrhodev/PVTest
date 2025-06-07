// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/reaction_event.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultsScreen extends StatefulWidget {
  @override
  ResultsScreenState createState() => ResultsScreenState();
}

class ResultsScreenState extends State<ResultsScreen> {
  final dbHelper = DatabaseHelper();
  List<int> sessionIds = [];
  int? selectedSessionId;
  List<ReactionEvent> events = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final ids = await dbHelper.getAllSessionIds();
    if (ids.isNotEmpty) {
      setState(() {
        sessionIds = ids;
        selectedSessionId = ids.first;
      });
      _loadEventsForSession(ids.first);
    }
  }

  Future<void> _loadEventsForSession(int sessionId) async {
    final data = await dbHelper.getEventsForSession(sessionId);
    setState(() {
      events = data;
    });
  }

  Widget _buildChart() {
    if (events.isEmpty) {
      return const Center(child: Text('No hay datos disponibles'));
    }

    final anticipados = events.where((e) => e.type == 'anticipado').length;
    final correctos = events.where((e) => e.type != 'anticipado').length;
    final ratio = correctos > 0 ? anticipados / correctos : 0.0;

    final spots = events
        .where((e) => e.type != 'anticipado')
        .map((e) => FlSpot(
              (e.timestamp - events.first.timestamp).toDouble() / 1000,
              e.reactionTime.toDouble(),
            ))
        .toList();

    final validReactionTimes = events
        .where((e) => e.type != 'anticipado')
        .map((e) => e.reactionTime)
        .toList();

    final avgReaction = validReactionTimes.isNotEmpty
        ? validReactionTimes.reduce((a, b) => a + b) / validReactionTimes.length
        : 0.0;

    final avgLineSpots = [
      if (spots.isNotEmpty) FlSpot(spots.first.x, avgReaction),
      if (spots.length > 1) FlSpot(spots.last.x, avgReaction),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promedio reacción: ${avgReaction.toStringAsFixed(0)} ms',
          style: const TextStyle(fontSize: 18, color: Colors.green),
        ),
        const SizedBox(height: 8),
        Text(
          'Toques anticipados: $anticipados',
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
        Text(
          'Ratio anticipados/correctos: ${ratio.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16, color: Colors.orange),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(show: true),
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.black87,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        'Tiempo: ${spot.y.toStringAsFixed(0)} ms',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  barWidth: 2,
                  color: Colors.blueAccent,
                  dotData: const FlDotData(show: false),
                ),
                if (avgLineSpots.length > 1)
                  LineChartBarData(
                    spots: avgLineSpots,
                    isCurved: false,
                    barWidth: 2,
                    color: Colors.green,
                    dotData: const FlDotData(show: false),
                    dashArray: [4, 4],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados del Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: sessionIds.isEmpty
            ? const Center(child: Text('No hay sesiones guardadas'))
            : Column(
                children: [
                  DropdownButton<int>(
                    value: selectedSessionId,
                    onChanged: (value) {
                      if (value != null && value != selectedSessionId) {
                        setState(() => selectedSessionId = value);
                        _loadEventsForSession(value);
                      }
                    },
                    items: sessionIds
                        .map((id) => DropdownMenuItem(
                              value: id,
                              child: Text('Sesión $id'),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: events.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : _buildChart(),
                  ),
                ],
              ),
      ),
    );
  }
}