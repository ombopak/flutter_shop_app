part of 'pages.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewPage extends StatefulWidget {
  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<ProductProvider>(context).fetchAndSetProducts(); didnt work

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<ProductProvider>(context).fetchAndSetProducts(); didnt work either because its need context.
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorites',
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<CartProvider>(
            builder: (_, cart, chld) => Badge(
              child: chld!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartPage.routeName);
                },
                icon: Icon(Icons.shopping_cart)),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorites),
    );
  }
}
