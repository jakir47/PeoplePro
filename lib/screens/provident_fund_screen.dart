import 'package:peoplepro/models/provident_fund_model.dart';
import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class ProvidentFundScreen extends StatefulWidget {
  const ProvidentFundScreen({Key? key}) : super(key: key);

  @override
  State<ProvidentFundScreen> createState() => _ProvidentFundScreenState();
}

class _ProvidentFundScreenState extends State<ProvidentFundScreen> {
  List<ProvidentFundModel> _providentFunds = [];
  double _totalAmount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadProvidentFunds());
  }

  Future<void> loadProvidentFunds() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    _providentFunds = await UserService.getProvidentFunds();

    for (var i = 0; i < _providentFunds.length; i++) {
      _totalAmount += _providentFunds[i].amount!;
    }

    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  buildListItem(ProvidentFundModel providentFund) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                providentFund.salaryPeriod!,
                style: TextStyle(color: Colors.black.withOpacity(0.7)),
              ),
              Text(
                Utils.formatPrice(providentFund.amount!),
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Provident Fund",
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12, top: 12, bottom: 4.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(2)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Salary Period",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Amount",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var providentFund = _providentFunds[index];
                    return buildListItem(providentFund);
                  },
                  itemCount: _providentFunds.length,
                  separatorBuilder: ((context, index) {
                    return const SizedBox(height: 1.0);
                    // Divider(height: 1, color: Colors.grey.withOpacity(0.5));
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12, bottom: 12, top: 4.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      Utils.formatPrice(_totalAmount),
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
