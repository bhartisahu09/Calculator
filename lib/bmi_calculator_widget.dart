import 'package:flutter/material.dart';

class BMICalculatorWidget extends StatefulWidget {
  const BMICalculatorWidget({Key? key}) : super(key: key);

  @override
  State<BMICalculatorWidget> createState() => _BMICalculatorWidgetState();
}

class _BMICalculatorWidgetState extends State<BMICalculatorWidget> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _bmiResult;
  String? _bmiCategory;
  Color? _categoryColor;
  String? _error;

  void _calculateBMI() {
    setState(() {
      _error = null;
      _bmiResult = null;
      _bmiCategory = null;
      _categoryColor = null;
      final heightText = _heightController.text.trim();
      final weightText = _weightController.text.trim();
      if (heightText.isEmpty || weightText.isEmpty) {
        _error = 'Please enter both height and weight.';
        return;
      }
      final height = double.tryParse(heightText);
      final weight = double.tryParse(weightText);
      if (height == null || weight == null || height <= 0 || weight <= 0) {
        _error = 'Invalid input. Enter positive numbers.';
        return;
      }
      final heightM = height / 100;
      final bmi = weight / (heightM * heightM);
      _bmiResult = bmi.toStringAsFixed(1);
      if (bmi < 18.5) {
        _bmiCategory = 'Underweight';
        _categoryColor = Colors.yellow[700];
      } else if (bmi < 25) {
        _bmiCategory = 'Normal';
        _categoryColor = Colors.green[400];
      } else if (bmi < 30) {
        _bmiCategory = 'Overweight';
        _categoryColor = Colors.orange[400];
      } else {
        _bmiCategory = 'Obese';
        _categoryColor = Colors.red[400];
      }
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _calculateBMI,
            child: const Text('Calculate BMI'),
          ),
          const SizedBox(height: 20),
          if (_error != null)
            Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          if (_bmiResult != null && _bmiCategory != null)
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text('Your BMI:', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(
                        _bmiResult!,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _bmiCategory!,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _categoryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 