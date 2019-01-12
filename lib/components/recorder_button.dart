import 'package:flutter/material.dart';
import 'package:recorder/components/toggle_button_state.dart';

class RecorderButton extends ToggleButton {
  PressedCallback onPressed;

  RecorderButton({Key key, @required this.onPressed})
      : super(
            key: key,
            onPressed: onPressed,
            playCode: ToggleButton.ICON_RECORD,
            stopCode: ToggleButton.ICON_STOP);
}
