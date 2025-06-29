import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moatmat_admin/Core/functions/parsers/date_to_text_f.dart';
import 'package:moatmat_admin/Core/functions/parsers/time_to_text_f.dart';
import 'package:moatmat_admin/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_admin/Features/requests/domain/entities/request.dart';
import 'package:moatmat_admin/Presentation/requests/views/request_details_v.dart';

class RequestsView extends StatefulWidget {
  const RequestsView({super.key, required this.requests});
  final List<TeacherRequest> requests;
  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طلبات الرفع"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: widget.requests.length,
        itemBuilder: (context, index) {
          return TouchableTileWidget(
            title: widget.requests[index].test != null
                ? "طلب رفع اختبار"
                : "طلب رفع بنك",
            subTitle: dateToTextFunction(widget.requests[index].date),
            icon: Text(timeToText(widget.requests[index].date)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RequestDetailsView(
                request:widget.requests[index],
              )));
            },
          );
        },
      ),
    );
  }
}
