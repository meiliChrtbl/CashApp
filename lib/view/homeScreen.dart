import 'package:uasapp/component/atmCard.dart';
import 'package:uasapp/component/operationCard.dart';
import 'package:uasapp/view/transferMoney.dart';
import 'package:flutter/material.dart';
import 'package:uasapp/component/transhistory.dart';
import 'package:uasapp/controller/databaseHelper.dart';
import 'package:uasapp/data/cardData.dart';
import 'package:uasapp/model/constant.dart';
import 'package:uasapp/view/addCardDetails.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper _dbhelper = new DatabaseHelper();
  String nama = "Hello! ";
  String avatar = "H";
  DateTime currentTime = DateTime.now();
  List<String> greetingList = [
    "Good Morning",
    "Good AfterNoon",
    "Good Evening",
    "Good Night"
  ];
  late String greeting;

  late List<CardData> _list;

  int current = 0;
  List datas = ["Money Transfer", "Bank Withdraw", "Insights Tracking"];

  void getGreeting() {
    if (currentTime.hour < 12) {
      greeting = greetingList[0];
    } else if (currentTime.hour >= 12 && currentTime.hour < 18) {
      greeting = greetingList[1];
    } else if (currentTime.hour >= 18 && currentTime.hour < 20) {
      greeting = greetingList[2];
    } else if (currentTime.hour >= 20 && currentTime.hour < 24) {
      greeting = greetingList[3];
    }
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    _list = CardData.cardDataList;

    getGreeting();

    // Wait for the database to be fully initialized before querying
    Future.delayed(Duration.zero, () {
      _loadTransactionDetails();
    });

    super.initState();
  }

  void _loadTransactionDetails() async {
    try {
      final transactionDetails = await _dbhelper.getTransactionDetatils();
      // Handle the loaded transaction details as needed
    } catch (e) {
      print('Error loading transaction details: $e');
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mgBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: mgDefaultPadding),
          child: Icon(
            Icons.menu,
            color: mgMenuColor,
            size: 35,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: mgDefaultPadding),
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade200,
              child: Text(avatar),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: mgDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey,
                            fontSize: 18,
                          )),
                  Text(nama,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: mgBlackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          )),
                ],
              ),
            ),
            SizedBox(height: 20),

            //<<<<<<<<<<< ATM Card Section >>>>>>>>>>>>>>//
            Container(
              height: 199,
              child: FutureBuilder(
                initialData: [],
                future: _dbhelper.getUserDetails(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.only(left: mgDefaultPadding, right: 6),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => {
                                nama = snapshot.data![index].nama,
                                avatar = snapshot.data![index].nama[0],
                              });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TransferMoney(
                                currentBalance: snapshot.data?[index]?.totalAmount ?? 0,
                                currentCustomerId: snapshot.data![index].id ?? 0,
                                currentUserCardNumebr: snapshot.data![index].cardNumber,
                                senderName: snapshot.data![index].nama,
                              ),
                            ),
                          );
                        },
                        child: UserATMCard(
                          cardNumber: snapshot.data![index].cardNumber,
                          cardExpiryDate: snapshot.data![index].cardExpiry,
                          totalAmount: snapshot.data?[index]?.totalAmount ?? 0,
                          gradientColor: _list[index].mgPrimaryGradient, cardHolderName: '',
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            //<<<<<<<<<<<< Operation section >>>>>>>>>>>>>//
            Padding(
              padding: const EdgeInsets.only(
                  left: mgDefaultPadding,
                  bottom: 13,
                  top: 29,
                  right: mgDefaultPadding),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Operation",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: map<Widget>(datas, (index, selected) {
                        return Container(
                          margin: const EdgeInsets.only(right: 3),
                          height: 9,
                          width: 9,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: current == index
                                ? mgBlueColor
                                : Colors.grey[400],
                          ),
                        );
                      }),
                    ),
                  ]),
            ),
            Container(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: 3,
                padding: const EdgeInsets.only(left: mgDefaultPadding),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        current = index;
                      });
                    },
                    child: OperationCard(
                      operation: datas[index],
                      operationIcon: operationIcon[index],
                      isSelected: current == index,
                    ),
                  );
                },
              ),
            ),

            // <<<<<<<<< Transaction Section >>>>>>>>>>>> //
            Padding(
              padding: const EdgeInsets.only(
                  left: mgDefaultPadding,
                  bottom: 13,
                  top: 29,
                  right: mgDefaultPadding),
              child: Text(
                "Transaction Histories",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),

          Container(
            child: FutureBuilder(
              initialData: [],
              future: _dbhelper.getTransactionDetatils(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Text('No transaction data available.');
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: mgDefaultPadding),
                    itemBuilder: (context, index) {
                      return TransactionHistroy(
                        isTransfer: true,
                        customerName: snapshot.data![index].nama,
                        transferAmount: snapshot.data![index].transactionAmount,
                        senderName: snapshot.data![index].senderName,
                        avatar: snapshot.data![index].nama[0],
                      );
                    },
                  );
                }
              },
            ),
          ),


          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: mgBlueColor,
        elevation: 15,
        child: Container(
          height: 50,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mgBlueColor,
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 100),
                  transitionsBuilder:
                      (context, animation, animationTime, child) {
                    animation = CurvedAnimation(
                        parent: animation, curve: Curves.easeInOutCubic);
                    return ScaleTransition(
                      scale: animation,
                      alignment: Alignment.bottomCenter,
                      child: child,
                    );
                  },
                  pageBuilder: (context, animation, animationTime) {
                    return AddCardDetails();
                  }));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}