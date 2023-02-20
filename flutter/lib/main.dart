import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:si_penggajian/bloc/gajian_bloc/gajian_bloc.dart';
import 'package:si_penggajian/bloc/gajian_detail_bloc/gajian_detail_bloc.dart';
import 'package:si_penggajian/bloc/jabatan_bloc/jabatan_bloc.dart';
import 'package:si_penggajian/bloc/karyawan_bloc/karyawan_bloc.dart';
import 'package:si_penggajian/bloc/user_bloc/user_bloc.dart';
import 'package:si_penggajian/repositories/account_repository.dart';
import 'package:si_penggajian/repositories/attendance_repository.dart';
import 'package:si_penggajian/repositories/gajian_repository.dart';
import 'package:si_penggajian/repositories/jabatan_repository.dart';
import 'package:si_penggajian/repositories/karyawan_repository.dart';
import 'package:si_penggajian/views/auth_page.dart';
import 'package:si_penggajian/views/create_update_attendance.dart';
import 'package:si_penggajian/views/create_update_jabatan.dart';
import 'package:si_penggajian/views/home.dart';
import 'package:si_penggajian/views/preview_gajian_detail.dart';
import 'package:si_penggajian/views/register_page.dart';
import 'package:si_penggajian/views/roles.dart';
import 'package:si_penggajian/views/update_profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AccountRepository()),
        RepositoryProvider(create: (context) => KaryawanRepository()),
        RepositoryProvider(create: (context) => JabatanRepository()),
        RepositoryProvider(create: (context) => AttendanceRepository()),
        RepositoryProvider(create: (context) => GajianRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(accountRepository: context.read<AccountRepository>())
          ),
          BlocProvider(
            create: (context) => KaryawanBloc(karyawanRepository: context.read<KaryawanRepository>())
          ),
          BlocProvider(
            create: (context) => JabatanBloc(jabatanRepository: context.read<JabatanRepository>())
          ),
          BlocProvider(
            create: (context) => AttendanceBloc(attendanceRepository: context.read<AttendanceRepository>())
          ),
          BlocProvider(
            create: (context) => GajianBloc(gajianRepository: context.read<GajianRepository>())
          ),
          BlocProvider(
            create: (context) => GajianDetailBloc(gajianRepository: context.read<GajianRepository>())
          ),
        ],
        child: MaterialApp(
          title: 'Sistem Informasi Penggajian Karyawan',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            final routeName = settings.name;
            final args = settings.arguments as Map<String, dynamic>?;

            if (routeName == '/') {
              return MaterialPageRoute(builder: (context) => const AuthPage());
            }

            if (routeName == '/register') {
              return MaterialPageRoute(builder: (context) => const RegisterPage());
            }

            if (routeName == '/roles') {
              return MaterialPageRoute(
                builder: (context) {
                  return _buildIfUserLoggedIn(const Roles(), adminCheck: true);
                }
              );
            }

            if (routeName == '/home') {
              return MaterialPageRoute(
                builder: (context) {
                  return _buildIfUserLoggedIn(Home(pageIndex: args?['pageIndex'] ?? 0));
                }
              );
            }

            if (routeName == '/admin') {
              return MaterialPageRoute(
                builder: (context) {
                  return _buildIfUserLoggedIn(
                    Home(
                      viewType: 'ADMIN',
                      pageIndex: args?['pageIndex'] ?? 0,
                      profileId: args?['profileId']
                    ),
                    adminCheck: true
                  );
                }
              );
            }

            if (routeName == '/update-profile') {
              return MaterialPageRoute(
                builder: (context) {
                  return _buildIfUserLoggedIn(
                    UpdateProfile(karyawan: args!['karyawan'], viewType: args['viewType'],)
                  );
                }
              );
            }

            if (routeName == '/create-update-jabatan') {
              return MaterialPageRoute(
                builder: (context) {
                  return _buildIfUserLoggedIn(
                    CreateUpdateJabatan(jabatan: args?['jabatan']),
                    adminCheck: true
                  );
                }
              );
            }

            if (routeName == '/create-update-attendance') {
              return MaterialPageRoute(
                builder: (context) {
                  return _buildIfUserLoggedIn(
                    CreateUpdateAttendance(attendance: args?['attendance']),
                    adminCheck: true
                  );
                }
              );
            }

            if (routeName == '/preview-gajian') {
              return MaterialPageRoute(
                builder: (context) {
                  return _buildIfUserLoggedIn(const PreviewGajianDetail(), adminCheck: true);
                }
              );
            }

            return null;
          },
        ),
      )
    );
  }

  Widget _buildIfUserLoggedIn(Widget child, {bool adminCheck = false}) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (adminCheck) {
          return state is UserLoggedIn && state.account.role == 'ADMIN' ? child : const AuthPage();
        }
        return state is UserLoggedIn ? child : const AuthPage();
      },
    );
  }
}