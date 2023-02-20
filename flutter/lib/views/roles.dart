import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/user_bloc/user_bloc.dart';
import 'package:si_penggajian/widgets/background_image.dart';
import 'package:si_penggajian/widgets/confirmation_dialog.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';

class Roles extends StatelessWidget {
  const Roles({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      image: 'assets/images/medium-purple-bg.jpeg',
      gradientType: GradientType.dark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Log Out',
                          content: 'Do you really want to log out?',
                          onConfirmed: () {
                            context.read<UserBloc>().add(LogoutUser());
                            const MyFlushbar(
                              message: 'Successfully logged out!',
                              flushbarType: FlushbarType.success,
                            ).show(context);
                          },
                        )
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.logout, color: Colors.white70),
                        SizedBox(width: 10.0,),
                        Text('Log Out', style: TextStyle(fontSize: 16.0, color: Colors.white70))
                      ],
                    )
                  ),
                ),
              ),
              ListView(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const Text(
                    'Select Role:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 40.0,
                      shadows: [
                        Shadow(color: Colors.black54, offset: Offset(5.0, 5.0), blurRadius: 8.0)
                      ]
                    ),
                  ),
                  const SizedBox(height: 30.0,),
                  _buildRoleButton(
                    mainColor: Colors.purple.shade400.withOpacity(0.5),
                    secondaryColor: Colors.purple.shade700.withOpacity(0.6),
                    text: 'USER',
                    textColor: Colors.purple.shade200,
                    icon: Icons.person,
                    iconColor: Colors.deepPurple.shade100.withOpacity(0.8),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                    },
                  ),
                  const SizedBox(height: 25.0,),
                  _buildRoleButton(
                    mainColor: Colors.deepPurple.shade400.withOpacity(0.5),
                    secondaryColor: Colors.deepPurple.shade700.withOpacity(0.6),
                    text: 'ADMIN',
                    textColor: Colors.deepPurple.shade200,
                    icon: Icons.admin_panel_settings,
                    iconColor: Colors.purple.shade100.withOpacity(0.8),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/admin', (route) => false);
                    },
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required Color mainColor,
    required Color secondaryColor,
    required String text,
    required Color textColor,
    required IconData icon,
    required Color iconColor,
    required void Function() onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0.0,
              top: 0.0,
              child: Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: mainColor,
                ),
              ),
            ),
            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: mainColor,
                ),
              ),
            ),
            Container(
              width: 170.0,
              height: 170.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: secondaryColor,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10.0),
                fixedSize: const Size(150.0, 150.0),
                elevation: 20.0,
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))
              ),
              onPressed: onPressed,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 65.0,
                    color: iconColor,
                    shadows: const [
                      Shadow(color: Colors.black54, offset: Offset(5.0, 5.0), blurRadius: 8.0)
                    ]
                  ),
                  const SizedBox(height: 10.0,),
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25.0,
                      color: textColor,
                      shadows: const [
                        Shadow(color: Colors.black54, offset: Offset(5.0, 5.0), blurRadius: 8.0)
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ],
    );
  }
}