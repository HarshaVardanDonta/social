import 'dart:convert';
import 'package:http/http.dart' as http;

sendPushMEssage(String token, String title, String body) async {
  try {
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            "key=AAAAdE5uyzY:APA91bFd15ry11uaBbFATE0LQFXfkzIBaRn0rgaEt-30LtJkM-exN8n4sPWeHcazdbu5No4Ql7jZtrcBbyxsDLR8pElNR8RczkyNTrCwcFNz9SIbcjNQOfiJplTeZscdpDaT2THxqGHT",
      },
      body: jsonEncode(<String, dynamic>{
        'notification': <String, dynamic>{
          'body': body,
          'title': title,
          'android_channel_id': 'channel id',
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done',
          'body': body,
          'title': title,
        },
        'to': token,
      }),
    );
    // print(token);
    print("sent");
  } catch (e) {
    print(e);
  }
}
