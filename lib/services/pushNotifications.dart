import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging fbm = FirebaseMessaging();

  Future initialise() async {
    fbm.configure();
  }
}
