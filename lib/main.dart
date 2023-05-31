import 'package:flutter/material.dart';
import 'package:student/data.dart';

void main() {
  getStudents();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme:
            InputDecorationTheme(border: OutlineInputBorder()),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.

        //color for FAB
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: const Color((0xff16e547))),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Android Expert'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            setState(() {
              //refresh fun  build
            });
          },
          label: Row(
            children: [Icon(Icons.add), Text(("Add Student"))],
          )),
      body: FutureBuilder<List<StudentData>>(
        future: getStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
                padding: EdgeInsets.only(bottom: 84),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _Student(data: snapshot.data![index]);
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
} //HomePage class

//  parse List item to widget
class _Student extends StatelessWidget {
  //for show information
  final StudentData data;

  const _Student({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05)),
          ]),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
            child: Text(
              data.firstName.characters.first,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 24),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${data.firstName} ${data.lastName}'),
                SizedBox(height: 8),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.grey.shade200),
                    child: Text(
                      data.course + ' ' + data.course,
                      style: TextStyle(fontSize: 10),
                    )),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart_rounded, color: Colors.grey.shade400),
              Text(
                data.score.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
} //student class

//form page
class _AddStudentForms extends StatelessWidget {
  //keep data for send to server
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Student"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            try {
              final newStudentData = await saveStudent(
                  firstNameController.text,
                  lastNameController.text,
                  courseController.text,
                  int.parse(scoreController.text));
              Navigator.pop(context, newStudentData);
            } catch (e) {
              debugPrint(e.toString());
            }
          },
          label: Row(
            children: [Icon(Icons.check), Text('Save')],
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(label: Text("First Name")),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(label: Text("Last Name")),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: courseController,
              decoration: InputDecoration(label: Text("Course")),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: scoreController,
              decoration: InputDecoration(label: Text("Score")),
            ),
          ],
        ),
      ),
    );
  }
}
