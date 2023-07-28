// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:foodpanda_user/shop_details/widgets/text_tag.dart';
import 'package:foodpanda_user/widgets/my_snack_bar.dart';
import 'package:intl/intl.dart';

import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/voucher.dart';

class VoucherCard extends StatelessWidget {
  final Voucher voucher;
  bool isApplyMode;
  Function(Voucher?)? setVoucher;
  bool isCartMode;
  bool isApplied;
  double? subtotal;
  bool isUsed;
  VoucherCard({
    Key? key,
    required this.voucher,
    this.isApplyMode = false,
    this.isCartMode = false,
    this.isApplied = false,
    this.isUsed = false,
    this.setVoucher,
    this.subtotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double discountPrice = subtotal != null
        ? voucher.discountPrice != null
            ? voucher.discountPrice!
            : voucher.discountPercentage! / 100 * subtotal!
        : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: TicketPainter(
          borderColor: Colors.grey[300]!,
          bgColor: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  children: [
                    const Image(
                      width: 35,
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/images/percentage_icon.png'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            voucher.name,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          !isApplied
                              ? Row(
                                  children: [
                                    Text(
                                      voucher.discountPrice != null
                                          ? '\$ ${voucher.discountPrice}'
                                          : '${NumberFormat("###.##", "en_US").format(voucher.discountPercentage)}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      Icons.info_outline,
                                      color: scheme.primary,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      voucher.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  '- \$ ${NumberFormat("###.##", "en_US").format(discountPrice)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: scheme.primary,
                                    fontSize: 12,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    isUsed
                        ? TextTag(
                            text: 'Used',
                            backgroundColor: scheme.primary,
                            textColor: Colors.white,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !isApplied
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey[400]!,
                            ),
                          ),
                          child: Text(
                            '${voucher.minPrice != null ? "Min. order \$ ${NumberFormat("###.##", "en_US").format(voucher.minPrice)}" : "No min. order"} · Use by ${DateFormat('d MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(voucher.expiredDate))}',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12,
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Icon(
                              Icons.check_circle_sharp,
                              color: Colors.green[800],
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Voucher applied!',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green[800],
                              ),
                            )
                          ],
                        ),
                  GestureDetector(
                    onTap: setVoucher == null
                        ? () {}
                        : () {
                            if (isCartMode) {
                              setVoucher!(null);
                            } else {
                              if (!isUsed) {
                                setVoucher!(voucher);
                                Navigator.pop(context);
                              } else {
                                openSnackbar(
                                    context,
                                    'This voucher already been used!',
                                    scheme.primary);
                              }
                            }
                          },
                    child: Text(
                      isApplyMode
                          ? 'Apply'
                          : isCartMode
                              ? 'Remove'
                              : 'Details',
                      style: TextStyle(
                        fontSize: 15,
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TicketPainter extends CustomPainter {
  final Color borderColor;
  final Color bgColor;

  static const _cornerGap = 10.0;
  static const _cutoutRadius = 8.0;
  static const _cutoutDiameter = _cutoutRadius * 2;

  TicketPainter({required this.bgColor, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final maxWidth = size.width;
    final maxHeight = size.height;

    final cutoutStartPos = maxHeight / 2 + _cutoutRadius;
    final leftCutoutStartY = cutoutStartPos;
    final rightCutoutStartY = cutoutStartPos - _cutoutDiameter;
    final dottedLineY = cutoutStartPos - _cutoutRadius;
    double dottedLineStartX = _cutoutRadius + 10;
    final double dottedLineEndX = maxWidth - _cutoutRadius - 10;
    const double dashWidth = 8;
    const double dashSpace = 4;

    final paintBg = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = bgColor;

    final paintBorder = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = borderColor;

    final paintDottedLine = Paint()
      ..color = borderColor.withOpacity(0.7)
      ..strokeWidth = 1.2;

    var path = Path();

    path.moveTo(_cornerGap, 0);
    path.lineTo(maxWidth - _cornerGap, 0);
    _drawCornerArc(path, maxWidth, _cornerGap);
    path.lineTo(maxWidth, rightCutoutStartY);
    _drawCutout(path, maxWidth, rightCutoutStartY + _cutoutDiameter);
    path.lineTo(maxWidth, maxHeight - _cornerGap);
    _drawCornerArc(path, maxWidth - _cornerGap, maxHeight);
    path.lineTo(_cornerGap, maxHeight);
    _drawCornerArc(path, 0, maxHeight - _cornerGap);
    path.lineTo(0, leftCutoutStartY);
    _drawCutout(path, 0.0, leftCutoutStartY - _cutoutDiameter);
    path.lineTo(0, _cornerGap);
    _drawCornerArc(path, _cornerGap, 0);

    canvas.drawPath(path, paintBg);
    canvas.drawPath(path, paintBorder);

    while (dottedLineStartX < dottedLineEndX) {
      canvas.drawLine(
        Offset(dottedLineStartX, dottedLineY),
        Offset(dottedLineStartX + dashWidth, dottedLineY),
        paintDottedLine,
      );
      dottedLineStartX += dashWidth + dashSpace;
    }
  }

  _drawCutout(Path path, double startX, double endY) {
    path.arcToPoint(
      Offset(startX, endY),
      radius: const Radius.circular(_cutoutRadius),
      clockwise: false,
    );
  }

  _drawCornerArc(Path path, double endPointX, double endPointY) {
    path.arcToPoint(
      Offset(endPointX, endPointY),
      radius: const Radius.circular(_cornerGap),
    );
  }

  @override
  bool shouldRepaint(TicketPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TicketPainter oldDelegate) => false;
}
