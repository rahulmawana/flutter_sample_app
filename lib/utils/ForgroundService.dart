import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'dart:isolate';
import 'dart:async';

void startCallback() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    try {
      // You can use the getData function to get the data you saved.
      print('Value is going to be set');
      await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
      print('Value set successfully');
    } catch (ex, stack) {
      print('Error occured on forground service starting ${ex.toString()}');
      print(stack);
      print(stack.toString());
    }
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    //sendPort?.send(timestamp);
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // You can use the clearAllData function to clear all the stored data.
    // await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) async {
    // Called when the notification button on the Android platform is pressed.
    if (id == 'closeService') {
      // StepTracking.stopCountingStep();
      FlutterForegroundTask.stopService();
    }
  }
}

Future<void> initForegroundTask() async {
  await FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'my_app_channel_id',
      channelName: 'My App Foreground Notification',
      channelDescription: 'My App Foreground Service',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
      iconData: NotificationIconData(
        resType: ResourceType.mipmap,
        resPrefix: ResourcePrefix.ic,
        name: 'launcher',
      ),
      buttons: [
        const NotificationButton(id: 'closeService', text: 'Close'),
        // const NotificationButton(id: 'testButton', text: 'Test'),
      ],
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 5000,
      autoRunOnBoot: true,
      allowWifiLock: false,
    ),
    printDevLog: true,
  );
}

Future<ReceivePort?> startForGroundService() {
  return FlutterForegroundTask.startService(
      notificationText: 'Tap to return to the app',
      notificationTitle: 'Keep it running',
      callback: startCallback);
}

Future<ReceivePort?> checkIsForgroundServiceRunning(
    {restartIfAlreadyRunning: false}) async {
  if (restartIfAlreadyRunning && await FlutterForegroundTask.isRunningService) {
    print('Service is already running, so restarting it again...');
    return await FlutterForegroundTask.restartService();
  }
  if (!await FlutterForegroundTask.isRunningService) {
    return startForGroundService();
  }
}

checkAndForgroundServiceListen({bool restartIfAlreadyRunning: false}) async {
  ReceivePort? receivePort = await checkIsForgroundServiceRunning(
      restartIfAlreadyRunning: restartIfAlreadyRunning);
  if (receivePort != null) {
    receivePort.listen((stepCounts) {});
  }
}
