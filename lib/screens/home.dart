// ignore_for_file: must_be_immutable

import 'package:crypto_currency_app/modal/crypto_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  Future<List<Data>>? data;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Data>? data;
  final List<MaterialColor> _colors = [Colors.pink, Colors.purple, Colors.cyan, Colors.indigo];
  @override
  void initState() {
    super.initState();
    loadCryptoData();
  }

  Future<List<Data>> loadCryptoData() async {
    final url = Uri.parse(
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=5e282fd6-0b34-4186-883e-445e9a209171&convert=USD&start=1");
    try {
      var response = await http.get(url);
      var decodeJson = jsonDecode(response.body);
      var cryptoData = CryptoData.fromJson(decodeJson);
      data = cryptoData.dataList;
      // print(data![0].name);
      return cryptoData.dataList;
    } on Exception catch (error) {
      // print(error);
      throw Exception(error);
    }
  }

  handleDecimals(price) {
    return price < 0 ? price.toStringAsFixed(5) : price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("CryptoCurrency", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Markets",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 26.0,
                    fontFamily: "Nunito"),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                        // border: Border.all(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.black.withOpacity(0.1)),
                    child: Center(
                      child: Text(
                        "All",
                        style: headerTextStyle,
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                        // border: Border.all(),

                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.black.withOpacity(0.1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hot",
                          style: headerTextStyle,
                        ),
                        const Icon(Icons.arrow_downward_rounded)
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: FutureBuilder(
                  future: loadCryptoData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.yellow.shade800)),
                          child: const Text(
                            "Oops! Failed to connect server",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                        itemBuilder: (context, index) {
                          final double price = double.parse(
                              handleDecimals(data![index].quote.pkr.price));
                          final double percentChange24h = double.parse(
                              handleDecimals(
                                  data![index].quote.pkr.percentChange24h));
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _colors[index % _colors.length],
                              child: Text(data![index].symbol[0], style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                            title: Text(
                              data![index].symbol,
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(data![index].name,
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 16.0)),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("\$${price.toString()}",
                                    style: const TextStyle(
                                        fontFamily: "Nunito",
                                        color: Colors.black,
                                        fontSize: 18.0)),
                                Container(
                                    color: percentChange24h < 0
                                        ? Colors.red
                                        : Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0, vertical: 3.0),
                                    child: Text(
                                        "${percentChange24h.toString()}%",
                                        style: const TextStyle(
                                            fontFamily: "Nunito",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14.0)))
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: data!.length);
                  }
                  return Container();
                
                    }
              )
              )],
          )),
    );
  }

  final TextStyle headerTextStyle = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: "Nunito");
}
