import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/jabatan_bloc/jabatan_bloc.dart';
import 'package:si_penggajian/widgets/background_image.dart';
import 'package:si_penggajian/widgets/login_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      image: 'assets/images/medium-purple-bg.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: 'Sistem Informasi Penggajian Karyawan\n\n\n',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 38.0,
                          fontWeight: FontWeight.w600
                        )
                      ),
                      TextSpan(
                        text: 'Untuk dapat menggunakan aplikasi ini, silahkan Log In terlebih dahulu!\n\n'
                      ),
                      TextSpan(
                        text: 'Jika tidak punya account, silahkan Register Account terlebih dahulu!'
                      )
                    ]
                  )
                ),
                const SizedBox(height: 18.0),
                _buildButton(
                  text: 'Log In',
                  color: Colors.purple.shade400,
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: Colors.transparent,
                      builder: (context) => const LoginForm()
                    );
                  },
                ),
                const SizedBox(height: 5.0),
                _buildButton(
                  text: 'Register Account', 
                  color: Colors.deepPurple.shade400,
                  onPressed: () {
                    context.read<JabatanBloc>().add(const SearchJabatan(query: ''));
                    Navigator.of(context).pushNamed('/register');
                  },
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required void Function() onPressed
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 8.0,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        backgroundColor: color
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)
      )
    );
  }
}