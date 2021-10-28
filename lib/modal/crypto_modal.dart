class CryptoData{
  CryptoData({required this.dataList});
  final List<Data> dataList; 

  factory CryptoData.fromJson(Map<String, dynamic> data){
    final crypto = data['data'] as List<dynamic>; 
    final dataList = crypto.map((x) => Data.fromJson(x))
    .toList();
    return CryptoData(dataList: dataList);
  }
}

class Data{
  Data({required this.name, required this.symbol, required this.quote});
  final String name;
  final String symbol;
  final Quote quote;


  factory Data.fromJson(Map<String, dynamic> data){
    final name = data['name'] as String;
    final symbol = data['symbol'] as String;
    final quote = Quote.fromJson(data['quote']);
    return Data(name: name, symbol: symbol, quote: quote);
  }

}

class Quote{
  Quote({required this.pkr});
  final Pkr pkr;

  factory Quote.fromJson(Map<String, dynamic> data){
    final pkr = Pkr.fromJson(data['USD']);
    return Quote(pkr: pkr); 
  }

}

class Pkr{
  Pkr({required this.price, required this.percentChange24h });
  final double price;
  final double percentChange24h;

  factory Pkr.fromJson(Map<String, dynamic> data){
    final price = data['price'] as double;
    
    final percentChange24h = data['percent_change_24h'] as double;
  
    return Pkr(price: price, percentChange24h: percentChange24h);
  }
}