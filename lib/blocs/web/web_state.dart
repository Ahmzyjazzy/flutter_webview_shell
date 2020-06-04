part of 'web_bloc.dart';

@immutable
abstract class WebState extends Equatable {
  const WebState();
}

class WebLoading extends WebState {
  @override
  List<Object> get props => [];
}

class WebLoaded extends WebState {
  @override
  List<Object> get props => [];
}

class WebError extends WebState {
  @override
  List<Object> get props => [];
}

class WebConnected extends WebState {
  final bool connected;
  final Connectivity connectivity;
  final String connectionStatus;

  WebConnected(
    this.connected,
    this.connectivity,
    this.connectionStatus,
  );

  @override
  List<Object> get props => [connected, connectivity, connectionStatus];
}
