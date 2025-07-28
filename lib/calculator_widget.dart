import 'package:flutter/material.dart';
 import 'package:math_expressions/math_expressions.dart';


class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({Key? key}) : super(key: key);

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String _input = '';
  String _result = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _result = '';
      } else if (value == '=') {
        _calculateResult();
      } else {
        _input += value;
      }
    });
  }


void _calculateResult() {
  try {
    String expression = _input.replaceAll('×', '*').replaceAll('÷', '/');
    expression = expression.replaceAll('=', '');

    Parser p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = ContextModel();

    double eval = exp.evaluate(EvaluationType.REAL, cm);

    if (eval % 1 == 0) {
      _result = eval.toInt().toString();
    } else {
      _result = eval.toStringAsFixed(2);
    }
  } catch (e) {
    _result = 'Error';
  }
}

  Widget _buildButton(String text, Color bgColor, Color textColor) {
    return GestureDetector(
      onTap: () => _onButtonPressed(text),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
        ),
        width: 80,
        height: 80,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color numColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    Color opColor = const Color.fromRGBO(39, 87, 255, 1);
    Color textColor = isDark ? Colors.white : Colors.black;

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _input,
                  style: TextStyle(fontSize: 32, color: textColor),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),
                Text(
                  _result,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            _buildButton('C', Colors.grey, Colors.black),
            _buildButton('÷', opColor, Colors.white),
            _buildButton('×', opColor, Colors.white),
            _buildButton('-', opColor, Colors.white),
            _buildButton('7', numColor, textColor),
            _buildButton('8', numColor, textColor),
            _buildButton('9', numColor, textColor),
            _buildButton('+', opColor, Colors.white),
            _buildButton('4', numColor, textColor),
            _buildButton('5', numColor, textColor),
            _buildButton('6', numColor, textColor),
            _buildButton('=', opColor, Colors.white),
            _buildButton('1', numColor, textColor),
            _buildButton('2', numColor, textColor),
            _buildButton('3', numColor, textColor),
            _buildButton('0', numColor, textColor),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
