part of 'pages.dart';

class OrderPage extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
    ).then((_) =>
        Provider.of<OrderProvider>(context, listen: false).fetchAndSetOrders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Order'),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (ctx, i) => OrderItems(orderData.orders[i]),
        ));
  }
}
