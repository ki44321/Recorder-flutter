import 'package:flutter/material.dart';

typedef PressedCallback(bool isPlaying);

abstract class ToggleButton extends StatefulWidget {
  static const int ICON_PLAY = 0xe037;

  static const int ICON_RECORD = 0xe061;
  static const int ICON_STOP = 0xe047;
  ToggleButtonState _state;

  final int playCode;
  final int stopCode; //0xe037, 0xe047
  final double iconSize = 32;
  PressedCallback onPressed;

  ToggleButton(
      {Key key,
      @required this.onPressed,
      @required this.playCode,
      @required this.stopCode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    _state = ToggleButtonState();

    return _state;
  }

  set({isActive: bool}) {
    _state?.set(isActive: isActive);
  }
}

class ToggleButtonState extends State<ToggleButton> {
  bool isActive = false;

  IconData get _icon =>
      isActive ? _iconData(widget.stopCode) : _iconData(widget.playCode);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_icon, size: widget.iconSize),
      onPressed: onPressed,
    );
  }

  onPressed() {
    isActive = !isActive;
    widget.onPressed(isActive);
  }

  set({isActive: bool}) {
    setState(() {
      this.isActive = isActive;
    });
  }

  IconData _iconData(int codePoint) =>
      IconData(codePoint, fontFamily: 'MaterialIcons');
}
