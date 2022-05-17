import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _appBox = 'appBox';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive();
  runApp(const MyApp());
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Hive.openBox(_appBox);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Hive POC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? todoText;
  final box = Hive.box(_appBox);

  List<String> get todoList => box.get('todoList', defaultValue: <String>[]);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: controller,
                    onChanged: (text) => todoText = text,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  controller.clear();
                  if (todoText != null) {
                    todoList.add(todoText!);
                    await box.put('todoList', todoList);
                    setState(() {
                      return;
                    });
                  }
                },
                child: const Text('Add'),
              )
            ],
          ),
          Expanded(
              child: ListView.separated(
            physics: const ClampingScrollPhysics(),
            itemCount: todoList.length,
            itemBuilder: (_, index) => ListTile(
              title: Text(todoList[index]),
              onTap: () => debugPrint('tap'),
            ),
            separatorBuilder: (_, __) => const Divider(),
          ))
        ],
      ),
    );
  }
}
