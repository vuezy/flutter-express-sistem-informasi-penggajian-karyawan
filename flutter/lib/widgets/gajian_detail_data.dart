import 'package:flutter/material.dart';
import 'package:si_penggajian/models/gajian_detail_model.dart';
import 'package:si_penggajian/utils.dart';
import 'package:si_penggajian/widgets/rich_text_for_card.dart';

class GajianDetailData extends StatelessWidget {
  final GajianDetail gajian;
  const GajianDetailData({super.key, required this.gajian});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDashedLine(context),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.blueGrey.shade900,
              fontWeight: FontWeight.w500
            ),
            children: [
              const TextSpan(
                text: 'Kehadiran: ',
                style: TextStyle(fontSize: 17.0),
              ),
              TextSpan(
                text: gajian.hadir.toString(),
                style: TextStyle(color: Colors.purple.shade700, fontWeight: FontWeight.w700)
              ),
              const TextSpan(text: '/'),
              TextSpan(
                text: gajian.jlhHariKerja.toString(),
                style: TextStyle(color: Colors.deepPurple.shade900, fontWeight: FontWeight.w700)
              ),
              const TextSpan(text: ' (Attendance '),
              TextSpan(
                text: '#${gajian.idAttendance}',
                style: TextStyle(color: Colors.deepPurple.shade900, fontWeight: FontWeight.w700)
              ),
              const TextSpan(text: ')')
            ]
          )
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'Gaji Pokok: ',
          value: Utils.formatToRupiah(gajian.gajiPokok!),
          valueColor: Colors.green.shade800
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'Tunjangan Jabatan: ',
          value: Utils.formatToRupiah(gajian.tunjanganJabatan!),
          valueColor: Colors.green.shade800
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'Tunjangan Makan: ',
          value: Utils.formatToRupiah(gajian.tunjanganMakan!),
          valueColor: Colors.green.shade800
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'Tunjangan Transportasi: ',
          value: Utils.formatToRupiah(gajian.tunjanganTransport!),
          valueColor: Colors.green.shade800
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'Gaji Bruto: ',
          labelSize: 19.0,
          labelWeight: FontWeight.w700,
          value: Utils.formatToRupiah(gajian.gajiBruto!),
          valueSize: 18.0,
          valueWeight: FontWeight.w900,
          valueColor: Colors.green.shade900
        ),
        _buildDashedLine(context),
        RichTextForCard(
          label: 'Biaya Jabatan: ',
          value: Utils.formatToRupiah(gajian.biayaJabatan!),
          valueColor: Colors.redAccent
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'Iuran BPJS: ',
          value: Utils.formatToRupiah(gajian.iuranBpjs!),
          valueColor: Colors.redAccent
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'Gaji Bersih: ',
          labelSize: 19.0,
          labelWeight: FontWeight.w700,
          value: Utils.formatToRupiah(gajian.gajiBersih!),
          valueSize: 18.0,
          valueWeight: FontWeight.w900,
          valueColor: Colors.green.shade900
        ),
        _buildDashedLine(context),
        RichTextForCard(
          label: 'Status Menikah: ',
          value: gajian.menikah!,
          valueColor: Colors.deepPurple.shade900
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'Jumlah Anak: ',
          value: gajian.jlhAnak.toString(),
          valueColor: Colors.deepPurple.shade900
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'PTKP: ',
          value: Utils.formatToRupiah(gajian.ptkp!),
          valueColor: Colors.purple.shade700
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'PKP: ',
          value: Utils.formatToRupiah(gajian.pkp!),
          valueColor: Colors.pink.shade300
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'PPh: ',
          labelSize: 19.0,
          labelWeight: FontWeight.w700,
          value: Utils.formatToRupiah(gajian.pph!),
          valueSize: 18.0,
          valueWeight: FontWeight.w900,
          valueColor: Colors.redAccent
        ),
        _buildDashedLine(context),
        RichTextForCard(
          label: 'Total Gaji Diterima:\n',
          labelSize: 19.0,
          labelWeight: FontWeight.w700,
          value: Utils.formatToRupiah(gajian.gajiDiterima!),
          valueSize: 20.0,
          valueWeight: FontWeight.w900,
          valueColor: Colors.green.shade900
        ),
        const SizedBox(height: 10.0,),
        RichTextForCard(
          label: 'Tanggal Terima Gaji: ',
          value: gajian.tglTerima!,
          valueColor: Colors.deepPurple.shade900
        ),
        const SizedBox(height: 10.0,),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.blueGrey.shade900,
              fontWeight: FontWeight.w500
            ),
            children: [
              const TextSpan(text: 'Gaji '),
              TextSpan(
                text: gajian.tglTerima == '-' ? 'AKAN ' : 'SUDAH ',
                style: TextStyle(fontSize: 17.0, color: Colors.purple.shade700, fontWeight: FontWeight.w700),
              ),
              const TextSpan(text: 'dikirim ke nomor rekening:\n'),
              TextSpan(
                text: gajian.noRek!,
                style: TextStyle(color: Colors.deepPurple.shade900, fontWeight: FontWeight.w700)
              )
            ]
          )
        ),
      ],
    );
  }

  Widget _buildDashedLine(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 40 - 29 * 3) / 30;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(30, (_) {
        return Column(
          children: [
            const SizedBox(height: 20.0,),
            Container(
              color: Colors.blueGrey.shade900,
              height: 0.6,
              width: width
            ),
            const SizedBox(height: 10.0,),
          ],
        );
      })
    );
  }
}