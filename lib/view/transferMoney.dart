import 'package:uasapp/component/customerList.dart';
import 'package:uasapp/model/constant.dart';
import 'package:uasapp/controller/databaseHelper.dart';
import 'package:uasapp/view/payment.dart';
import 'package:flutter/material.dart';

class TransferMoney extends StatefulWidget {
  final double currentBalance;
  final int currentCustomerId;
  final String currentUserCardNumebr, senderName;

  TransferMoney({
    required this.currentBalance,
    required this.currentCustomerId,
    required this.senderName,
    required this.currentUserCardNumebr,
  });

  @override
  _TransferMoneyState createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  double _currentBalance = 0.0;
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _currentBalance = widget.currentBalance;
  }

  @override
  void didUpdateWidget(covariant TransferMoney oldWidget) {
    // This method is called whenever the parent widget changes
    super.didUpdateWidget(oldWidget);
    if (widget.currentBalance != _currentBalance) {
      setState(() {
        _currentBalance = widget.currentBalance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer Money"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: mgDefaultPadding),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      "Current Balance",
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Rp $_currentBalance",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _currentBalance == widget.currentBalance
                                ? Colors.green
                                : Colors.red,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: FutureBuilder(
                initialData: [],
                future: _dbHelper.getUserDetailsList(widget.currentCustomerId),
                builder: (context, snapshot) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: mgDefaultPadding),
                    itemCount: snapshot.data?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Payment(
                              customerAvatar:
                                  snapshot.data![index].nama[0], // Handle null
                              customerName: snapshot.data![index].nama,
                              senderName: widget.senderName,
                              customerAccountNumber:
                                  snapshot.data![index].cardNumber,
                              currentUserCardNumber:
                                  widget.currentUserCardNumebr,
                              currentCustomerId: widget.currentCustomerId,
                              currentUserBalance: widget.currentBalance,
                              transferTouserId: snapshot
                                  .data![index].transactionId, // Handle null
                              tranferTouserCurrentBalance:
                                  snapshot.data![index].totalAmount,
                            ),
                          ),
                        ),
                        child: CustomerList(
                          customerName: snapshot.data![index].nama,
                          currentBalance: snapshot.data![index].totalAmount,
                          avatar: snapshot.data![index].nama[0],
                          transactionDate:
                              '',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}