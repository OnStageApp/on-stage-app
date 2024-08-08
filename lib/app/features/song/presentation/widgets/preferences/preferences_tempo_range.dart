import 'package:flutter/material.dart';

class BPMSelector extends StatefulWidget {
  final Function(double) onChanged;

  const BPMSelector({Key? key, required this.onChanged}) : super(key: key);

  @override
  _BPMSelectorState createState() => _BPMSelectorState();
}

class _BPMSelectorState extends State<BPMSelector> {
  double _currentValue = 70;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'BPM',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRangeText('30'),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    _buildMoreButton(),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white.withOpacity(0.5),
                          thumbColor: Colors.white,
                          overlayColor: Colors.white.withOpacity(0.4),
                          valueIndicatorColor: Colors.white,
                          valueIndicatorTextStyle:
                              const TextStyle(color: Colors.blue),
                        ),
                        child: Slider(
                          value: _currentValue,
                          min: 60,
                          max: 80,
                          divisions: 20,
                          label: '${_currentValue.round()}',
                          onChanged: (value) {
                            setState(() {
                              _currentValue = value;
                            });
                            widget.onChanged(value);
                          },
                        ),
                      ),
                    ),
                    _buildMoreButton(),
                  ],
                ),
              ),
            ),
            _buildRangeText('120+'),
          ],
        ),
      ],
    );
  }

  Widget _buildRangeText(String text) {
    return Container(
      width: 50,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildMoreButton() {
    return Container(
      width: 40,
      height: 50,
      alignment: Alignment.center,
      child: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
    );
  }
}
