import 'package:flutter/services.dart';

class TrtcEvent {
  static const EventChannel _channel = const EventChannel('flutter_trtc_plugin_callback');

  static Stream<dynamic> _receivedEvents = _channel.receiveBroadcastStream();

  /// 用于接收native层事件流，开发者无需关注
  static Stream<dynamic> listenEvent() {
    return _receivedEvents
        .map<Map>((dynamic event) => event)
        .map<dynamic>((Map event) => event['method']);
  }
}
