// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'home_page.dart';

class EmpInfo extends StatelessWidget {
  const EmpInfo({super.key, required this.employee});
  final Employee employee;
  // ******************************
  Future moreEmployeeData(int x) async {
    print(x);
    var response = await http
        .get(Uri.https('retoolapi.dev', 'H2F0Ui/getemployedetail/$x'));
    var jsonData = jsonDecode(response.body);

    List<EmployeeDetails> data = [];

    EmployeeDetails employeeinfo = EmployeeDetails(
        jsonData["id"],
        jsonData["name"],
        jsonData["rating"],
        jsonData["company"],
        jsonData["interests"],
        jsonData["view_more"],
        jsonData["designation"],
        jsonData["company_logo"],
        jsonData["job_descripton"]);

    data.add(employeeinfo);

    print(data);
    return data;
  }

  // ******************************
  @override
  Widget build(BuildContext context) {
    // screensize-------------------------
    // Full screen width and height
    double height = MediaQuery.of(context).size.height;

    // Height (without SafeArea)
    var padding1 = MediaQuery.of(context).viewPadding;
    // double height1 = height - padding.top - padding.bottom;

    // Height (without status bar)
    double height2 = (height - padding1.top) / 10;

    // Height (without status and toolbar)
    // double height3 = height - padding.top - kToolbarHeight;
    // screensize-------------------------

    // var todo = Todo(todo.id);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: moreEmployeeData(employee.id),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text('Loading...'),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, i) {
                      return Container(
                        decoration: BoxDecoration(color: Colors.white),
                        // **********
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height2 * 9,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 10,
                                  shadowColor: Colors.black,
                                  color: Colors.black,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(5, height2, 5, 1),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 90,
                                              child: CircleAvatar(
                                                radius: 85,
                                                backgroundImage: NetworkImage(
                                                    snapshot
                                                        .data[i].company_logo),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${snapshot.data[i].company}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 60,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Employee ID: ${snapshot.data[i].id.toString()}",
                                                style: GoogleFonts.oxygen(
                                                    fontSize: 24,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "Employee Name: ${snapshot.data[i].name}",
                                                style: GoogleFonts.oxygen(
                                                    fontSize: 24,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "Ratings: ${snapshot.data[i].rating}",
                                                style: GoogleFonts.oxygen(
                                                    fontSize: 24,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "Description: ${snapshot.data[i].job_descripton}",
                                                style: GoogleFonts.oxygen(
                                                    fontSize: 24,
                                                    color: Colors.white),
                                                textAlign: TextAlign.justify,
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "View more at ${snapshot.data[i].view_more}",
                                                style: GoogleFonts.oxygen(
                                                    fontSize: 18,
                                                    color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        minimumSize: Size.fromHeight(50)),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text("Go Back")),
                              )
                            ],
                          ),
                        ),
                        // **********
                      );
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}

class EmployeeDetails {
  final int? id;
  final String? name,
      rating,
      company,
      interests,
      view_more,
      designation,
      company_logo,
      job_descripton;

  EmployeeDetails(this.id, this.name, this.rating, this.company, this.interests,
      this.view_more, this.designation, this.company_logo, this.job_descripton);
}
