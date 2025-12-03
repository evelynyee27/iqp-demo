import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  final stopwatch = Stopwatch()..start();
  await dotenv.load(fileName: ".env");
  print("dotenv loaded in: ${stopwatch.elapsedMicroseconds} microseconds");

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1B4D3E)),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // you can remove this if you don't use it

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () => context.push('/chatboxbycriteria'),
              child: const Text('Search by Criteria'),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => context.push('/comparsionchatbox'),
              child: const Text('Comparsion Chatbox'),
            ),
          ],
        ),
      ),
    );
  }
}
