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
    const textStyle = TextStyle(
      fontFamily: 'Open Sans',
    );

    return AlertDialog(
      title: const Text(
        'Add Remarks',
        style: textStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: remarksController,
            decoration: InputDecoration(
              labelText: 'Remarks',
              labelStyle: textStyle.copyWith(
                color: const Color(0xff626a76),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue: userRole,
            readOnly: true,
            enabled: false,
            decoration: InputDecoration(
              labelText: 'User Role',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
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
                style: textStyle.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: onConfirm,
              child: Text(
                'Confirm',
                style: textStyle.copyWith(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
