import 'package:flutter/material.dart';
import 'package:recorder/app_localizations.dart';

class RecorderAppBar extends AppBar {
  final BuildContext context;

  RecorderAppBar({Key key, this.context}) : super(key: key);

  @override
  bool get centerTitle => true;

  @override
  Widget get title => _noSubtitle();

  Column _noSubtitle() {
    return Column(
      children: <Widget>[
        Text(AppLocalizations.of(context).title),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}
