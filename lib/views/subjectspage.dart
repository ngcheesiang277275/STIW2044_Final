import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/constants.dart';
import 'package:mytutor/models/subject.dart';
import 'package:mytutor/models/user.dart';
import 'package:mytutor/views/cartpage.dart';

class SubjectsPage extends StatefulWidget {
  final User user;
  const SubjectsPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late double screenHeight, screenWidth, rWidth;
  String titlecenter = "";
  List<Subject> subjectList = <Subject>[];
  var numofpage, curpage = 1;
  var color;
  int carttotal = 0;
  TextEditingController searchController = TextEditingController();
  String searchTerms = "";

  @override
  void initState() {
    super.initState();
    _loadSubjects(1, searchTerms);
    _loadMyCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 700) {
      rWidth = screenWidth * 0.75;
    } else {
      rWidth = screenWidth;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Subjects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => CartPage(
                            user: widget.user,
                          )));
              _loadSubjects(1, "");
              _loadMyCart();
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(widget.user.cart.toString(),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: subjectList.isEmpty
          ? const Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            )
          : Column(children: [
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 2.0),
                      children: List.generate(subjectList.length, (index) {
                        return InkWell(
                          splashColor: Colors.red,
                          onTap: () => {_loadSubjectDetails(index)},
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 4,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/assets/courses/" +
                                      subjectList[index].subjectId.toString() +
                                      ".jpg",
                                  fit: BoxFit.fitWidth,
                                  width: rWidth,
                                  height: rWidth,
                                ),
                              ),
                              Flexible(
                                  flex: 6,
                                  child: Column(
                                    children: [
                                      Container(
                                        constraints:
                                            const BoxConstraints.expand(
                                                height: 60),
                                        child: Text(
                                          subjectList[index]
                                              .subjectName
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "RM " +
                                            double.parse(subjectList[index]
                                                    .subjectPrice
                                                    .toString())
                                                .toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(subjectList[index]
                                              .subjectSessions
                                              .toString() +
                                          " sessions"),
                                      Text(double.parse(subjectList[index]
                                                  .subjectRating
                                                  .toString())
                                              .toStringAsFixed(1) +
                                          " / 5.0"),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text("Tutorial by "),
                                          CachedNetworkImage(
                                            imageUrl: CONSTANTS.server +
                                                "/mytutor/assets/tutors/" +
                                                subjectList[index]
                                                    .tutorId
                                                    .toString() +
                                                ".jpg",
                                            fit: BoxFit.cover,
                                            width: 30,
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            _addtoCartDialog(index);
                                          },
                                          child: const Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          )),
                                    ],
                                  ))
                            ],
                          )),
                        );
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () =>
                              {_loadSubjects(index + 1, searchTerms)},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  _loadSubjectDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Subject Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/mytutor/assets/courses/" +
                      subjectList[index].subjectId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: rWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  subjectList[index].subjectName.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    "Price: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("RM" +
                      double.parse(subjectList[index].subjectPrice.toString())
                          .toStringAsFixed(2) +
                      "\n"),
                  const Text(
                    "Sessions: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(subjectList[index].subjectSessions.toString() +
                      " sessions \n"),
                  const Text(
                    "Ratings: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(subjectList[index].subjectRating.toString() +
                      " / 5.0 \n"),
                  const Text(
                    "Subject Description: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(subjectList[index].subjectDescription.toString() + "\n"),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _loadSubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/loadSubjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 || jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subject'] != null) {
          subjectList = <Subject>[];
          extractdata['subject'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
        } else {
          titlecenter = "No Subject Available";
          subjectList.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No Subject Available";
        subjectList.clear();
        setState(() {});
      }
    });
  }

  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search Courses ",
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Enter search terms',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      searchTerms = searchController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(1, searchTerms);
                    },
                    child: const Text(
                      'Search',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(50)),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  void _loadMyCart() {
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/loadcartquantity.php"),
        body: {
          "email": widget.user.email.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
      }
    });
  }

  void _addtoCartDialog(int index) {
    showDialog(
        builder: (context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: const Text(
                  'Do you want to add this subject to cart?',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addtoCart(index);
                    },
                  ),
                  TextButton(
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }

  void _addtoCart(int index) {
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/inserttocart.php"),
        body: {
          "email": widget.user.email.toString(),
          "subject_id": subjectList[index].subjectId.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Added to cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
