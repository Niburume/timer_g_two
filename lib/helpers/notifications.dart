import 'package:awesome_notifications/awesome_notifications.dart';

startTimerNotification({required String title, required String body}) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: title,
      body: body,
    ),
  );
}

stopTimerNotification(
    {required String title, required String body, required Function onTap}) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 11, channelKey: 'basic_channel', title: title, body: body),
      actionButtons: [
        NotificationActionButton(
          key: "REPLY",
          label: "Modify",
          autoDismissible: true,
          enabled: true,
          buttonType: ActionButtonType.Default,
        ),
      ]);
  AwesomeNotifications().actionStream.listen((receivedNotification) {
    if (receivedNotification.buttonKeyPressed == "REPLY") {
      onTap(); // Trigger the onTap function when the button is pressed
    }
  });
}
