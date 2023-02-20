import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:si_penggajian/bloc/karyawan_bloc/karyawan_bloc.dart';
import 'package:si_penggajian/bloc/user_bloc/user_bloc.dart';
import 'package:si_penggajian/models/attendance_model.dart';
import 'package:si_penggajian/models/karyawan_model.dart';
import 'package:si_penggajian/widgets/background_image.dart';
import 'package:si_penggajian/widgets/custom_text_field.dart';
import 'package:si_penggajian/widgets/dropdown_field.dart';
import 'package:si_penggajian/widgets/form_header.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';

enum AttendanceActionType { create, update }

class CreateUpdateAttendance extends StatefulWidget {
  final Attendance? attendance;
  const CreateUpdateAttendance({super.key, required this.attendance});

  @override
  State<CreateUpdateAttendance> createState() => _CreateUpdateAttendanceState();
}

class _CreateUpdateAttendanceState extends State<CreateUpdateAttendance> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tecTglMulai;
  late TextEditingController _tecTglBerakhir;
  late TextEditingController _tecJlhHariKerja;
  dynamic _selectedIdKaryawan = 'all';
  late AttendanceActionType action;

  @override
  void initState() {
    super.initState();
    _tecJlhHariKerja = TextEditingController(text: widget.attendance?.jlhHariKerja.toString() ?? '30');
    
    if (widget.attendance == null) {
      action = AttendanceActionType.create;
      _tecTglMulai = TextEditingController(text: DateTime.now().toString().substring(0, 10));
      _tecTglBerakhir = TextEditingController(
        text: DateTime.now().add(const Duration(days: 30)).toString().substring(0, 10)
      );
    }
    else {
      action = AttendanceActionType.update;
      _tecTglMulai = TextEditingController(
        text: DateTime.parse(widget.attendance!.tglMulai!).toString().substring(0, 10)
      );
      _tecTglBerakhir = TextEditingController(
        text: DateTime.parse(widget.attendance!.tglBerakhir!).toString().substring(0, 10)
      );
    }
  }

  @override
  void dispose() {
    _tecJlhHariKerja.dispose();
    super.dispose();
  }
    
  void _submitForm(String token) {
    if (_formKey.currentState!.validate()) {
      if (action == AttendanceActionType.create) {
        context.read<AttendanceBloc>().add(CreateAttendance(
          attendance: {
            'tgl_mulai': _tecTglMulai.text,
            'tgl_berakhir': _tecTglBerakhir.text,
            'jlh_hari_kerja': _tecJlhHariKerja.text,
            'id_karyawan': _selectedIdKaryawan
          },
          token: token
        ));
      }

      if (action == AttendanceActionType.update) {
        context.read<AttendanceBloc>().add(UpdateAttendance(
          id: widget.attendance!.id!,
          attendance: {
            'tgl_mulai': _tecTglMulai.text,
            'tgl_berakhir': _tecTglBerakhir.text,
            'jlh_hari_kerja': _tecJlhHariKerja.text,
          },
          token: token
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      image: 'assets/images/light-purple-bg.jpg',
      gradientType: GradientType.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15.0),
            children: [
              if (action == AttendanceActionType.create)
              const FormHeader(title: 'Create Attendance')
              else
              FormHeader(title: 'Update Attendance', showId: true, id: widget.attendance!.id),
              const SizedBox(height: 20.0,),
    
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoggedIn) {
                    final token = state.account.token;
    
                    return BlocConsumer<AttendanceBloc, AttendanceState>(
                      listener: (context, state) {
                        if (state is AttendanceError) {
                          MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
                        }
    
                        if (state is AttendanceFilledOrCreated) {
                          Navigator.of(context).pushNamedAndRemoveUntil('/admin', (route) => false);
                          MyFlushbar(message: state.message, flushbarType: FlushbarType.success).show(context);
                        }
    
                        if (state is AttendanceUpdated) {
                          Navigator.of(context).pushNamedAndRemoveUntil('/admin', (route) => false);
                          const MyFlushbar(
                            message: 'Attendance updated successfully!',
                            flushbarType: FlushbarType.success
                          ).show(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is AttendanceLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (action == AttendanceActionType.create) {
                          return BlocConsumer<KaryawanBloc, KaryawanState>(
                            listener: (context, state) {
                              if (state is KaryawanError) {
                                MyFlushbar(
                                  message: state.message,
                                  flushbarType: FlushbarType.error
                                ).show(context);
                              }
                            },
                            builder: (context, state) {
                              if (state is KaryawanLoaded) {
                                return _buildForm(token: token!, karyawan: state.karyawan);
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                          );
                        }
                        return _buildForm(token: token!);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }
              )
            ]
          )
        )
      ),
    );
  }

  Widget _buildForm({required String token, List<Karyawan>? karyawan}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDatePickerField(
                  label: 'Tanggal Mulai',
                  controller: _tecTglMulai,
                  onTap: () async {
                    final currentDate = DateTime.now();

                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: currentDate,
                      firstDate: DateTime(currentDate.year, currentDate.month),
                      lastDate: DateTime(currentDate.year, currentDate.month + 1)
                    );

                    if (date == null) return;
                    setState(() {
                      _tecTglMulai.text = date.toString().substring(0, 10);
                    });
                  }
                )
              ),
              const SizedBox(width: 10.0,),
              Expanded(
                child: _buildDatePickerField(
                  label: 'Tanggal Berakhir',
                  controller: _tecTglBerakhir,
                  onTap: () async {
                    final currentDate = DateTime.now();

                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: currentDate.add(const Duration(days: 30)),
                      firstDate: DateTime(currentDate.year, currentDate.month + 1),
                      lastDate: DateTime(currentDate.year, currentDate.month + 3)
                    );

                    if (date == null) return;
                    setState(() {
                      _tecTglBerakhir.text = date.toString().substring(0, 10);
                    });
                  }
                )
              )
            ],
          ),
          const SizedBox(height: 20.0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Jumlah Hari Kerja',
                  controller: _tecJlhHariKerja,
                  hintText: 'Jumlah Hari Kerja',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10.0,),
              
              if (action == AttendanceActionType.create)
              Expanded(
                child: DropdownField(
                  label: 'Attendance For:',
                  value: _selectedIdKaryawan,
                  items: [
                    const { 'value': 'all', 'text': 'All' },
                    ...karyawan!.map((k) => {
                      'value': k.id,
                      'text': '${k.id} - ${k.nama}'
                    }).toList()
                  ],
                  onChanged: (value) => { setState(() { _selectedIdKaryawan = value; }) }
                ),
              )
              else
              const Spacer()
            ],
          ),
          const SizedBox(height: 30.0,),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
              ),
              onPressed: () { _submitForm(token); },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(action == AttendanceActionType.create ? Icons.add : Icons.save),
                  const SizedBox(width: 5.0,),
                  Text(
                    action == AttendanceActionType.create ? 'Create' : 'Update',
                    style: const TextStyle(fontSize: 16.0)
                  )
                ],
              )
            ),
          ),
          const SizedBox(height: 20.0,),
        ],
      )
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required TextEditingController controller,
    required void Function() onTap
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.blueGrey.shade900,
            fontSize: 18.0,
            fontWeight: FontWeight.w600
          )
        ),
        const SizedBox(height: 3.0),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.black, fontSize: 15.0),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
            prefixIcon: const Icon(Icons.date_range),
            filled: true,
            fillColor: Colors.white24,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.blueGrey.shade800)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.deepPurple.shade500, width: 2)
            ),
          ),
          readOnly: true,
          onTap: onTap,
        )
      ]
    );
  }
}