import '../models/currency.dart';

class CurrencyRepository {
  static List<Currency> table = [
    Currency(
      icon: 'assets/images/bitcoin.png',
      name: 'Bitcoin',
      acronym: 'BTC',
      price: 164603.00,
    ),
    Currency(
      icon: 'assets/images/ethereum.png',
      name: 'Ethereum',
      acronym: 'ETH',
      price: 9716.00,
    ),
    Currency(
      icon: 'assets/images/xrp.png',
      name: 'XRP',
      acronym: 'XRP',
      price: 3.34,
    ),
    Currency(
      icon: 'assets/images/cardano.png',
      name: 'Cardano',
      acronym: 'ADA',
      price: 6.32,
    ),
    Currency(
      icon: 'assets/images/usdcoin.png',
      name: 'USD Coin',
      acronym: 'USDC',
      price: 5.02,
    ),
    Currency(
      icon: 'assets/images/litecoin.png',
      name: 'Litecoin',
      acronym: 'LTC',
      price: 669.93,
    ),
  ];
}
