import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/voucher.dart';
import 'package:foodpanda_user/voucher/controllers/voucher_controller.dart';
import 'package:foodpanda_user/voucher/widgets/sort_modal.dart';
import 'package:foodpanda_user/voucher/widgets/voucher_card.dart';
import 'package:foodpanda_user/voucher/widgets/voucher_detail_modal.dart';
import 'package:foodpanda_user/voucher/widgets/voucher_saving.dart';

class VoucherScreen extends StatefulWidget {
  static const String routeName = '/voucher-screen';
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  VoucherController voucherController = VoucherController();
  String sortBy = 'latest';
  bool isLoading = true;
  List<Voucher> vouchers = [];
  List<String> usedVouchers = [];

  getData() async {
    vouchers = await voucherController.fetchSavedVouchers();
    usedVouchers = await voucherController.fetchUsedVouchers();
    isLoading = false;
    print(usedVouchers);
    setState(() {});
  }

  addVoucherToList(Voucher newVoucher) {
    vouchers.add(newVoucher);
    handleSortByChange(sortBy);
    setState(() {});
  }

  handleSortByChange(choice) {
    if (choice == 'latest') {
      vouchers.sort((b, a) => a.createdDate.compareTo(b.createdDate));
    } else if (choice == 'expiring') {
      vouchers.sort((a, b) => a.expiredDate.compareTo(b.expiredDate));
    } else if (choice == 'minimum') {
      vouchers.sort((a, b) {
        a.minPrice = a.minPrice ?? 0;
        b.minPrice = b.minPrice ?? 0;
        return a.minPrice!.compareTo(b.minPrice!);
      });
    }

    setState(() {
      sortBy = choice;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        elevation: 0.5,
        title: const Text(
          'Vouchers & Offers',
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  VoucherSaving(
                    addVoucherToList: addVoucherToList,
                  ),
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
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                showSortModal(
                                  context: context,
                                  handleApply: (choice) {
                                    handleSortByChange(choice);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: sortBy == 'latest'
                                            ? Colors.white
                                            : scheme.primary,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: sortBy == 'latest'
                                              ? Colors.grey[400]!
                                              : scheme.primary,
                                        )),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          sortBy == 'latest'
                                              ? 'Sort'
                                              : sortBy == 'expiring'
                                                  ? 'Expiring first'
                                                  : sortBy == 'minimum'
                                                      ? 'Lowest minimum order value'
                                                      : 'Sort',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: sortBy == 'latest'
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 20,
                                          color: sortBy == 'latest'
                                              ? Colors.black
                                              : Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () {
                                      handleSortByChange('latest');
                                      setState(() {
                                        sortBy = 'latest';
                                      });
                                    },
                                    child: Text(
                                      'Clear All',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vouchers.length,
                                itemBuilder: (context, index) {
                                  final voucher = vouchers[index];
                                  return GestureDetector(
                                    onTap: () {
                                      showVoucherDetailModal(
                                        context: context,
                                        voucher: voucher,
                                      );
                                    },
                                    child: VoucherCard(
                                      voucher: voucher,
                                      isUsed: usedVouchers.contains(voucher.id),
                                    ),
                                  );
                                }),
                          ],
                        )
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300]!.withOpacity(0.7),
              height: 0,
              thickness: 7,
            ),
          ],
        ),
      ),
    );
  }
}
