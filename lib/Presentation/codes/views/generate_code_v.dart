import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Presentation/codes/state/codes/codes_cubit.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/validators/not_empty_v.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/fields/text_input_field.dart';

class GenerateCodeView extends StatefulWidget {
  const GenerateCodeView({super.key});

  @override
  State<GenerateCodeView> createState() => _GenerateCodeViewState();
}

class _GenerateCodeViewState extends State<GenerateCodeView> {
  final _formKey = GlobalKey<FormState>();
  int amount = 0;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: SizesResources.s4),
            MyTextFormFieldWidget(
              hintText: "رصيد الكود",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (p0) {
                return notEmptyValidator(text: p0);
              },
              onSaved: (p0) {
                amount = int.tryParse(p0!) ?? 0;
              },
            ),
            const SizedBox(height: SizesResources.s2),
            MyTextFormFieldWidget(
              hintText: "عدد الاكواد",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (p0) {
                if (p0 == "0") {
                  return "ادخل رقم صحيح";
                }
                return notEmptyValidator(text: p0);
              },
              onSaved: (p0) {
                count = int.tryParse(p0!) ?? 0;
              },
            ),
            const SizedBox(height: SizesResources.s2),
            ElevatedButtonWidget(
              text: "آنشاء كود",
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  context.read<CodesCubit>().generateCodes(
                        count: count,
                        amount: amount,
                      );
                }
              },
            ),
            const SizedBox(height: SizesResources.s10 * 2),
          ],
        ),
      ),
    );
  }
}
