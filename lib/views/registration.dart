import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytutor/constants.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

final _formKey = GlobalKey<FormState>();

class _RegistrationState extends State<Registration> {
  late double screenHeight, screenWidth, rWidth;
  String pathAsset = 'assets/images/addImage.png';
  var _image;
  bool _pwVisibility = true;
  bool _pwReenterVisibility = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordReenterController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();

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
        title: const Text("Registration"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Fill up the following information and registration will be done!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: GestureDetector(
                          onTap: () => {_uploadSelection()},
                          child: SizedBox(
                              height: screenHeight / 5.0,
                              width: screenHeight / 5.0,
                              child: _image == null
                                  ? Image.asset(pathAsset)
                                  : Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ))),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        bool emailValidator = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);

                        if (!emailValidator) {
                          return "The email entered is invalid.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _pwVisibility,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _pwVisibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _pwVisibility = !_pwVisibility;
                              });
                            },
                          ),
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return "Password should be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordReenterController,
                      obscureText: _pwReenterVisibility,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _pwReenterVisibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _pwReenterVisibility = !_pwReenterVisibility;
                              });
                            },
                          ),
                          labelText: "Re-enter Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your password';
                        }
                        if (value != _passwordController.text) {
                          return "Password does not match.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        } else if (value.length < 2) {
                          return 'The minimum length of name is 2 letter';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone Number';
                        } else if (value.length > 15) {
                          return "The maximum digit of phone number is 15.";
                        } else if (value.length < 10) {
                          return "The minimum digit of phone number is 10.";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _homeAddressController,
                      decoration: InputDecoration(
                          labelText: "Home Address",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your home address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Row(

                    // );
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _registerUser();
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            const Size.fromHeight(50)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  _uploadSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Choose picture from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _gallery(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () => {Navigator.of(context).pop(), _camera()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  _gallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  _camera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _registerUser() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill up all the registration information.",
          toastLength: Toast.LENGTH_SHORT);
      return;
    } else if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please upload an image", toastLength: Toast.LENGTH_SHORT);
      return;
    } else {
      _registerUser;
      Fluttertoast.showToast(
          msg: "All information are filled up completely!.",
          toastLength: Toast.LENGTH_SHORT);
      String _email = _emailController.text;
      String _name = _nameController.text;
      String _password = _passwordController.text;
      String _phoneNumber = _phoneNumberController.text;
      String _homeAddress = _homeAddressController.text;
      String base64Image = base64Encode(_image!.readAsBytesSync());
      http.post(
          Uri.parse(CONSTANTS.server + "/mytutor/php/userRegistration.php"),
          body: {
            "name": _name,
            "email": _email,
            "password": _password,
            "phoneNumber": _phoneNumber,
            "homeAddress": _homeAddress,
            "image": base64Image,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 || data['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Registered Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: data['Failed to Register'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      });
    }
  }
}
