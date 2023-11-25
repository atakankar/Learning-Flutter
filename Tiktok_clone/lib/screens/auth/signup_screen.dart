import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../widgets/widgets.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List? image, defaultIm;

  selectImage() async {
    Uint8List? im = await authController.pickImage();
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      if (im != null) {
        image = im;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Tiktok Clone',
            style: TextStyle(
              fontSize: 35,
              color: buttonColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'Register',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Stack(
            children: [
              image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(image!),
                      backgroundColor: Colors.red,
                    )
                  : CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                          'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                      backgroundColor: Colors.black,
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: () => selectImage(),
                  icon: const Icon(
                    Icons.add_a_photo,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextInputField(
              controller: _usernameController,
              labelText: 'Username',
              icon: Icons.person,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextInputField(
              controller: _emailController,
              labelText: 'Email',
              icon: Icons.email,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextInputField(
              controller: _passwordController,
              labelText: 'Password',
              icon: Icons.lock,
              isObscure: true,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 50,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: InkWell(
              onTap: () => authController.registerUser(
                _usernameController.text,
                _emailController.text,
                _passwordController.text,
                authController.profilePhoto,
              ),
              child: const Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20, color: buttonColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
