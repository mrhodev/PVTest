import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/reaction_event.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
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
      return Center(child: Text('No hay datos disponibles'));
    }

    final spots = events
        .map((e) => FlSpot(
              (e.timestamp - events.first.timestamp).toDouble() / 1000, // segundos desde inicio
              e.reactionTime.toDouble(),
            ))
        .toList();

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            barWidth: 2,
            color: Colors.blueAccent,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados del Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (sessionIds.isNotEmpty)
              DropdownButton<int>(
                value: selectedSessionId,
                onChanged: (value) {
                  if (value != null) {
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
            SizedBox(height: 16),
            Expanded(child: _buildChart()),
          ],
        ),
      ),
    );
  }
}
