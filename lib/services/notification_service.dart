import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final AuthService _authService = AuthService();

  // Initialize notifications
  Future<void> initialize() async {
    try {
      // Request permission
      await requestPermission();

      // Get FCM token
      final token = await _messaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        // Save token to Firestore if user is logged in
        final user = _authService.currentUser;
        if (user != null) {
          await _authService.updateFCMToken(user.uid, token);
        }
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token refreshed: $newToken');
        final user = _authService.currentUser;
        if (user != null) {
          _authService.updateFCMToken(user.uid, newToken);
        }
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  // Request notification permission
  Future<void> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('Notification permission status: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('Error requesting permission: $e');
    }
  }

  // Handle foreground message
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message received: ${message.notification?.title}');
    // TODO: Show local notification or update UI
  }

  // Handle background message
  void _handleBackgroundMessage(RemoteMessage message) {
    debugPrint('Background message opened: ${message.notification?.title}');
    // TODO: Navigate to relevant screen
  }

  // Update FCM token for current user
  Future<void> updateTokenForCurrentUser() async {
    try {
      final token = await _messaging.getToken();
      final user = _authService.currentUser;
      
      if (token != null && user != null) {
        await _authService.updateFCMToken(user.uid, token);
      }
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }
}

// Top-level function for background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.notification?.title}');
}

