import 'package:audio_recorder/audio_recorder.dart';
import 'package:recorder/audio/base_audio.dart';
import 'package:simple_permissions/simple_permissions.dart';

enum RecorderState { recordingError, permissionsError, recording }

class Recorder extends BaseAudio {
  Future<bool> hasPermissions() async => await AudioRecorder.hasPermissions;

  Future<RecorderState> record() async {
    final isRecording = await AudioRecorder.isRecording;

    if (isRecording) {
      return RecorderState.recording;
    }

    if (await hasPermissions() == false) {
      final result = await requirePermissions();

      if (!result) {
        return RecorderState.permissionsError;
      }
    }

    fileManager.removeFinalFile();
    try {
      await AudioRecorder.start(
          path: fileManager.finalFilePath,
          audioOutputFormat: AudioOutputFormat.AAC);
    } catch (e) {
      print(e);
      return RecorderState.recordingError;
    }

    return RecorderState.recording;
  }

  Future<bool> requirePermissions() async {
    PermissionStatus result =
        await SimplePermissions.requestPermission(Permission.RecordAudio);

    if (result != PermissionStatus.authorized) {
      return false;
    }

    result = await SimplePermissions.requestPermission(
        Permission.WriteExternalStorage);

    return result == PermissionStatus.authorized;
  }

  Future<Recording> stop() async {
    final isRecording = await AudioRecorder.isRecording;

    if (!isRecording) {
      return null;
    }

    return await AudioRecorder.stop();
  }
}
