import 'package:flutter/material.dart';
import 'test_screen.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDuration = 1;

  void _startTest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestScreen(durationMinutes: _selectedDuration),
      ),
    );
  }

  void _viewResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PVT Test'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Seleccioná la duración del test", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            DropdownButton<int>(
              value: _selectedDuration,
              items: [1, 5, 10].map((e) {
                return DropdownMenuItem<int>(
                  value: e,
                  child: Text('$e minutos'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedDuration = val;
                  });
                }
              },
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _startTest,
              icon: Icon(Icons.play_arrow),
              label: Text('Iniciar Test'),
            ),
            SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _viewResults,
              icon: Icon(Icons.bar_chart),
              label: Text('Ver Resultados'),
            ),
          ],
        ),
      ),
    );
  }
}
