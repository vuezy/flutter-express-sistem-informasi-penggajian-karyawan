import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:si_penggajian/bloc/karyawan_bloc/karyawan_bloc.dart';
import 'package:si_penggajian/models/attendance_model.dart';
import 'package:si_penggajian/utils.dart';
import 'package:si_penggajian/widgets/confirmation_dialog.dart';
import 'package:si_penggajian/widgets/custom_app_bar.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';
import 'package:si_penggajian/widgets/option_selector.dart';
import 'package:si_penggajian/widgets/rich_text_for_card.dart';
import 'package:si_penggajian/widgets/search_bar.dart';

class AttendancePage extends StatefulWidget {
  final String viewType;
  final String token;
  const AttendancePage({super.key, required this.viewType, required this.token});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _tecSearch = TextEditingController();
  String _selectedOrderBy = 'Latest';
  final List<String> _orderByItems = ['Latest', 'Oldest'];

  @override
  void dispose() {
    _tecSearch.dispose();
    super.dispose();
  }

  List<Attendance> _sort(List<Attendance> attendance) {
    attendance.sort((a, b) {
      final comp1 = a.tglMulai!.compareTo(b.tglMulai!);
      if (comp1 == 0) {
        final comp2 = a.tglBerakhir!.compareTo(b.tglBerakhir!);
        if (comp2 == 0) {
          final comp3 = Utils.compare(a.filledAt!, b.filledAt!);
          if (comp3 == 0) {
            final comp4 = a.id!.compareTo(b.id!);
            if (_selectedOrderBy == 'Latest') return -1 * comp4;
            return comp4;
          }

          if (_selectedOrderBy == 'Latest') return -1 * comp3;
          return comp3;
        }

        if (_selectedOrderBy == 'Latest') return -1 * comp2;
        return comp2;
      }
      
      if (_selectedOrderBy == 'Latest') return -1 * comp1;
      return comp1;
    });

    return attendance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        toolbarHeight: widget.viewType == 'ADMIN' ? 100.0 : 25.0,
        searchBar: widget.viewType == 'ADMIN' ? SearchBar(
          controller: _tecSearch,
          hintText: 'Search Nama Karyawan',
          onSubmitted: (query) {
            context.read<AttendanceBloc>().add(SearchAttendance(query: query ?? '', token: widget.token));
          }
        ) : null,
        content: [
          OptionSelector(
            dropdownDirection: widget.viewType == 'ADMIN' ? DropdownDirection.vertical : DropdownDirection.horizontal,
            label: 'Order By: ',
            labelSize: widget.viewType == 'ADMIN' ? 15.0 : 18.0,
            dropdownWidth: widget.viewType == 'ADMIN' ? null : 150.0,
            currentValue: _selectedOrderBy,
            items:  _orderByItems,
            onChanged: (value) { setState(() { _selectedOrderBy = value!; }); },
          ),

          if (widget.viewType == 'ADMIN')
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              backgroundColor: Colors.deepPurple.withOpacity(0.7)
            ),
            onPressed: () {
              context.read<KaryawanBloc>().add(SearchKaryawan(query: '', token: widget.token));
              Navigator.of(context).pushNamed('/create-update-attendance');
            },
            child: Row(
              children: const [
                Icon(Icons.add),
                SizedBox(width: 5.0,),
                Text('Create Attendance', style: TextStyle(color: Colors.white)),
              ],
            )
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceError) {
            MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
          }

          if (state is AttendanceFilledOrCreated) {
            MyFlushbar(message: state.message, flushbarType: FlushbarType.success).show(context);
            context.read<AttendanceBloc>().add(GetAttendanceList(token: widget.token));
          }
          
          if (state is AttendanceDeleted) {
            const MyFlushbar(
              message: 'Attendance deleted successfully!',
              flushbarType: FlushbarType.success
            ).show(context);
            context.read<AttendanceBloc>().add(SearchAttendance(query: _tecSearch.text, token: widget.token));
          }
        },
        builder: (context, state) {
          if (state is AttendanceLoaded) {
            final attendance = _sort(state.attendance);

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 8.0),
              itemCount: attendance.length,
              itemBuilder: (context, index) {
                return _buildAttendanceCard(attendance: attendance[index]);
              },
            );
          }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 5.0,),
                Text('Loading Attendance...', style: TextStyle(color: Colors.deepPurple.shade900),)
              ],
            ),
          );
        },
      )
    );
  }

  Widget _buildAttendanceCard({required Attendance attendance}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 10.0,
      color: Colors.purple.shade100.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Attendance #${attendance.id}',
              style: const TextStyle(
                fontSize: 22.0,
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w600,
                color: Colors.black87
              ),
            ),
            Divider(color: Colors.blueGrey.shade900),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueGrey.shade900,
                  fontWeight: FontWeight.w500
                ),
                children: [
                  const TextSpan(
                    text: 'Jangka Waktu:\n',
                    style: TextStyle(fontSize: 19.0),
                  ),
                  const TextSpan(text: 'From '),
                  TextSpan(
                    text: attendance.tglMulai,
                    style: TextStyle(color: Colors.deepPurple.shade900, fontWeight: FontWeight.w700)
                  ),
                  const TextSpan(text: ' To '),
                  TextSpan(
                    text: attendance.tglBerakhir,
                    style: TextStyle(color: Colors.deepPurple.shade900, fontWeight: FontWeight.w700)
                  )
                ]
              )
            ),
            const SizedBox(height: 10.0,),

            if (widget.viewType == 'ADMIN' && attendance.nama != null)
            RichTextForCard(
              label: 'Karyawan: ',
              labelSize: 19.0,
              value: attendance.nama!,
              valueSize: 18.0,
              valueColor: Colors.purple.shade700
            ),
            if (widget.viewType == 'ADMIN')
            const SizedBox(height: 10.0,),

            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueGrey.shade900,
                  fontWeight: FontWeight.w500
                ),
                children: [
                  const TextSpan(
                    text: 'Kehadiran: ',
                    style: TextStyle(fontSize: 19.0),
                  ),
                  TextSpan(
                    text: attendance.hadir.toString(),
                    style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w700)
                  ),
                  const TextSpan(text: ' Dari '),
                  TextSpan(
                    text: attendance.jlhHariKerja.toString(),
                    style: TextStyle(color: Colors.deepPurple.shade900, fontWeight: FontWeight.w700)
                  ),
                  const TextSpan(text: ' Hari Kerja'),
                ]
              )
            ),
            const SizedBox(height: 10.0,),
            Divider(color: Colors.blueGrey.shade900),
            RichTextForCard(
              label: 'Last Filled At: ',
              labelSize: 16.0,
              value: attendance.filledAt!,
              valueSize: 15.0,
              valueColor: Colors.deepPurple.shade900
            ),
            const SizedBox(height: 10.0),
            
            if (widget.viewType == 'ADMIN') _buildActionButtons(attendance: attendance)
            else if (widget.viewType == 'USER' && attendance.off != null)
              _buildFillButton(id: attendance.id!, off: attendance.off!)
          ],
        ),
      ),
    );
  }

  Widget _buildFillButton({required int id, required bool off}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        elevation: 5.0,
        backgroundColor: Colors.cyan.shade700.withOpacity(0.8),
        disabledBackgroundColor: Colors.cyan.shade700.withOpacity(0.3)
      ),
      onPressed: off ? null : () {
        context.read<AttendanceBloc>().add(FillAttendance(id: id, token: widget.token));
      },
      child: Text(
        'Fill',
        style: TextStyle(
          color: off ? Colors.blueGrey.shade600 : Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 17.0
        )
      )
    );
  }

  Widget _buildActionButtons({required Attendance attendance}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            backgroundColor: Colors.redAccent.shade200.withOpacity(0.8)
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ConfirmationDialog(
                title: 'Delete Attendance',
                content: 'Apakah Anda ingin delete data attendance ini?',
                onConfirmed: () {
                  context.read<AttendanceBloc>().add(DeleteAttendance(
                    id: attendance.id!,
                    token: widget.token
                  ));
                }
              )
            );
          },
          child: const Text('Delete', style: TextStyle(color: Colors.white, fontSize: 15.0),)
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            backgroundColor: Colors.cyan.shade700.withOpacity(0.8)
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/create-update-attendance',
              arguments: { 'attendance': attendance }
            );
          },
          child: const Text('Update', style: TextStyle(color: Colors.white, fontSize: 15.0),)
        ),
      ],
    );
  }
}