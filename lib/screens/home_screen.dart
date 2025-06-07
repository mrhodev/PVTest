import 'package:flutter/material.dart';
import 'test_screen.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
        title: const Text('PVT Test'),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Seleccioná la duración del test",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedDuration,
                  decoration: const InputDecoration(
                    labelText: "Duración",
                  ),
                  items: [0, 1, 5, 10].map((e) {
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
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _startTest,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar Test'),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: _viewResults,
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('Ver Resultados'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
