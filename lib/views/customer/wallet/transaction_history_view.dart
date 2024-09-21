import 'package:flutter/material.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class TransactionHistoryView extends StatelessWidget {
  static const String routerName = 'transactionHistory';
  static const String routerPath = '/transactionHistory';
  const TransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).wallet,
        ),
        backgroundColor: AppStyle.ligthGrey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppStyle.white, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: AppStyle.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 1
                          ),
                        ]
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: AppStyle.white,
                            radius: 24,
                            child: Image.asset('assets/car.jpg', height: 50, width: 50),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text('Urujara', 
                                        style: TextStyle(
                                          color: AppStyle.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Bs. 2', 
                                      style: TextStyle(
                                        color: AppStyle.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text('01/09/24 12:00', 
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppStyle.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: 15,
                  physics: const NeverScrollableScrollPhysics(),
                  primary: true,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}