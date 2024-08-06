import 'package:flutter/material.dart';

class PreferencesTempoRange extends StatefulWidget {
  const PreferencesTempoRange({super.key});

  @override
  State<PreferencesTempoRange> createState() => _PreferencesTempoRangeState();
}

class _PreferencesTempoRangeState extends State<PreferencesTempoRange> {
  final List<int> _options = [60, 90, 120, 150];
  RangeValues _currentRangeValues = const RangeValues(0, 3);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RangeSlider(
          values: _currentRangeValues,
          min: 0,
          max: (_options.length - 1).toDouble(),
          divisions: _options.length - 1,
          labels: RangeLabels(
            _options[_currentRangeValues.start.round()].toString(),
            _options[_currentRangeValues.end.round()].toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
      ],
    );
  }
}
