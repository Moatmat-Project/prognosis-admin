

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';

class TimeRangeWidget extends StatelessWidget {
  const TimeRangeWidget({
    super.key,
    required this.starting,
    required this.ending,
    required this.onChangeStartingDate,
    required this.onChangeEndingDate,
    this.limitOnDate = true,
  });
  final DateTime starting, ending;
  final void Function(DateTime date) onChangeStartingDate;
  final void Function(DateTime date) onChangeEndingDate;
  final bool limitOnDate;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              width: SpacingResources.mainWidth(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsResources.primary.withAlpha(50),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: ColorsResources.darkPrimary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(starting),
                                    );
                                    if (picked != null) {
                                      onChangeStartingDate(adjustDate(starting, newTime: picked));
                                    }
                                  },
                                  child: Text(
                                    DateFormat('hh:mm a').format(starting),
                                    style: TextStyle(
                                      color: ColorsResources.primary,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Tajawal",
                                      fontSize: 19,
                                      decorationColor: ColorsResources.primary.withAlpha(200),
                                      decorationThickness: 15,
                                      decorationStyle: TextDecorationStyle.solid,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    firstDate: limitOnDate ? starting : DateTime(2000),
                                    lastDate: limitOnDate ? ending : DateTime(DateTime.now().year + 1),
                                    initialDate: starting,
                                    keyboardType: TextInputType.text,
                                  );
                                  if (picked != null) {
                                    onChangeStartingDate(adjustDate(starting, newDate: picked));
                                  }
                                },
                                child: Text(
                                  DateFormat('yy/MM/dd').format(starting),
                                  style: TextStyle(
                                    color: ColorsResources.primary.withAlpha(200),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Tajawal",
                                    fontSize: 16,
                                    decorationColor: ColorsResources.primary.withAlpha(200),
                                    decorationThickness: 15,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 10, right: 10),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: ColorsResources.primary,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsResources.primary.withAlpha(50),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: ColorsResources.darkPrimary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(ending),
                                    );
                                    onChangeEndingDate(adjustDate(ending, newTime: picked));
                                  },
                                  child: Text(
                                    DateFormat('hh:mm a').format(ending),
                                    style: TextStyle(
                                      color: ColorsResources.primary,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Tajawal",
                                      fontSize: 19,
                                      decorationColor: ColorsResources.primary,
                                      decorationThickness: 15,
                                      decorationStyle: TextDecorationStyle.solid,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    firstDate: limitOnDate ? starting : DateTime(2000),
                                    lastDate: limitOnDate ? ending : DateTime(DateTime.now().year + 1),
                                    initialDate: ending,
                                    keyboardType: TextInputType.text,
                                  );
                                  onChangeEndingDate(adjustDate(ending, newDate: picked));
                                },
                                child: Text(
                                  DateFormat('yy/MM/dd').format(ending),
                                  style: TextStyle(
                                    color: ColorsResources.primary.withAlpha(200),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Tajawal",
                                    fontSize: 16,
                                    decorationThickness: 15,
                                    decorationColor: ColorsResources.primary,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  DateTime adjustDate(DateTime date, {TimeOfDay? newTime, DateTime? newDate}) {
    if (newTime != null) {
      return DateTime(date.year, date.month, date.day, newTime.hour, newTime.minute);
    }
    if (newDate != null) {
      return DateTime(newDate.year, newDate.month, newDate.day, date.hour, date.minute);
    }
    return DateTime.now();
  }
}
