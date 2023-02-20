import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/karyawan_bloc/karyawan_bloc.dart';
import 'package:si_penggajian/bloc/user_bloc/user_bloc.dart';
import 'package:si_penggajian/widgets/confirmation_dialog.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';

class ProfilePage extends StatelessWidget {
  final String viewType;
  final String token;
  const ProfilePage({super.key, required this.viewType, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KaryawanBloc, KaryawanState>(
      listener: (context, state) {
        if (state is KaryawanError) {
          MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
        }
      },
      builder: (context, state) {
        if (state is ProfileKaryawanLoaded) {
          return Scaffold(
            appBar: _buildHeader(
              context: context,
              id: state.karyawan.id!,
              nama: state.karyawan.nama!,
              username: state.karyawan.username!,
              email: state.karyawan.email!
            ),
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                color: Colors.deepPurple.shade200.withOpacity(0.6)
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
                children: [
                  GridView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 90.0/40.0
                    ),
                    children: [
                      _buildProfileData(label: 'Gender', value: state.karyawan.gender!,),
                      _buildProfileData(label: 'Usia', value: state.karyawan.usia.toString(),),
                      _buildProfileData(label: 'Status', value: '${state.karyawan.menikah} Menikah',),
                      _buildProfileData(label: 'Jumlah Anak', value: state.karyawan.jlhAnak.toString(),),
                      _buildProfileData(label: 'Jabatan', value: state.karyawan.jabatan!,),
                      _buildProfileData(label: 'Alamat', value: state.karyawan.alamat!,),
                      _buildProfileData(label: 'Nomor Telepon', value: state.karyawan.noTelp!, labelSize: 16.0),
                      _buildProfileData(label: 'Nomor Rekening', value: state.karyawan.noRek!, labelSize: 16.0),
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/update-profile',
                        arguments: {
                          'viewType': viewType,
                          'karyawan': state.karyawan,
                        }
                      );
                    },
                    child: const Text('Update Profile')
                  )
                ],
              ),
            )
          );
        }
        return SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 5.0,),
                Text('Loading Profile...', style: TextStyle(color: Colors.deepPurple.shade900),)
              ],
            ),
          )
        );
      },
    );
  }

  PreferredSizeWidget _buildHeader({
    required BuildContext context,
    required int id,
    required String nama,
    required String username,
    required String email
  }) {
    return AppBar(
      toolbarHeight: 10.0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 15.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 32.0,
                      color: Colors.black.withOpacity(0.75)
                    )
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person_rounded, color: Colors.black54),
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.black54
                        )
                      )
                    ]
                  ),
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.black54),
                      Text(
                        email,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.black54
                        )
                      )
                    ]
                  )
                ]
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10.0,
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0)
                ),
                onPressed: () {
                  if (viewType == 'ADMIN') {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: 'Delete Karyawan',
                        content: 'Apakah Anda ingin delete data karyawan ini?',
                        onConfirmed: () {
                          context.read<KaryawanBloc>().add(DeleteKaryawan(id: id, token: token));
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/admin',
                            arguments: { 'pageIndex': 3 },
                            (route) => false
                          );
                        },
                      )
                    );
                  }
                  else {
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
                  }
                },
                child: Row(
                  children: [
                    Icon(viewType == 'ADMIN' ? Icons.delete : Icons.logout, size: 12.0),
                    const SizedBox(width: 5.0,),
                    
                    if (viewType == 'ADMIN')
                    const Text('Delete Karyawan', style: TextStyle(fontSize: 11.0))
                    else
                    const Text('Log Out', style: TextStyle(fontSize: 12.0))
                  ],
                )
              )
            ],
          ),
        ),
      ),
      elevation: 10.0,
      backgroundColor: Colors.purple.shade200.withOpacity(0.7),
    );
  }

  Widget _buildProfileData({required String label, required String value, double labelSize = 18.0}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurpleAccent.shade100.withOpacity(0.9),
            Colors.deepPurple.shade200.withOpacity(0.6),
            Colors.white24,
          ]
        ),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(-5.0, 5.0)
          ),
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(5.0, -5.0)
          ),
        ]
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
            children: [
              TextSpan(
                text: '$label:\n',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Playfair Display',
                  fontSize: labelSize
                )
              ),
              TextSpan(text: value)
            ]
          )
        ),
      )
    );
  }
}