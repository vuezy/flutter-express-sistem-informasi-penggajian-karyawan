import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/jabatan_bloc/jabatan_bloc.dart';
import 'package:si_penggajian/bloc/user_bloc/user_bloc.dart';
import 'package:si_penggajian/models/jabatan_model.dart';
import 'package:si_penggajian/widgets/background_image.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';
import 'package:si_penggajian/widgets/register_account.dart';
import 'package:si_penggajian/widgets/register_karyawan.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _karyawanKey = GlobalKey<RegisterKaryawanState>();
  final _karyawanFormKey = GlobalKey<FormState>();
  final _accountKey = GlobalKey<RegisterAccountState>();
  final _accountFormKey = GlobalKey<FormState>();
  int _currentStep = 0;
  int? _errorStep;

  StepState _setStepState(int index) {
    if (_errorStep == index) return StepState.error;
    if (_currentStep > index) return StepState.complete;
    return StepState.indexed;
  }

  void _onStepContinue() {
    if (_currentStep == 0 && !_karyawanFormKey.currentState!.validate()) {
      setState(() { _errorStep = 0; });
      return;
    }
    if (_currentStep == 1 && !_accountFormKey.currentState!.validate()) {
      setState(() { _errorStep = 1; });
      return;
    }
    if (_currentStep == 2) {
      context.read<UserBloc>().add(RegisterUser(
        user: {
          'nama': _karyawanKey.currentState!.tecNama.text,
          'gender': _karyawanKey.currentState!.selectedGender,
          'usia': _karyawanKey.currentState!.tecUsia.text,
          'menikah': _karyawanKey.currentState!.selectedMenikah,
          'jlh_anak': _karyawanKey.currentState!.tecJlhAnak.text,
          'alamat': _karyawanKey.currentState!.tecAlamat.text,
          'no_telp': _karyawanKey.currentState!.tecNoTelp.text,
          'no_rek': _karyawanKey.currentState!.tecNoRek.text,
          'id_jabatan': _karyawanKey.currentState!.selectedIdJabatan,
          'username': _accountKey.currentState!.tecUsername.text,
          'email': _accountKey.currentState!.tecEmail.text,
          'password': _accountKey.currentState!.tecPassword.text
        }
      ));
      return;
    }
    
    setState(() { _errorStep = null; _currentStep += 1; });
  }

  void _onStepCancel() {
    setState(() { _currentStep -= 1; });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      image: 'assets/images/medium-purple-bg.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleText(text: 'Register', fontSize: 32.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      elevation: 5.0,
                      backgroundColor: Colors.pink.shade900.withOpacity(0.4)
                    ),
                    onPressed: () { Navigator.of(context).pop(); },
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back, color: Colors.orange),
                        SizedBox(width: 5.0,),
                        Text('Go Back', style: TextStyle(color: Colors.orange))
                      ],
                    )
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              BlocConsumer<JabatanBloc, JabatanState>(
                listener: (context, state) {
                  if (state is JabatanError) {
                    Navigator.of(context).pop();
                    MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
                  }
                },
                builder: (context, state) {
                  if (state is JabatanLoaded) {
                    return Stepper(
                      physics: const BouncingScrollPhysics(),
                      type: StepperType.vertical,
                      currentStep: _currentStep,
                      onStepContinue: _onStepContinue,
                      onStepCancel: _onStepCancel,
                      steps: _buildSteps(state.jabatan),
                      controlsBuilder: (context, details) {
                        return BlocConsumer<UserBloc, UserState>(
                          listener: (context, state) {
                            if (state is UserError) {
                              MyFlushbar(
                                message: state.message,
                                flushbarType: FlushbarType.error
                              ).show(context);
                              setState(() {
                                _errorStep = 1;
                                _currentStep = 1;
                              });
                            }
                            if (state is UserRegistered) {
                              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                              MyFlushbar(
                                message: state.message,
                                flushbarType: FlushbarType.success
                              ).show(context);
                            }
                          },
                          builder: (context, state) {
                            if (state is UserLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return ButtonBar(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(elevation: 10.0),
                                  onPressed: _onStepContinue,
                                  child: Text(_currentStep == 2 ? 'Submit' : 'Next')
                                ),
                                
                                if (_currentStep > 0)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 10.0,
                                      backgroundColor: Colors.white12
                                    ),
                                    onPressed: _onStepCancel,
                                    child: const Text('Back')
                                  )
                              ],
                            );
                          }
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ]
          )
        )
      ),
    );
  }

  List<Step> _buildSteps(List<Jabatan> jabatan) {
    return [
      Step(
        isActive: _currentStep >= 0,
        state: _setStepState(0),
        title: _buildTitleText(text: 'Data Karyawan', fontSize: 18.0),
        content: RegisterKaryawan(key: _karyawanKey, formKey: _karyawanFormKey, jabatan: jabatan)
      ),
      Step(
        isActive: _currentStep >= 1,
        state: _setStepState(1),
        title: _buildTitleText(text: 'Account', fontSize: 18.0),
        content: RegisterAccount(key: _accountKey, formKey: _accountFormKey)
      ),
      Step(
        isActive: _currentStep >= 2,
        state: _setStepState(2),
        title: _buildTitleText(text: 'Confirmation', fontSize: 18.0),
        content: Container(
          margin: const EdgeInsets.only(bottom: 15.0),
          child: Text(
            'Make sure to check the data you provided before submitting!',
            style: TextStyle(
              shadows: const [
                Shadow(color: Colors.black54, offset: Offset(2.0, 2.0),),
                Shadow(color: Colors.black26, offset: Offset(4.5, 4.5),)
              ],
              color: Colors.redAccent.shade200,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic
            ),
          ),
        )
      )
    ];
  }

  Widget _buildTitleText({required String text, required double fontSize}) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Playfair Display',
        fontWeight: FontWeight.w600,
        fontSize: fontSize
      )
    );
  }
}