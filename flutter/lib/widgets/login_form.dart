import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/user_bloc/user_bloc.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _tecUsername = TextEditingController();
  final _tecPassword = TextEditingController();
  bool _isVisible = false;

  @override
  void dispose() {
    _tecUsername.dispose();
    _tecPassword.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<UserBloc>().add(LoginUser(
        account: {
          'username': _tecUsername.text,
          'password': _tecPassword.text
        }
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
      child: Dialog(
        elevation: 10.0,
        backgroundColor: Colors.transparent,
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserError) {
              MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
            }

            if (state is UserLoggedIn) {
              if (state.account.role == 'ADMIN') {
                Navigator.of(context).pushNamedAndRemoveUntil('/roles', (route) => false);
              }
              else {
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
              }
              MyFlushbar(
                message: 'Welcome, ${state.account.username}!',
                flushbarType: FlushbarType.success
              ).show(context);
            }
          },
          builder: (context, state) {
            return _buildDialogContent(state);
          }
        )
      )
    );
  }

  Widget _buildDialogContent(UserState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 320.0),
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white38,
                  Colors.white54,
                  Colors.white38,
                  Colors.white12
                ]
              )
            ),
            child: _buildForm(state)
          ),
          Positioned(
            top: 5.0,
            right: 5.0,
            child: IconButton(
              splashRadius: 30.0,
              onPressed: () {
                if (state is! UserLoading) {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.close)
            ),
          )
        ]
      ),
    );
  }

  Widget _buildForm(UserState state) {
    if (state is UserLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Log In',
            style: TextStyle(fontSize: 32.0, fontFamily: 'Playfair Display', fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20.0),
          _buildUsernameField(),
          const SizedBox(height: 8.0),
          _buildPasswordField(),
          const SizedBox(height: 8.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              elevation: 5.0,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              backgroundColor: Colors.deepPurple.shade400
            ),
            onPressed: _login,
            child: const Text('Log In', style: TextStyle(fontWeight: FontWeight.bold),)
          )
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _tecUsername,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        hintText: 'Username',
        errorStyle: const TextStyle(fontWeight: FontWeight.w500),
        errorMaxLines: 2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Username must be provided!';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _tecPassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.key),
        suffixIcon: IconButton(
          icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() { _isVisible = !_isVisible; });
          },
        ),
        hintText: 'Password',
        errorStyle: const TextStyle(fontWeight: FontWeight.w500),
        errorMaxLines: 2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))
      ),
      obscureText: _isVisible ? false : true,
      validator: (value) {
        if (value!.isEmpty) return 'Password must be provided!';
        return null;
      },
    );
  }
}