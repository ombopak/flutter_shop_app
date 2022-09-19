part of 'pages.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'You Cart',
        ),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '\$ ${cart.totalAmout.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .headline6!
                            .color),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                FlatButton(
                  onPressed: () {
                    Provider.of<OrderProvider>(context, listen: false)
                        .addOrder(cart.items.values.toList(), cart.totalAmout);
                    cart.clear();
                  },
                  child: Text(
                    'ORDER NOW',
                  ),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, i) => CartItemList(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity),
          ),
        ),
      ]),
    );
  }
}
