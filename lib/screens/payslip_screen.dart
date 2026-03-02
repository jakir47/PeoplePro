import 'package:animations/animations.dart';
import 'package:peoplepro/models/payslip_line_model.dart';
import 'package:peoplepro/models/payslip_model.dart';
import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({Key? key}) : super(key: key);

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  List<PayslipModel> _payslips = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadPayslips());
  }

  Future<void> loadPayslips() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    _payslips = await UserService.getPayslips();
    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  void showPayslipLinesModal(
      List<PayslipLineModel> lines, PayslipModel payslip) {
    var earnings = lines.where((l) => l.isEarning!).toList();
    var deductions = lines.where((l) => !l.isEarning!).toList();

    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0)),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    opacity: 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                            color:
                                                payslip.salaryType == "Salary"
                                                    ? UserColors.primaryColor
                                                    : Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(4.0)),
                                        child: Text(
                                          payslip.salaryType!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        )),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      child: Text(payslip.name!,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: const Text(
                                            "Salary Period",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          )),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        "${payslip.fromDate!} - ${payslip.toDate!}",
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                      )
                                    ],
                                  )),
                              const SizedBox(height: 2.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          "Gross Amount",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          "Deduction Amount",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          "Net Amount",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87),
                                        )
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                      child: Divider(
                                        height: 1.0,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Utils.formatPrice(
                                              payslip.grossAmount!),
                                          style: const TextStyle(
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          Utils.formatPrice(
                                              payslip.deductionAmount!),
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                        Text(
                                          Utils.formatPrice(payslip.netAmount!),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: UserColors.primaryColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  payslip.inWord!,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          if (earnings.isNotEmpty)
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Earning",
                                        style: TextStyle(
                                            color: UserColors.primaryColor,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        "Amount",
                                        style: TextStyle(
                                            color: UserColors.primaryColor,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var line = earnings[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    line.headName!,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .grey.shade900),
                                                  ),
                                                  Text(
                                                    Utils.formatPrice(
                                                        line.amount!),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .grey.shade900),
                                                  ),
                                                ])
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: earnings.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        height: 1.0,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4.0, left: 8.0, right: 8.0),
                                  child: Container(
                                    color: Colors.grey.shade400,
                                    height: 1.0,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    Utils.formatPrice(payslip.grossAmount!),
                                    style: TextStyle(
                                        color: UserColors.primaryColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          if (deductions.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 20.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "Deduction",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        "Amount",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var line = deductions[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    line.headName!,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .grey.shade900),
                                                  ),
                                                  Text(
                                                    Utils.formatPrice(
                                                        line.amount!),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .grey.shade900),
                                                  ),
                                                ])
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: deductions.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        height: 1.0,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4.0, left: 8.0, right: 8.0),
                                  child: Container(
                                    color: Colors.grey.shade400,
                                    height: 1.0,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    Utils.formatPrice(payslip.deductionAmount!),
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            )
                        ])),
                    const SizedBox(
                      height: 16.0,
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: UserColors.primaryColor),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 42.0, vertical: 0.0),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  buildListItem(PayslipModel payslip) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          border: Border.all(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: payslip.salaryType == "Salary"
                            ? UserColors.primaryColor
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      payslip.salaryType!,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12.0),
                    )),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: Text(payslip.name!,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6.0),
          Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "${payslip.salaryType!} Period",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      )),
                  const SizedBox(width: 8.0),
                  Text(
                    "${payslip.fromDate!} - ${payslip.toDate!}",
                    style: TextStyle(color: Colors.grey.shade700),
                  )
                ],
              )),
          const SizedBox(height: 6.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Gross Amount",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    Text(
                      "Deduction Amount",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    Text(
                      "Net Amount",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider(
                    height: 1.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Utils.formatPrice(payslip.grossAmount!),
                      style: const TextStyle(color: Colors.black87),
                    ),
                    Text(
                      Utils.formatPrice(payslip.deductionAmount!),
                      style: const TextStyle(color: Colors.red),
                    ),
                    Text(
                      Utils.formatPrice(payslip.netAmount!),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: UserColors.primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 2.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.white.withOpacity(0.5),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              payslip.inWord!,
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 32.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                var lines =
                    await UserService.getPayslipLine(payslip.payrollId!);
                showPayslipLinesModal(lines, payslip);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                backgroundColor: Colors.grey[200],
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
              ),
              child: Text(
                'View ${payslip.salaryType!} Details',
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Payslip",
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var payslip = _payslips[index];
              return buildListItem(payslip);
            },
            itemCount: _payslips.length,
            separatorBuilder: ((context, index) {
              return const SizedBox(height: 8.0);
              // Divider(height: 1, color: Colors.grey.withOpacity(0.5));
            }),
          ),
        ),
      ),
    );
  }
}
