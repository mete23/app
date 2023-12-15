import 'package:flutter/material.dart';
import 'package:open_earable/apps/neck_meditation/model/stretch_state.dart';
import 'package:open_earable/apps/neck_meditation/view_model/stretch_view_model.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  final StretchViewModel _viewModel;

  SettingsView(this._viewModel);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final TextEditingController _mainNeckDuration;
  late final TextEditingController _leftNeckDuration;
  late final TextEditingController _rightNeckDuration;
  late final TextEditingController _restingDuration;

  late final StretchViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    this._viewModel = widget._viewModel;
    _mainNeckDuration = TextEditingController(
        text: _viewModel.meditationSettings.mainNeckRelaxation.inSeconds
            .toString());
    _leftNeckDuration = TextEditingController(
        text: _viewModel.meditationSettings.leftNeckRelaxation.inSeconds
            .toString());
    _rightNeckDuration = TextEditingController(
        text: _viewModel.meditationSettings.rightNeckRelaxation.inSeconds
            .toString());
    _restingDuration = TextEditingController(
        text: _viewModel.meditationSettings.restingTime.inSeconds
            .toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Relaxation Settings")),
      body: ChangeNotifierProvider<StretchViewModel>.value(
          value: _viewModel,
          builder: (context, child) => Consumer<StretchViewModel>(
                builder: (context, postureTrackerViewModel, child) =>
                    _buildSettingsView(),
              )),
    );
  }

  Widget _buildSettingsView() {
    return Column(
      children: [
        Card(
          color: Theme.of(context).colorScheme.primary,
          child: ListTile(
            title: Text("OpenEarable"),
            trailing: Text(_viewModel.isTracking
                ? "Tracking"
                : _viewModel.isAvailable
                    ? "Available"
                    : "Unavailable"),
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              // add a switch to control the `isActive` property of the `BadPostureSettings`
              ListTile(
                title: Text("Settings"),
              ),
              ListTile(
                title: Text("Main Neck Relaxation Duration\n(in seconds)"),
                trailing: SizedBox(
                  height: 37.0,
                  width: 52,
                  child: TextField(
                    controller: _mainNeckDuration,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                        labelText: 'Seconds',
                        filled: true,
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      _updateMeditationSettings();
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text("Right Neck Relaxation Duration\n(in seconds)"),
                trailing: SizedBox(
                  height: 37.0,
                  width: 52,
                  child: TextField(
                    controller: _rightNeckDuration,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                        labelText: 'Seconds',
                        filled: true,
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      _updateMeditationSettings();
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text("Left Neck Relaxation Duration\n(in seconds)"),
                trailing: SizedBox(
                  height: 37.0,
                  width: 52,
                  child: TextField(
                    controller: _leftNeckDuration,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                        labelText: 'Seconds',
                        filled: true,
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      _updateMeditationSettings();
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text("Resting Duration between exercises\n(in seconds)"),
                trailing: SizedBox(
                  height: 37.0,
                  width: 52,
                  child: TextField(
                    controller: _restingDuration,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                        labelText: 'Seconds',
                        filled: true,
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      _updateMeditationSettings();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _viewModel.isTracking
                      ? Colors.green[300]
                      : Colors.blue[300],
                  foregroundColor: Colors.black,
                ),
                onPressed: _viewModel.isTracking
                    ? () {
                        _viewModel.calibrate();
                        _viewModel.stopTracking();
                      }
                    : () => _viewModel.startTracking(),
                child: Text(_viewModel.isTracking
                    ? "Calibrate as Main Posture"
                    : "Start Calibration"),
              ),
            )
          ]),
        ),
      ],
    );
  }

  /// Returns the new duration acquired from the Text.
  /// Checks if the string is valid (doesn't contain '-' or '.'.
  /// Maximum allows time of 59 Minute 59 Seconds for UI consistency
  Duration _getNewDuration(Duration duration, String newDuration) {
    if (newDuration.contains('.') || newDuration.contains('-')) return duration;

    int parsed = int.parse(newDuration);

    return parsed > 3599 ? Duration(seconds: 3599) : Duration(seconds: parsed);
  }

  /// Update the Meditation Settings according to values, if field is empty set that timer Duration to 0
  void _updateMeditationSettings() {
    StretchSettings settings = _viewModel.meditationSettings;
    settings.mainNeckRelaxation =
        _getNewDuration(settings.mainNeckRelaxation, _mainNeckDuration.text);
    settings.rightNeckRelaxation =
        _getNewDuration(settings.rightNeckRelaxation, _rightNeckDuration.text);
    settings.leftNeckRelaxation =
        _getNewDuration(settings.leftNeckRelaxation, _leftNeckDuration.text);
    _viewModel.meditationSettings = settings;
        _getNewDuration(settings.restingTime, _restingDuration.text);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
