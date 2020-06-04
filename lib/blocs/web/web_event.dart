part of 'web_bloc.dart';

@immutable
abstract class WebEvent extends Equatable {
  const WebEvent();
}

class LoadWeb extends WebEvent {
  @override
  List<Object> get props => [];
}

class CheckConnection extends WebEvent {
  @override
  List<Object> get props => [];
}