import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:si_penggajian/bloc/gajian_bloc/gajian_bloc.dart';
import 'package:si_penggajian/bloc/jabatan_bloc/jabatan_bloc.dart';
import 'package:si_penggajian/bloc/karyawan_bloc/karyawan_bloc.dart';
import 'package:si_penggajian/bloc/user_bloc/user_bloc.dart';
import 'package:si_penggajian/views/attendance_page.dart';
import 'package:si_penggajian/views/gajian_page.dart';
import 'package:si_penggajian/views/jabatan_page.dart';
import 'package:si_penggajian/views/karyawan_page.dart';
import 'package:si_penggajian/views/profile_page.dart';
import 'package:si_penggajian/widgets/background_image.dart';

class Home extends StatefulWidget {
  final String viewType;
  final int pageIndex;
  final int? profileId;
  const Home({super.key, this.viewType = 'USER', this.pageIndex = 0, this.profileId});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      image: 'assets/images/light-purple-bg.jpg',
      gradientType: GradientType.light,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoggedIn) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: _buildFloatingActionButton(state.account.role!),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: _buildBottomAppBar(state.account.role!),
              body: _buildSelectedPage(
                context,
                id: state.account.id!,
                role: state.account.role!,
                token: state.account.token!
              )
            );
          }
          return const Scaffold(backgroundColor: Colors.transparent,);
        },
      )
    );
  }

  Widget? _buildFloatingActionButton(String role) {
    return role == 'ADMIN' ? FloatingActionButton(
      elevation: 20.0,
      backgroundColor: Colors.pink.shade200,
      onPressed: () {
        Navigator.of(context).pushNamed('/roles');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.switch_account, color: Colors.purple.shade900),
          Text('Switch', style: TextStyle(fontSize: 10.0, color: Colors.purple.shade900),),
          Text('Role', style: TextStyle(fontSize: 10.0, color: Colors.purple.shade900),)
        ]
      )
    ) : null;
  }

  Widget _buildBottomAppBar(String role) {
    return BottomAppBar(
      shape: role == 'ADMIN' ? const CircularNotchedRectangle() : null,
      elevation: 10.0,
      color: Colors.purple.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildListOfItems(role),
        ),
      ),
    );
  }

  List<Widget> _buildListOfItems(String role) {
    if (widget.viewType == 'USER') {
      return [
        _buildBottomAppBarItem(icon: Icons.list_alt, label: 'Attendance', index: 0),
        _buildBottomAppBarItem(icon: Icons.account_balance_outlined, label: 'Gajian', index: 1),
        if (role == 'ADMIN') const SizedBox(width: 30.0,),
        _buildBottomAppBarItem(icon: Icons.badge_outlined, label: 'Jabatan', index: 2),
        _buildBottomAppBarItem(icon: Icons.person, label: 'Profile', index: 3),
      ];
    }
    else if (widget.viewType == 'ADMIN' && role == 'ADMIN') {
      return [
        _buildBottomAppBarItem(icon: Icons.list_alt, label: 'Attendance', index: 0),
        _buildBottomAppBarItem(icon: Icons.account_balance_outlined, label: 'Gajian', index: 1),
        const SizedBox(width: 30.0,),
        _buildBottomAppBarItem(icon: Icons.badge_outlined, label: 'Jabatan', index: 2),
        _buildBottomAppBarItem(icon: Icons.groups, label: 'Karyawan', index: 3),
      ];
    }
    return [];
  }

  Widget _buildBottomAppBarItem({
    required IconData icon,
    required String label,
    required int index
  }) {
    final isSelected = _selectedIndex == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: const EdgeInsets.all(0.0),
          splashRadius: 25.0,
          constraints: const BoxConstraints(maxHeight: 27.0),
          onPressed: () { setState(() { _selectedIndex = index; }); },
          icon: Icon(icon, color: isSelected ? Colors.deepPurple.shade900 : Colors.black54,)
        ),
        Text(label, style: TextStyle(
          color: isSelected ? Colors.deepPurple.shade900 : Colors.black54,
          fontSize: isSelected ? 14.0 : 12.0,
          fontWeight: FontWeight.bold
        ))
      ],
    );
  }

  Widget _buildSelectedPage(BuildContext context, {required int id, required String role, required String token}) {
    if (widget.viewType == 'USER') {
      if (_selectedIndex == 0) {
        context.read<AttendanceBloc>().add(GetAttendanceList(token: token));
        return AttendancePage(viewType: widget.viewType, token: token);
      }
      if (_selectedIndex == 1) {
        context.read<GajianBloc>().add(GetGajianList(token: token));
        return GajianPage(viewType: widget.viewType, token: token);
      }
      if (_selectedIndex == 2) {
        context.read<JabatanBloc>().add(const SearchJabatan(query: ''));
        return JabatanPage(viewType: widget.viewType, token: token);
      }
      if (_selectedIndex == 3) {
        context.read<KaryawanBloc>().add(GetProfileKaryawan(id: id, token: token));
        return ProfilePage(viewType: widget.viewType, token: token,);
      }
    }

    else if (widget.viewType == 'ADMIN' && role == 'ADMIN') {
      if (_selectedIndex == 0) {
        context.read<AttendanceBloc>().add(SearchAttendance(query: '', token: token));
        return AttendancePage(viewType: widget.viewType, token: token);
      }
      if (_selectedIndex == 1) {
        context.read<GajianBloc>().add(SearchGajian(query: '', token: token));
        return GajianPage(viewType: widget.viewType, token: token);
      }
      if (_selectedIndex == 2) {
        context.read<JabatanBloc>().add(const SearchJabatan(query: ''));
        return JabatanPage(viewType: widget.viewType, token: token);
      }
      if (_selectedIndex == 3) {
        context.read<KaryawanBloc>().add(SearchKaryawan(query: '', token: token));
        return KaryawanPage(token: token);
      }
      if (_selectedIndex == 4) {
        context.read<KaryawanBloc>().add(GetProfileKaryawan(id: widget.profileId!, token: token));
        context.read<JabatanBloc>().add(const SearchJabatan(query: ''));
        return ProfilePage(viewType: widget.viewType, token: token,);
      }
    }

    return Container();
  }
}