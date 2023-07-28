import 'package:flutter/material.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/models/voucher.dart';
import 'package:foodpanda_user/voucher/controllers/voucher_controller.dart';
import 'package:foodpanda_user/widgets/custom_textfield.dart';

Future<void> showSearchVoucherModal({
  required BuildContext context,
  required Function(Voucher) addVoucherToList,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (context) {
      TextEditingController queryController = TextEditingController();
      String queryText = '';
      dynamic result;
      String errorText = '';
      return StatefulBuilder(
        builder: ((context, setState) {
          handleAddVoucher() async {
            VoucherController voucherController = VoucherController();
            result = await voucherController.searchVoucher(
              query: queryController.text.trim(),
            );
            if (result.runtimeType != String) {
              addVoucherToList(result);
              Navigator.pop(context);
            } else {
              errorText = result;
            }
            setState(() {});
          }

          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 3,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[300],
                  ),
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add a Voucher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: Colors.grey[200],
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: queryController,
                        labelText: 'Voucher code',
                        onChanged: (value) {
                          setState(
                            () {
                              queryText = value;
                            },
                          );
                        },
                        errorText: errorText,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                  color: Colors.grey[200],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CustomTextButton(
                    text: 'Add',
                    onPressed: handleAddVoucher,
                    isDisabled: queryText.trim().isEmpty,
                  ),
                ),
              ],
            ),
          );
        }),
      );
    },
  );
}
