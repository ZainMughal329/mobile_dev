import 'package:flutter/material.dart';

class RemarksAlertDialog extends StatelessWidget {
  final String userRole;
  final TextEditingController remarksController;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const RemarksAlertDialog({
    Key? key,
    required this.userRole,
    required this.remarksController,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: 'Open Sans',
    );

    return AlertDialog(
      title: Text(
        'Add Remarks',
        style: textStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(
            controller: remarksController,
            label: 'Remarks',
            textStyle: textStyle.copyWith(color: const Color(0xff626a76)),
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            initialValue: userRole,
            label: 'User Role',
            textStyle: textStyle,
            readOnly: true,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: onCancel,
              child: Text(
                'Cancel',
                style: textStyle.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: onConfirm,
              child: Text(
                'Confirm',
                style: textStyle.copyWith(color: Colors.green),
              ),
            ),
          ],
        ),
      ],
    );
  }

  TextFormField _buildTextField({
    required String label,
    TextEditingController? controller,
    String? initialValue,
    bool readOnly = false,
    TextStyle? textStyle,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: textStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
