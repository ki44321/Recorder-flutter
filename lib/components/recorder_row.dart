import 'package:flutter/material.dart';
import 'package:recorder/components/recorder_button.dart';

typedef RecorderRowCallback(bool);

class RecorderRow extends StatefulWidget {
  final RecorderRowCallback onPressed;
  final String title;
  _RecorderRowState _state;

  RecorderRow({Key key, @required this.onPressed, this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    _state = _RecorderRowState();

    return _state;
  }

  setButton({isActive: bool}) {
    _state?.setButton(isActive: isActive);
  }
}

class _RecorderRowState extends State<RecorderRow> {
  RecorderButton _button;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[Text(widget.title), _button],
    );
  }

  @override
  void initState() {
    super.initState();

    _button = RecorderButton(onPressed: (isActive) {
      widget.onPressed(isActive);
    });
  }

  setButton({isActive: bool}) {
    _button.set(isActive: isActive);
  }
}
