class BankOptions {
  final bool scrollable;
  final bool visible;
  final bool downloadable;

  BankOptions({
    required this.scrollable,
    required this.visible,
    required this.downloadable,
  });

  BankOptions copyWith({
    bool? scrollable,
    bool? visible,
    bool? downloadable,
  }) {
    return BankOptions(
      scrollable: scrollable ?? this.scrollable,
      visible: visible ?? this.visible,
      downloadable: downloadable ?? this.downloadable,
    );
  }
}
