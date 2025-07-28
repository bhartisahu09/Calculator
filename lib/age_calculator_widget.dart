import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgeCalculatorWidget extends StatefulWidget {
  const AgeCalculatorWidget({Key? key}) : super(key: key);

  @override
  State<AgeCalculatorWidget> createState() => _AgeCalculatorWidgetState();
}

class _AgeCalculatorWidgetState extends State<AgeCalculatorWidget> {
  DateTime? _selectedDate;
  String? _ageResult;

  // Opens the date picker dialog
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _ageResult = null;
      });
    }
  }

  // Calculates age in years, months, and days
  void _calculateAge() {
    if (_selectedDate == null) return;
    final now = DateTime.now();
    int years = now.year - _selectedDate!.year;
    int months = now.month - _selectedDate!.month;
    int days = now.day - _selectedDate!.day;
    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }
    setState(() {
      _ageResult = '$years years, $months months, $days days';
    });
  }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Select your birth date:',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton.icon(
//             icon: const Icon(Icons.calendar_today),
//             label: Text(_selectedDate == null
//                 ? 'Pick Date'
//                 : DateFormat('yMMMd').format(_selectedDate!)),
//             onPressed: () => _pickDate(context),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _selectedDate == null ? null : _calculateAge,
//             child: const Text('Calculate Age'),
//           ),
//           const SizedBox(height: 24),
//           if (_ageResult != null)
//             AnimatedScale(
//               scale: 1.0,
//               duration: const Duration(milliseconds: 400),
//               curve: Curves.easeOutBack,
//               child: Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     children: [
//                       const Text('Your Age:', style: TextStyle(fontSize: 18)),
//                       const SizedBox(height: 8),
//                       Text(
//                         _ageResult!,
//                         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// } 

@override
Widget build(BuildContext context) {
  return Container(
     color: Colors.white, // ✅ Full background grey
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select your birth date:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: Text(_selectedDate == null
                ? 'Pick Date'
                : DateFormat('yMMMd').format(_selectedDate!)),
            onPressed: () => _pickDate(context),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectedDate == null ? null : _calculateAge,
            child: const Text('Calculate Age'),
          ),
          const SizedBox(height: 24),
          if (_ageResult != null)
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              child: Card(
                color: Colors.white, // ✅ Keep card white for contrast
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text('Your Age:', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(
                        _ageResult!,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
}