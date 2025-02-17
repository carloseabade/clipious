class MediaEvent<T> {
  MediaEventType? type;
  MediaState state;
  T? value;

  MediaEvent({this.type, required this.state, this.value});
}

enum MediaEventType { aspectRatioChanged, play, pause, seek, speedChanged, durationChanged, bufferChanged, progress, volumeChanged, fullScreenChanged, enteredPip, exitedPip, miniDisplayChanged }

enum MediaState {
  idle,
  loading,
  buffering,
  playing,
  pause,
  ready,
  error,
  completed;
}
