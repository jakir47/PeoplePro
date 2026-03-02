import 'package:flutter/material.dart';
import 'package:peoplepro/models/regularization_model.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/date_field_widget.dart';

class RegularizationRowWidget extends StatefulWidget {
  final RegularizationModel model;
  final Function(RegularizationModel) onEdit;
  final Function onDelete;

  RegularizationRowWidget({
    required this.model,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _RegularizationRowWidgetState createState() =>
      _RegularizationRowWidgetState();
}

class _RegularizationRowWidgetState extends State<RegularizationRowWidget> {
  TextEditingController dateController = TextEditingController();
  TextEditingController purposeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = widget.model.dateOfRegularization ?? '';
    purposeController.text = widget.model.purpose ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      minVerticalPadding: 0,
      minLeadingWidth: 0,
      horizontalTitleGap: 0,
      title: DateFieldWidget(
          controller: dateController,
          boderRadius: 6.0,
          onChanged: (date) {
            widget.model.dateOfRegularization =
                Utils.formatDate(date!, format: "dd/MM/yyyy");
          }),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: TextField(
          controller: purposeController,
          maxLines: 2,
          onChanged: (value) {
            widget.model.purpose = value;
            widget.onEdit(widget.model);
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: UserColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: UserColors.borderColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          color: UserColors.red,
        ),
        onPressed: widget.onDelete as void Function()?,
      ),
    );
  }
}
