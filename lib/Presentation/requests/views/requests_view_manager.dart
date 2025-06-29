import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Presentation/requests/state/cubit/requests_cubit.dart';
import 'package:moatmat_admin/Presentation/requests/views/requests_v.dart';

class RequestsViewManager extends StatefulWidget {
  const RequestsViewManager({super.key});

  @override
  State<RequestsViewManager> createState() => _RequestsViewManagerState();
}

class _RequestsViewManagerState extends State<RequestsViewManager> {
  @override
  void initState() {
    context.read<RequestsCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RequestsCubit, RequestsState>(
        builder: (context, state) {
          if (state is RequestsInitial) {
            return RequestsView(requests: state.requests);
          } else if (state is RequestsError) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
