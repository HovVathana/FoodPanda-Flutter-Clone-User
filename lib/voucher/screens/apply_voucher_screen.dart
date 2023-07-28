import 'package:flutter/material.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/voucher.dart';
import 'package:foodpanda_user/voucher/controllers/voucher_controller.dart';
import 'package:foodpanda_user/voucher/widgets/extended_voucher_card.dart';
import 'package:foodpanda_user/voucher/widgets/voucher_card.dart';
import 'package:foodpanda_user/voucher/widgets/voucher_detail_modal.dart';
import 'package:foodpanda_user/widgets/custom_textfield.dart';
import 'package:foodpanda_user/widgets/my_alert_dialog.dart';

class ApplyVoucherScreen extends StatefulWidget {
  static const String routeName = '/apply-voucher-screen';
  final double subtotal;
  final Function(Voucher?) setVoucher;
  const ApplyVoucherScreen(
      {super.key, required this.subtotal, required this.setVoucher});

  @override
  State<ApplyVoucherScreen> createState() => _ApplyVoucherScreenState();
}

class _ApplyVoucherScreenState extends State<ApplyVoucherScreen> {
  TextEditingController queryController = TextEditingController();
  String queryText = '';
  dynamic result;
  VoucherController voucherController = VoucherController();
  bool isLoading = true;
  List<Voucher> vouchers = [];
  List<String> usedVouchers = [];

  getData() async {
    vouchers = await voucherController.fetchSavedVouchers();
    usedVouchers = await voucherController.fetchUsedVouchers();

    isLoading = false;
    setState(() {});
  }

  addVoucherToList(Voucher newVoucher) {
    vouchers.add(newVoucher);
    setState(() {});
  }

  handleAddVoucher() async {
    result = await voucherController.searchVoucher(
      query: queryController.text.trim(),
    );
    if (result.runtimeType == String) {
      showDialog(
          context: context,
          builder: (context) {
            return MyAlertDialog(
                title: 'Voucher cannot be used',
                subtitle: result,
                isOneAction: true,
                action1Name: 'No',
                action2Name: 'Cancel',
                action1Func: () {
                  Navigator.pop(context);
                },
                action2Func: () async {
                  Navigator.pop(context);
                });
          });
    } else {
      addVoucherToList(result);
    }
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        elevation: 0.5,
        title: const Text(
          'Apply a voucher',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: CustomTextField(
                      controller: queryController,
                      labelText: 'Enter a voucher code',
                      onChanged: (value) {
                        setState(
                          () {
                            queryText = value;
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextButton(
                    text: 'Add',
                    onPressed:
                        queryText.trim().isEmpty ? () {} : handleAddVoucher,
                    isDisabled: false,
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300]!.withOpacity(0.7),
              height: 0,
              thickness: 7,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !isLoading && vouchers.isEmpty
                      ? const Column(
                          children: [
                            SizedBox(height: 40),
                            Image(
                              image: AssetImage(
                                'assets/images/voucher_panda.png',
                              ),
                              width: 90,
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(height: 70),
                            Text(
                              'No Vouchers Yet',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'It seems you have no vouchers yet.',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 73),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select a voucher',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vouchers.length,
                                itemBuilder: (context, index) {
                                  final voucher = vouchers[index];
                                  return GestureDetector(
                                    onTap: () {
                                      showVoucherDetailModal(
                                          context: context, voucher: voucher);
                                    },
                                    child: Column(
                                      children: [
                                        ExtendedVoucherCard(
                                          minPrice: voucher.minPrice ?? 0,
                                          currentPrice: widget.subtotal,
                                        ),
                                        VoucherCard(
                                          voucher: voucher,
                                          isApplyMode: true,
                                          setVoucher: widget.setVoucher,
                                          isUsed:
                                              usedVouchers.contains(voucher.id),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
