import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart'; //PlatForm Exceptionrt';
import 'package:meta/meta.dart';

part 'web_event.dart';
part 'web_state.dart';

class WebBloc extends Bloc<WebEvent, WebState> {
  @override
  WebState get initialState => WebLoading();

  @override
  Stream<WebState> mapEventToState(
    WebEvent event,
  ) async* {
    if (event is CheckConnection) {
      yield* _mapCheckConnectionToState();
    }
    if (event is LoadWeb) {
      yield* _mapLoadWebToState();
    }
  }

  Stream<WebState> _mapLoadWebToState() async* {
    yield WebLoading();
    try {
      yield WebLoaded();
    } catch (_) {
      yield WebError();
    }
  }

  Stream<WebState> _mapCheckConnectionToState() async* {
    yield WebLoading();
    Connectivity _connectivity = Connectivity();
    String _connectionStatus;
    try {
      _connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      _connectionStatus = "Internet connectivity failed";
      yield WebError();
    }

//    if (!mounted) {
//      return;
//    }

    if (_connectionStatus == "ConnectivityResult.mobile" ||
        _connectionStatus == "ConnectivityResult.wifi") {
      print("You are connected to internet");
      yield WebConnected(true, _connectivity, _connectionStatus);
    } else {
      print("You are not connected to internet");
      yield WebConnected(false, _connectivity, _connectionStatus);
    }
  }
}
