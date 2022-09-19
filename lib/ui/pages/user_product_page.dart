part of 'pages.dart';

class UserProductPage extends StatelessWidget {
  static const routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'You Products',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.routeName, arguments: 'newProduct');
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                productsData.items[i].id,
                productsData.items[i].title,
                productsData.items[i].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}