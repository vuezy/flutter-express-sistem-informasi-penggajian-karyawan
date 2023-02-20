import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/gajian_bloc/gajian_bloc.dart';
import 'package:si_penggajian/bloc/gajian_detail_bloc/gajian_detail_bloc.dart';
import 'package:si_penggajian/bloc/jabatan_bloc/jabatan_bloc.dart';
import 'package:si_penggajian/bloc/karyawan_bloc/karyawan_bloc.dart';
import 'package:si_penggajian/models/gajian_model.dart';
import 'package:si_penggajian/utils.dart';
import 'package:si_penggajian/widgets/confirmation_dialog.dart';
import 'package:si_penggajian/widgets/custom_app_bar.dart';
import 'package:si_penggajian/widgets/gajian_bottom_sheet.dart';
import 'package:si_penggajian/widgets/gajian_detail_data.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';
import 'package:si_penggajian/widgets/option_selector.dart';
import 'package:si_penggajian/widgets/rich_text_for_card.dart';
import 'package:si_penggajian/widgets/search_bar.dart';

class GajianPage extends StatefulWidget {
  final String viewType;
  final String token;
  const GajianPage({super.key, required this.viewType, required this.token});

  @override
  State<GajianPage> createState() => _GajianPageState();
}

class _GajianPageState extends State<GajianPage> {
  final _tecSearch = TextEditingController();
  String _selectedOrderBy = 'Latest';
  final List<String> _orderByItems = [
    'Latest',
    'Oldest',
    'Gaji Diterima (ASC)',
    'Gaji Diterima (DESC)'
  ];
  int? _idGajianWithShownDetail;

  @override
  void dispose() {
    _tecSearch.dispose();
    super.dispose();
  }

  List<Gajian> _sort(List<Gajian> gajian) {
    gajian.sort((a, b) {
      final comp1 = Utils.compare(a.tglTerima!, b.tglTerima!);
      final comp2 = a.id!.compareTo(b.id!);
      final comp3 = double.parse(a.gajiDiterima!).compareTo(double.parse(b.gajiDiterima!));

      if (_selectedOrderBy == 'Latest') {
        if (comp1 == 0) {
          if (comp2 == 0) return comp3;
          return -1 * comp2;
        }
        return -1 * comp1;
      }

      if (_selectedOrderBy == 'Oldest') {
        if (comp1 == 0) {
          if (comp2 == 0) return comp3;
          return comp2;
        }
        return comp1;
      }

      if (_selectedOrderBy == 'Gaji Diterima (ASC)') {
        if (comp3 == 0) {
          if (comp1 == 0) return -1 * comp2;
          return -1 * comp1;
        }
        return comp3;
      }

      if (_selectedOrderBy == 'Gaji Diterima (DESC)') {
        if (comp3 == 0) {
          if (comp1 == 0) return -1 * comp2;
          return -1 * comp1;
        }
        return -1 * comp3;
      }

      return 0;
    });

    return gajian;
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
            setState(() { _idGajianWithShownDetail = null; });
            context.read<GajianBloc>().add(SearchGajian(query: query ?? '', token: widget.token));
          }
        ) : null,
        content: [
          OptionSelector(
            dropdownDirection: widget.viewType == 'ADMIN' ? DropdownDirection.vertical : DropdownDirection.horizontal,
            label: 'Order By: ',
            labelSize: widget.viewType == 'ADMIN' ? 15.0 : 18.0,
            dropdownWidth: widget.viewType == 'ADMIN' ? null : 200.0,
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
              context.read<JabatanBloc>().add(const SearchJabatan(query: ''));
              setState(() { _idGajianWithShownDetail = null; });
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                isScrollControlled: true,
                builder: (context) => const GajianBottomSheet()
              );
            },
            child: Row(
              children: const [
                Icon(Icons.add, size: 20.0,),
                SizedBox(width: 5.0,),
                Text('Create Gajian', style: TextStyle(color: Colors.white, fontSize: 12.0)),
              ],
            )
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: BlocConsumer<GajianBloc, GajianState>(
        listener: (context, state) {
          if (state is GajianError) {
            MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
          }

          if (state is GajianReceivedOrCreated) {
            MyFlushbar(message: state.message, flushbarType: FlushbarType.success).show(context);
            setState(() { _idGajianWithShownDetail = null; });
            context.read<GajianBloc>().add(GetGajianList(token: widget.token));
          }
          
          if (state is GajianDeleted) {
            const MyFlushbar(
              message: 'Gajian deleted successfully!',
              flushbarType: FlushbarType.success
            ).show(context);
            setState(() { _idGajianWithShownDetail = null; });
            context.read<GajianBloc>().add(SearchGajian(query: _tecSearch.text, token: widget.token));
          }
        },
        builder: (context, state) {
          if (state is GajianLoaded) {
            final gajian = _sort(state.gajian);

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 8.0),
              itemCount: gajian.length,
              itemBuilder: (context, index) {
                return _buildGajianCard(gajian: gajian[index]);
              },
            );
          }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 5.0,),
                Text('Loading Gajian...', style: TextStyle(color: Colors.deepPurple.shade900),)
              ],
            ),
          );
        },
      )
    );
  }

  Widget _buildGajianCard({required Gajian gajian}) {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Gajian #${gajian.id}',
              style: const TextStyle(
                fontSize: 22.0,
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w600,
                color: Colors.black87
              ),
            ),
            Divider(color: Colors.blueGrey.shade900),

            if (widget.viewType == 'ADMIN' && gajian.karyawan != null)
            RichTextForCard(
              label: 'Karyawan: ',
              labelSize: 19.0,
              value: gajian.karyawan!,
              valueSize: 18.0,
              valueColor: Colors.purple.shade700
            ),
            if (widget.viewType == 'ADMIN')
            const SizedBox(height: 10.0,),

            RichTextForCard(
              label: 'Jabatan: ',
              labelSize: 19.0,
              value: gajian.jabatan!,
              valueSize: 18.0,
              valueColor: Colors.deepPurple.shade900
            ),

            if (_idGajianWithShownDetail == gajian.id)
            BlocConsumer<GajianDetailBloc, GajianDetailState>(
              listener: (context, state) {
                if (state is GajianDetailError) {
                  MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
                }
              },
              builder: (context, state) {
                if (state is GajianDetailLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GajianDetailData(gajian: state.gajian),
                      const SizedBox(height: 15.0,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () { setState(() { _idGajianWithShownDetail = null; }); },
                          child: Text(
                            'Hide Detail',
                            style: TextStyle(color: Colors.purple.shade900, fontSize: 16.0)
                          )
                        ),
                      )
                    ],
                  );
                }
                return SizedBox(
                  height: 120.0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 5.0,),
                        Text('Loading Detail...', style: TextStyle(color: Colors.deepPurple.shade900))
                      ],
                    ),
                  )
                );
              },
            )
            else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGajianData(gajian: gajian),
                const SizedBox(height: 15.0,),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.read<GajianDetailBloc>().add(GetGajianDetail(
                        id: gajian.id!, token: widget.token)
                      );
                      setState(() { _idGajianWithShownDetail = gajian.id; });
                    },
                    child: Text(
                      'Show Detail',
                      style: TextStyle(color: Colors.purple.shade900, fontSize: 16.0)
                    )
                  ),
                )
              ],
            ),

            if (widget.viewType == 'ADMIN') _buildActionButtons(gajian: gajian)
            else _buildReceiveButton(id: gajian.id!, off: gajian.tglTerima != '-')
          ],
        ),
      ),
    );
  }

  Widget _buildGajianData({required Gajian gajian}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0,),
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
          labelSize: 19.0,
          value: gajian.tglTerima!,
          valueSize: 18.0,
          valueColor: Colors.deepPurple.shade900
        ),
      ],
    );
  }

  Widget _buildReceiveButton({required int id, required bool off}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        elevation: 5.0,
        backgroundColor: Colors.cyan.shade700.withOpacity(0.8),
        disabledBackgroundColor: Colors.cyan.shade700.withOpacity(0.3)
      ),
      onPressed: off ? null : () {
        context.read<GajianBloc>().add(ReceiveGajian(id: id, token: widget.token));
      },
      child: Text(
        'Receive',
        style: TextStyle(
          color: off ? Colors.blueGrey.shade600 : Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 17.0
        )
      )
    );
  }

  Widget _buildActionButtons({required Gajian gajian}) {
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
                title: 'Delete Gajian',
                content: 'Apakah Anda ingin delete data gajian ini?',
                onConfirmed: () {
                  context.read<GajianBloc>().add(DeleteGajian(
                    id: gajian.id!,
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
            context.read<KaryawanBloc>().add(SearchKaryawan(query: '', token: widget.token));
            context.read<JabatanBloc>().add(const SearchJabatan(query: ''));
            setState(() { _idGajianWithShownDetail = null; });
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              isScrollControlled: true,
              builder: (context) => GajianBottomSheet(gajian: gajian)
            );
          },
          child: const Text('Update', style: TextStyle(color: Colors.white, fontSize: 15.0),)
        ),
      ],
    );
  }
}