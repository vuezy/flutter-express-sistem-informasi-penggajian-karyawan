import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class RegisterAccount extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const RegisterAccount({super.key, required this.formKey});

  @override
  State<RegisterAccount> createState() => RegisterAccountState();
}

class RegisterAccountState extends State<RegisterAccount> {
  final tecUsername = TextEditingController();
  final tecEmail = TextEditingController();
  final tecPassword = TextEditingController();
  bool _isVisible = false;

  @override
  void dispose() {
    tecUsername.dispose();
    tecEmail.dispose();
    tecPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          const SizedBox(height: 10.0,),
          _buildTextField(
            label: 'Username',
            controller: tecUsername,
            prefixIcon: Icons.person,
            hintText: 'Username'
          ),
          const SizedBox(height: 10.0,),
          _buildTextField(
            label: 'Email',
            controller: tecEmail,
            prefixIcon: Icons.mail,
            hintText: 'Email'
          ),
          const SizedBox(height: 10.0,),
          _buildTextField(
            label: 'Password',
            controller: tecPassword,
            prefixIcon: Icons.key,
            hintText: 'Password'
          )
        ],
      )
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData prefixIcon,
    required String hintText,
  }) {
    return TextFormField(
      style: const TextStyle(color: Colors.white, fontSize: 14.0),
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        prefixIcon: Icon(prefixIcon, color: Colors.deepPurple.shade200),
        suffixIcon: label == 'Password' ? IconButton(
          icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.deepPurple.shade200),
          onPressed: () {
            setState(() { _isVisible = !_isVisible; });
          },
        ) : null,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 14.0),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 14.0),
        errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
        errorMaxLines: 2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.deepPurple.shade200)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.deepPurple.shade800)
        ),
      ),
      obscureText: label == 'Password' && !_isVisible ? true : false,
      validator: (value) {
        if (value!.isEmpty) return '$label must be provided!';
        if (label == 'Username') {
          if (value.length >= 20) return 'Username must have less than 20 characters!';
          if (value.contains(RegExp(r'\W+'))) return 'Username must contain only alphanumeric characters!';
        }
        if (label == 'Email') {
          if (!EmailValidator.validate(value)) return 'Please provide a valid email!';
        }
        if (label == 'Password') {
          if (value.length < 8 || value.length > 32) return 'Password must contain 8-32 characters!';
        }
        return null;
      },
    );
  }
}