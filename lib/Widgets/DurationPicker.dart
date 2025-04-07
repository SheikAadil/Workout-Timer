import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  final String label;
  final Duration initialDuration;
  final ValueChanged<Duration> onDurationChanged;

  const DurationPicker({
    required this.label,
    required this.initialDuration,
    required this.onDurationChanged,
  });

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  late Duration _selectedDuration;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.initialDuration;
  }

  Future<void> _showDurationPicker() async {
    int initialMinutes = _selectedDuration.inMinutes;
    int initialSeconds = _selectedDuration.inSeconds % 60;

    final result = await showDialog<Duration>(
      context: context,
      builder:
          (context) => _MinuteSecondPickerAlertDialog(
            initialMinutes: initialMinutes,
            initialSeconds: initialSeconds,
          ),
    );

    if (result != null) {
      setState(() {
        _selectedDuration = result;
      });
      widget.onDurationChanged(result);
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showDurationPicker,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_selectedDuration),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Icon(Icons.access_time, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MinuteSecondPickerAlertDialog extends StatefulWidget {
  final int initialMinutes;
  final int initialSeconds;

  const _MinuteSecondPickerAlertDialog({
    required this.initialMinutes,
    required this.initialSeconds,
  });

  @override
  _MinuteSecondPickerAlertDialogState createState() =>
      _MinuteSecondPickerAlertDialogState();
}

class _MinuteSecondPickerAlertDialogState
    extends State<_MinuteSecondPickerAlertDialog> {
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialMinutes;
    _seconds = widget.initialSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2C2C2E),
      title: const Text(
        'Select Duration',
        style: TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberPicker(
              value: _minutes,
              min: 0,
              max: 59,
              label: 'min',
              onChanged: (value) => setState(() => _minutes = value),
            ),
            const Text(
              ':',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            _NumberPicker(
              value: _seconds,
              min: 0,
              max: 59,
              label: 'sec',
              onChanged: (value) => setState(() => _seconds = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('OK', style: TextStyle(color: Color(0xFF32D74B))),
          onPressed:
              () => Navigator.pop(
                context,
                Duration(minutes: _minutes, seconds: _seconds),
              ),
        ),
      ],
    );
  }
}

class _NumberPicker extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final String label;
  final ValueChanged<int> onChanged;

  const _NumberPicker({
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_drop_up, color: Colors.white, size: 40),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
        Text(
          value.toString().padLeft(2, '0'),
          style: const TextStyle(color: Colors.white, fontSize: 34),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 18),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 40,
          ),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
      ],
    );
  }
}
