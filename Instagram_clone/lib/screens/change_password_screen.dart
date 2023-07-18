import 'package:flutter/material.dart';
import 'package:instagram/responsive/reponsive_layout_screen.dart';
import 'package:instagram/services/auth_service.dart';
import 'package:instagram/theme/theme.dart';
import 'package:instagram/widget_assets/widget_assets.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;
  const ChangePasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPwController = TextEditingController();
  final TextEditingController _newPwController = TextEditingController();
  final TextEditingController _newRpwController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentPwController.dispose();
    _newPwController.dispose();
    _newRpwController.dispose();
    super.dispose();
  }

  void changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String res = await AuthService().changePassword(
          email: widget.email,
          currentPw: _currentPwController.text,
          newPw: _newPwController.text);
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        // navigate to the home screen
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(),
            ),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    }
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              right: 18.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Pallete.searchBarColor,
                  radius: 100,
                  child: Icon(
                    Icons.lock_outline,
                    color: Pallete.whiteColor,
                    size: 150,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFieldInput(
                  hintText: 'Enter your current password',
                  textInputType: TextInputType.text,
                  textEditingController: _currentPwController,
                  isPass: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Please enter at least 6 character';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your new password',
                  textInputType: TextInputType.text,
                  textEditingController: _newPwController,
                  isPass: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Please enter at least 6 character';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Reenter new your password',
                  textInputType: TextInputType.text,
                  textEditingController: _newRpwController,
                  isPass: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value != _newPwController.text) {
                      return 'Your password does not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: changePassword,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: Pallete.blueColor,
                    ),
                    child: !_isLoading
                        ? const Text(
                            'Change',
                          )
                        : const CircularProgressIndicator(
                            color: Pallete.primaryColor,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
