import 'package:flutter/material.dart';
import 'package:recorder/components/player_button.dart';
import 'package:recorder/models/player_item.dart';

typedef PlayerRowCallback(String name);

class PlayerRow extends StatefulWidget {
  final PlayerRowCallback onPressed;
  final PlayerItem recorderItem;

  _PlayerRowState _state;

  PlayerRow({Key key, @required this.onPressed, this.recorderItem})
      : super(key: key);

  String get name => recorderItem.title;

  @override
  State<StatefulWidget> createState() {
    _state = _PlayerRowState();

    return _state;
  }

  setButton({isActive: bool}) {
    _state?.setButton(isActive: isActive);
  }
}

class _PlayerRowState extends State<PlayerRow> {
  PlayerButton _button;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[Text(widget.recorderItem.title), _button],
    );
  }

  @override
  void initState() {
    super.initState();

    _button = PlayerButton(onPressed: (isActive) {
      widget.onPressed(isActive ? widget.recorderItem.title : null);
    });
  }

  setButton({isActive: bool}) {
    _button.set(isActive: isActive);
  }
}
