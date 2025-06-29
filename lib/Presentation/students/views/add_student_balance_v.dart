import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';

import '../../../Core/functions/show_alert.dart';
import '../state/add_student_balance/add_student_balance_bloc.dart';

// ignore: must_be_immutable
class AddStudentBalanceView extends StatefulWidget {
  const AddStudentBalanceView({super.key});

  @override
  State<AddStudentBalanceView> createState() => _AddStudentBalanceViewState();
}

class _AddStudentBalanceViewState extends State<AddStudentBalanceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => AddStudentBalanceBloc(),
        child: BlocBuilder<AddStudentBalanceBloc, AddStudentBalanceState>(
          builder: (context, state) {
            return AddStudentBalanceFormView(state: state);
          },
        ),
      ),
    );
  }
}

class AddStudentBalanceFormView extends StatefulWidget {
  const AddStudentBalanceFormView({super.key, required this.state});
  final AddStudentBalanceState state;
  @override
  State<AddStudentBalanceFormView> createState() => _AddStudentBalanceFormViewState();
}

class _AddStudentBalanceFormViewState extends State<AddStudentBalanceFormView> {
  late TextEditingController _idController;

  late TextEditingController _amountController;
  final _formKey = GlobalKey<FormState>();
  @override
  void didUpdateWidget(covariant AddStudentBalanceFormView oldWidget) {
    if ((widget.state.user != null) && !widget.state.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((e) {
        showAlert(
          context: context,
          title: "تاكيد شحن الرصيد",
          body: 'هل انت متاكد من انك تريد اضافة ${_amountController.text} الى رصيد الطالب ${widget.state.user!.name}',
          agreeBtn: "تاكيد",
          onAgree: () {
            context.read<AddStudentBalanceBloc>().add(
                  AddStudentBalanceSubmitFieldsEvent(
                    studentId: _idController.text,
                    amount: int.parse(_amountController.text),
                    confirmed: true,
                  ),
                );
          },
        );
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _idController = TextEditingController();
    _amountController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //
          const SizedBox(height: SizesResources.s2),
          //
          MyTextFormFieldWidget(
            hintText: "رقم الطالب",
            controller: _idController,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return "الرجاء ادخال رقم الطالب";
              }
              return null;
            },
          ),
          //
          const SizedBox(height: SizesResources.s2),
          //
          MyTextFormFieldWidget(
            hintText: "المبلغ",
            controller: _amountController,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return "الرجاء ادخال المبلغ";
              }
              return null;
            },
          ),
          //
          const SizedBox(height: SizesResources.s2),
          //
          ElevatedButtonWidget(
            text: "شحن",
            loading: widget.state.isLoading,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AddStudentBalanceBloc>().add(
                      AddStudentBalanceSubmitFieldsEvent(
                        studentId: _idController.text,
                        amount: int.parse(_amountController.text),
                        confirmed: false,
                      ),
                    );
              }
            },
          ),
        ],
      ),
    );
  }
}
