import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_admin/Presentation/banks/state/my_banks/my_banks_cubit.dart';
import 'package:moatmat_admin/Presentation/banks/views/bank_details_v.dart';
import 'package:moatmat_admin/Presentation/banks/widgets/bank_tile_w.dart';
import '../../../Core/widgets/view/search_in_banks_v.dart';

class MyBanksView extends StatelessWidget {
  const MyBanksView({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyBanksCubit, MyBanksState>(
        builder: (context, state) {
          if (state is MyBanksInitial) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("تصفح البنوك"),
                actions: [
                  BanksSearchWidget(banks: state.banks),
                ],
              ),
              body: state.banks.isEmpty
                  ? const Center(
                      child: Text("لا يوجد بنوك"),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        context.read<MyBanksCubit>().update();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: state.banks.length,
                        itemBuilder: (context, index) => BankTileWidget(
                          bank: state.banks[index],
                          onPick: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BankDetailsView(
                                  bank: state.banks[index],
                                ),
                              ),
                            );
                            if (context.mounted) {
                              context.read<MyBanksCubit>().update();
                            }
                          },
                        ),
                      ),
                    ),
            );
          } else if (state is MyBanksError) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    "حصل خطا ما, تاكد من اتصالك بالانترنيت",
                    textAlign: TextAlign.center,
                  )),
                  Center(
                      child: TextButton(
                    onPressed: () {
                      context.read<MyBanksCubit>().update();
                    },
                    child: Text("حاول مرة اخرى"),
                  )),
                ],
              ),
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

class BanksSearchWidget extends StatelessWidget {
  const BanksSearchWidget({
    super.key,
    required this.banks,
  });
  final List<Bank> banks;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchInBanksView(
              banks: banks,
              onPick: (bank) async {
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BankDetailsView(
                      bank: bank,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      icon: const Icon(Icons.search),
    );
  }
}
