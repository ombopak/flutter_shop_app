part of 'pages.dart';

class OrderPage extends StatelessWidget {
  static const routeName = '/orders';
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
