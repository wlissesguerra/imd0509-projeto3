import 'package:alcanceaulas/model/AuthUser.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../component/drawer.dart';
import '../component/CoursesList.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    //print(CourseController().getAllCourses());
  }

  // void createLeson() {
  //   LesonController().create(
  //     Leson(
  //         id: 1,
  //         course_id: 2,
  //         title: "GIT para iniciantes",
  //         description: "GIT para iniciantes",
  //         video: "Kzcz-EVKBEQ",
  //         anotacoes: []),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    AuthUser auth = context.watch<AuthUser>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      drawer: Drawer(
        child: DrawerComponent(auth.user),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                "Olá,\n${auth.user.name}!",
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.headline1),
              ),
            ),
            CoursesList(),
          ],
        ),
      ),
    );
  }
}
