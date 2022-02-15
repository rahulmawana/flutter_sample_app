import 'package:flutter/material.dart';
import 'package:flutter_sample_app/utils/ForgroundService.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initForegroundTask();
  checkAndForgroundServiceListen(restartIfAlreadyRunning: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App forground service test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WithForegroundTask(
        child: HomeWidget(
          title: 'Testing App',
        ),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  final String title;
  HomeWidget({Key? key, required this.title});
  @override
  _HomeWidget createState() => _HomeWidget();
}

class _HomeWidget extends State<HomeWidget> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(child: const Text('This is Testing App')),
    );
  }
}
