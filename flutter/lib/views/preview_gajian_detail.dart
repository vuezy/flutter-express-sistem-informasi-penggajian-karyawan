import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/gajian_detail_bloc/gajian_detail_bloc.dart';
import 'package:si_penggajian/models/gajian_detail_model.dart';
import 'package:si_penggajian/widgets/background_image.dart';
import 'package:si_penggajian/widgets/form_header.dart';
import 'package:si_penggajian/widgets/gajian_detail_data.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';
import 'package:si_penggajian/widgets/rich_text_for_card.dart';

class PreviewGajianDetail extends StatelessWidget {
  const PreviewGajianDetail({super.key});

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
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
            children: [
              const FormHeader(title: 'Preview Gajian'),
              BlocConsumer<GajianDetailBloc, GajianDetailState>(
                listener: (context, state) {
                  if (state is GajianDetailError) {
                    MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
                  }
                },
                builder: (context, state) {
                  if (state is GajianDetailLoaded) return _buildGajianCard(gajian: state.gajian);
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 5.0,),
                        Text(
                          'Loading Preview Gajian...',
                          style: TextStyle(color: Colors.deepPurple.shade900)
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGajianCard({required GajianDetail gajian}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 10.0,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade100, 
              Colors.deepPurple.shade100.withOpacity(0.8),
              Colors.purple.shade200.withOpacity(0.8),
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichTextForCard(
              label: 'Karyawan: ',
              labelSize: 19.0,
              value: gajian.karyawan!,
              valueSize: 18.0,
              valueColor: Colors.purple.shade700
            ),
            const SizedBox(height: 10.0,),
            RichTextForCard(
              label: 'Jabatan: ',
              labelSize: 19.0,
              value: gajian.jabatan!,
              valueSize: 18.0,
              valueColor: Colors.deepPurple.shade900
            ),
            GajianDetailData(gajian: gajian)
          ]
        )
      )
    );
  }
}