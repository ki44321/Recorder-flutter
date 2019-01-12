import 'package:flutter/material.dart';
import 'package:recorder/components/toggle_button_state.dart';

class PlayerButton extends ToggleButton {
  PressedCallback onPressed;

  PlayerButton({Key key, @required this.onPressed})
      : super(
            key: key,
            onPressed: onPressed,
            playCode: ToggleButton.ICON_PLAY,
            stopCode: ToggleButton.ICON_STOP);
}
