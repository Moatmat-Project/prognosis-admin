import 'package:moatmat_admin/Features/banks/domain/entities/bank_options.dart';

class BankOptionsModel extends BankOptions {
  BankOptionsModel({
    required super.scrollable,
    required super.visible,
    required super.downloadable,
  });

  factory BankOptionsModel.fromJson(Map? json) {
    return BankOptionsModel(
      scrollable: json?["scrollable"] ?? false,
      visible: json?["visible"] ?? false,
      downloadable: json?["downloadable"] ?? false,
    );
  }

  factory BankOptionsModel.fromClass(BankOptions options) {
    return BankOptionsModel(
      scrollable: options.scrollable,
      visible: options.visible,
      downloadable: options.downloadable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "scrollable": scrollable,
      "visible": visible,
      "downloadable": downloadable,
    };
  }
}
