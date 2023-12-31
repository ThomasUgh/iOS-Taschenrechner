import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _display = '0';
  var _history = '';

  void _handleKey(String key) {
    setState(() {
      if (_display == 'Fehler') {
        _display = '';
      }
      if (key == 'AC') {
        _display = '0';
        _history = '';
      } else if (key == '=') {
        _evaluateExpression();
      } else if (key == 'x²') {
        _squareNumber();
      } else if (_isOperator(key)) {
        _history += _display + key;
        _display = '';
      } else {
        if (_display == '0' && key != '.') {
          _display = key;
        } else {
          _display += key;
        }
      }
    });
  }

  void _evaluateExpression() {
    try {
      var expression = _prepareExpression(_history + _display);
      var p = Parser();
      var exp = p.parse(expression);
      var cm = ContextModel();
      var eval = exp.evaluate(EvaluationType.REAL, cm);
      _display = NumberFormat('#,###').format(eval);
      _history = '';
    } catch (e) {
      _display = 'Fehler';
      _history = '';
    }
  }

  void _squareNumber() {
    try {
      var expression = _prepareExpression(_display);
      var p = Parser();
      var exp = p.parse(expression);
      var cm = ContextModel();
      var eval = exp.evaluate(EvaluationType.REAL, cm);
      _display = NumberFormat('#,###').format(eval * eval);
      _history = '';
    } catch (e) {
      _display = 'Fehler';
      _history = '';
    }
  }

  String _prepareExpression(String expression) {
    return expression
        .replaceAll(',', '')
        .replaceAll('x', '*')
        .replaceAll('÷', '/');
  }




  bool _isOperator(String key) {
    return ['+', '-', 'x', '÷', '%'].contains(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(30),
                child: Text(_display,
                    style: const TextStyle(fontSize: 65, color: Colors.white)),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return CalculatorButton(
                  _buttonLabels[index],
                  _buttonColors[index],
                  Colors.white,
                  _handleKey,
                );
              },
              itemCount: _buttonLabels.length,
            ),
          ],
        ),
      ),
    );
  }

  final _buttonLabels = [
    'AC',
    '+/-',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    'x²',
    '.',
    '=',
  ];
  final _buttonColors = [
    Colors.grey[500]!,
    Colors.grey[500]!,
    Colors.grey[500]!,
    Colors.orange,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.orange,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.orange,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.orange,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.orange,
  ];
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Function(String) onPressed;

  const CalculatorButton(this.label, this.color, this.textColor, this.onPressed,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: color,
      borderRadius: BorderRadius.circular(100),
      padding: const EdgeInsets.all(24),
      child: Text(label, style: TextStyle(fontSize: 24, color: textColor)),
      onPressed: () => onPressed(label),
    );
  }
}

