Map<String, String> creditDebit = { 'name' : 'Credit or Debit Card' };

List<Map<String, String>> eWalletVendors = [
  <String, String>{ "code" : "201", "image" : "tng", "name" : "Touch 'n Go"},
  <String, String>{ "code" : "202", "image" : "boost", "name" : "Boost"},
  <String, String>{ "code" : "203", "image" : "grabpay", "name" : "GrabPay"},
];

List<Map<String, String>> bankingVendors = [
  <String, String>{ "code" : "301", "image" : "ambank", "name" : "AmBank"},
  <String, String>{ "code" : "302", "image" : "bislam", "name" : "Bank Islam"},
  <String, String>{ "code" : "303", "image" : "brakyat", "name" : "Bank Rakyat"},
  <String, String>{ "code" : "304", "image" : "mybsn", "name" : "MyBSN"},
  <String, String>{ "code" : "305", "image" : "public", "name" : "Public Bank"},
  <String, String>{ "code" : "306", "image" : "rhb", "name" : "RHB Bank"},
];

//ListView builder
List<Map<String,String>> payMethodsListTileElements = [
  <String,String>{ 'code' : '1' , 'icon' : 'Icons.credit_card' , 'name' : 'Credit or debit Card' },
  <String,String>{ 'code' : '2' , 'icon' : 'Icons.account_balance_wallet' , 'name' : 'Third-party eWallet' },
  <String,String>{ 'code' : '3' , 'icon' : 'Icons.account_balance' , 'name' : 'Online Banking' },
];

Map<String, String>? getPaymentMethodMapFromCode(String code) {
  List<Map<String, String>> relevantList = [];
  Map<String, String> relevantMethod = Map<String, String>();

  String codePrefix = code.substring(0,1);
  int codeSuffix = int.parse(code.substring(2,3));

  print('hello');
  print(codePrefix);
  print(codeSuffix);

  switch(codePrefix) {
    case '1': {
      relevantMethod = creditDebit;
    }
      break;
    case '2': {
      relevantList = eWalletVendors;
      relevantMethod = relevantList[codeSuffix-1];
    }
      break;
    case '3': {
      relevantList = bankingVendors;
      relevantMethod = relevantList[codeSuffix-1];
    }
      break;
    default: {
      print('failget');
    }
      break;
  }

  print('done pm');
  return relevantMethod;
}