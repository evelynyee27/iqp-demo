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
  bool toggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: 5),
              // search bar
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 40,

                child: SearchBar(
                  hintText: 'Search for schools',
                  hintStyle: WidgetStateProperty.all(TextStyle(fontSize: 12)),
                ),
              ),
              SizedBox(height: 10),
              // search by criteria
              Row(
                children: [
                  // by criteria
                  ElevatedButton(
                    onPressed: () => context.push('/chatboxbycriteria'),

                    child: const Text(
                      'Search by Criteria',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              // comparison chatbox
              Row(
                children: [
                  // comparison
                  ElevatedButton(
                    onPressed: () => context.push('/comparsionchatbox'),
                    child: const Text(
                      'Comparsion Chatbox',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 40),

                  Row(
                    children: [
                      SizedBox(
                        width: 75,
                        child: Text(
                          'Compare two schools',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: toggled
                                ? Colors.black
                                : Color.fromRGBO(113, 128, 150, 1),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // toggle for comparison
                  Switch(
                    // This bool value toggles the switch.
                    activeThumbColor: Colors.white,
                    activeTrackColor: Color.fromRGBO(229, 62, 62, 1),
                    inactiveThumbColor: Color.fromRGBO(113, 128, 150, 1),
                    inactiveTrackColor: Colors.white,
                    value: toggled,

                    onChanged: (bool value) {
                      setState(() {
                        toggled = value;
                      });
                    },
                  ),
                ],
              ),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(6, (index) {
                    return Center(
                      child: Stack(
                        children: [
                          // Image(image: ''),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'School Name',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
