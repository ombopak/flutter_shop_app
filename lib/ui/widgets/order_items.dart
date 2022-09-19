part of 'widgets.dart';

class OrderItems extends StatefulWidget {
  final OrderItem order;

  OrderItems(this.order);

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 15,
              ),
              height: min(
                widget.order.products.length * 20.00 + 10,
                100,
              ),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
