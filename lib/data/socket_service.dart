import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sound_app/utils/api_endpoints.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late io.Socket socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal() {
    _initializeSocket();
  }

  void _initializeSocket() {
    try {
      debugPrint('Connecting to Socket...');
      socket = io.io(
        ApiEndPoints.baseUrl,
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': true,
        },
      );

      socket.onConnect((_) {
        debugPrint('Connected to Socket Server ${ApiEndPoints.baseUrl}');
      });

      socket.onDisconnect((_) {
        debugPrint('Disconnected from Socket Server ${ApiEndPoints.baseUrl}');
      });
    } catch (e) {
      debugPrint('Socket initialization error: $e');
    }
  }

  io.Socket getSocket() {
    return socket;
  }
}
