// ignore_for_file: avoid_print, , avoid_unnecessary_containers, prefer_const_constructors, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/emp_info.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ******************************
  Future getEmployeeData() async {
    var response =
        await http.get(Uri.https('retoolapi.dev', 'GFHqAV/getemployees'));
    var jsonData = jsonDecode(response.body);

    List<Employee> dataEmp = [];

    for (var i in jsonData) {
      Employee employee = Employee(i["id"], i["name"], i["company"],
          i["designation"], i["company_logo"]);

      dataEmp.add(employee);
    }
    print(dataEmp.length);
    return dataEmp;
  }

  // ******************************
  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              // title: Text('Exit App'),
              content: const Text('Do you want to exit?'),
              actions: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Employee List",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Card(
            child: FutureBuilder(
              future: getEmployeeData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text('Loading...'),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return Container(
                          // **********

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Card(
                              elevation: 20,
                              shadowColor: Colors.black,
                              color: Colors.black,
                              child: SizedBox(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 60,
                                                child: CircleAvatar(
                                                  radius: 55,
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data[i]
                                                          .company_logo),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                snapshot.data[i].company,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Employee ID: ${snapshot.data[i].id}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "Name: ${snapshot.data[i].name}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "Designation: ${snapshot.data[i].designation}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EmpInfo(
                                                employee: snapshot.data[i]),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'view more...',
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 18),
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}

class Employee {
  final int id;
  final String? name, company, designation, company_logo;

  Employee(
      this.id, this.name, this.company, this.designation, this.company_logo);
}
