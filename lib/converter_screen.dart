import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitconverter/unit.dart';
import 'dart:math' as math;

class ConverterScreen extends StatefulWidget {
  final List<Unit> units;
  final ColorSwatch color;
  bool newCategory;

  ConverterScreen({
    @required this.units,
    @required this.color,
    @required this.newCategory,
  })  : assert(units != null),
        assert(color != null),
        assert(newCategory != null);

  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  bool _inputTextError = false;
  Unit _inputUnit, _outputUnit;
  String _inputText = '';
  String _outputText = '';
  BorderRadius _radius = BorderRadius.circular(5.0);
  List<DropdownMenuItem<Unit>> _dropdownList;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.newCategory) {
      _controller.clear();
      _inputUnit = widget.units[0];
      _outputUnit = widget.units[1];
      _outputText = '';
      _inputText = '';

      _dropdownList = widget.units.map((Unit u) {
        return DropdownMenuItem<Unit>(
          value: u,
          child: Text(u.name),
        );
      }).toList();
      widget.newCategory = false;
    }

    return Column(
      children: <Widget>[
        buildInput(),
        buildArrow(),
        buildOutput(),
      ],
    );
  }

  Widget buildInput() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _controller,
            textAlignVertical: TextAlignVertical.bottom,
            style: Theme.of(context).textTheme.headline4,
            keyboardType: TextInputType.number,
            onChanged: _updateOutput,
            decoration: InputDecoration(
              labelText: 'Input',
              labelStyle: Theme.of(context).textTheme.headline4,
              errorText: _inputTextError ? 'Invalid number entered' : null,
              border: OutlineInputBorder(
                borderRadius: _radius,
              ),
            ),
          ),
          _buildDropdown(true),
        ],
      ),
    );
  }

  Widget buildArrow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Transform.rotate(
            angle: math.pi / 2,
            child: IconButton(
              icon: Icon(
                Icons.compare_arrows,
                color: widget.color,
                size: 40.0,
              ),
              onPressed: _swapUnits,
            ),
          )
        ],
      ),
    );
  }

  Widget buildOutput() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            textAlignVertical: TextAlignVertical.bottom,
            child: Text(
              _outputText,
              style: Theme.of(context).textTheme.headline4,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.headline4,
              border: OutlineInputBorder(
                borderRadius: _radius,
              ),
            ),
          ),
          _buildDropdown(false),
        ],
      ),
    );
  }

  Widget _buildDropdown(bool input) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
//              color: Colors.grey[50],
        borderRadius: _radius,
        border: Border.all(
          color: Colors.grey[500],
          width: 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Unit>(
          value: input ? _inputUnit : _outputUnit,
          style: Theme.of(context).textTheme.headline5,
          items: _dropdownList,
          onChanged: (Unit u) {
            setState(() {
              if (input) {
                _inputUnit = u;
              } else {
                _outputUnit = u;
              }
              _updateOutput(_inputText);
            });
          },
        ),
      ),
    );
  }

  void _updateOutput(String num) {
    setState(() {
      if (num == null || num.isEmpty) {
        _outputText = '';
      } else {
        try {
          _inputText = num;
          double inputNum = double.parse(num);
          _inputTextError = false;
          _outputText = _calculateOutputVal(inputNum);
        } on Exception {
          _inputTextError = true;
        }
      }
    });
  }

  String _format(double num) {
    var outputNum = num.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  String _calculateOutputVal(double input) {
    double outputVal = input * (_outputUnit.conversion / _inputUnit.conversion);
    return _format(outputVal);
  }

  void _swapUnits() {
    setState(() {
      Unit tmp = _inputUnit;
      _inputUnit = _outputUnit;
      _outputUnit = tmp;
      _updateOutput(_inputText);
    });
  }
}
