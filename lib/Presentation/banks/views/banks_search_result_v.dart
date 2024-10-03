import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Presentation/banks/state/search_bank/search_bank_cubit.dart';
import 'package:moatmat_admin/Presentation/banks/views/bank_details_v.dart';
import 'package:moatmat_admin/Presentation/banks/widgets/bank_tile_w.dart';

class BanksSearchResultView extends StatefulWidget {
  const BanksSearchResultView({super.key, required this.keyword});
  final String keyword;

  @override
  State<BanksSearchResultView> createState() => _BanksSearchResultViewState();
}

class _BanksSearchResultViewState extends State<BanksSearchResultView> {
  @override
  void initState() {
    context.read<SearchBankCubit>().search(widget.keyword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<SearchBankCubit, SearchBankState>(
        builder: (context, state) {
          if (state is SearchBankInitial) {
            return ListView.builder(
              itemCount: state.banks.length,
              itemBuilder: (context, index) {
                return BankTileWidget(
                  bank: state.banks[index],
                  onPick: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BankDetailsView(
                          bank: state.banks[index],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is SearchBankError) {
            return Center(
              child: Text(state.error),
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
