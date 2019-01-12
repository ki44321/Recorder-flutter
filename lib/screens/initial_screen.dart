import 'package:flutter/material.dart';
import 'package:recorder/app_localizations.dart';
import 'package:recorder/audio/player.dart';
import 'package:recorder/audio/recorder.dart';
import 'package:recorder/components/player_row.dart';
import 'package:recorder/components/recorder_app_bar.dart';
import 'package:recorder/components/recorder_row.dart';
import 'package:recorder/models/player_item.dart';

typedef PlayerPressedCallback(String name);

class InitialScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InitialScreenState();
  }
}

class _InitialScreenState extends State<InitialScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _recorder = Recorder();

  bool _enabledPlayResultButton = false;
  bool _isPlayingResult = false;

  Player _player;
  _PlayerRows _playerRows;

  RecorderRow _recorderRow;

  String get _playResultText => _isPlayingResult
      ? AppLocalizations.of(context).stopResult
      : AppLocalizations.of(context).playResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: RecorderAppBar(context: context),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(5.0),
                  children: _playerRows.rows,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: _recorderRow,
                  ),
                  OutlineButton(
                    onPressed:
                        _enabledPlayResultButton ? _onPlayResultPressed : null,
                    child: Text(_playResultText),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _playerRows = _PlayerRows(_onPlayerPressed);

    _recorderRow = RecorderRow(
        onPressed: _onRecordPressed,
        title: AppLocalizations.of(context).record);

    _player.hasPlayingResult.then((exist) {
      setState(() {
        _enabledPlayResultButton = exist;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _player = Player(_onPlayingResultComplete);
  }

  _onPlayerPressed(String name) {
    _playerRows.turnOffPlayerButtons();
    _stop();

    setState(() {
      _isPlayingResult = false;
    });

    if (name != null) {
      _playerRows.turnOnPlayerButton(name);
      _play(name);
    }
  }

  _onPlayingResultComplete() => setState(() {
        _isPlayingResult = false;
      });

  _onPlayResultPressed() async {
    _playerRows.turnOffPlayerButtons();

    if (_isPlayingResult) {
      await _player.stop();
    } else {
      await _player.playFromLocal();
    }

    setState(() {
      _isPlayingResult = !_isPlayingResult;
    });
  }

  _onRecordPressed(isActive) async {
    if (isActive) {
      await _setRecordState();
    } else {
      _playerRows.turnOffPlayerButtons();

      Future.wait([
        _player.stop(),
        _recorder.stop(),
      ]).then((recording) => {});

      setState(() {
        _enabledPlayResultButton = true;
      });

      _recorderRow.setButton(isActive: false);
    }
  }

  _play(String name) {
    // todo check
    final path = _playerRows._getRowBy(name)?.recorderItem?.path;

    if (path != null) {
      _player.playFromAssets(path);
    }
  }

  _setRecordState() async {
    final state = await _recorder.record();
    switch (state) {
      case RecorderState.permissionsError:
        _showError(AppLocalizations.of(context).errorRequiredPermissions);

        break;

      case RecorderState.recordingError:
        _showError(AppLocalizations.of(context).errorRecording);

        break;

      case RecorderState.recording:
        setState(() {
          _player.stopLocal();
          _enabledPlayResultButton = false;
        });

        _recorderRow.setButton(isActive: true);
        break;
    }
  }

  _showError(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }

  _stop() {
    _player.stop();
  }
}

class _PlayerRows {
  List<PlayerRow> rows;

  PlayerPressedCallback pressedCallback;

  _PlayerRows(PlayerPressedCallback pressedCallback) {
    this.pressedCallback = pressedCallback;
    rows = _getRows();
  }

  turnOffPlayerButtons() {
    for (final row in rows) {
      row.setButton(isActive: false);
    }
  }

  turnOnPlayerButton(String name) {
    final row = _getRowBy(name);
    row?.setButton(isActive: true);
  }

  PlayerRow _getRowBy(String name) =>
      rows.firstWhere((row) => row.name == name, orElse: () {});

  _getRows() {
    final rows = <PlayerRow>[];
    final listAudioFiles = [
      PlayerItem(title: "Music", fileName: "music.mp3"),
      PlayerItem(title: "Airport", fileName: "airport.mp3"),
      PlayerItem(title: "Train", fileName: "train.mp3"),
    ];

    for (final recorderItem in listAudioFiles) {
      rows.add(
          PlayerRow(recorderItem: recorderItem, onPressed: pressedCallback));
    }

    return rows;
  }
}
