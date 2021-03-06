import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/library/providers/cart_provider.dart'
    show CartProvider;
import 'package:shop_app/library/providers/orders_provider.dart';
import 'package:shop_app/features/cart/cart_item.dart' as CartItemView;

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (ctx, cartData, child) => Column(
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cartData.totalAmount}',
                        style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title!.color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cartData: cartData),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) => CartItemView.CartItem(
                  cartData.items.keys.toList()[index],
                  cartData.items.values.toList()[index].id,
                  cartData.items.values.toList()[index].price,
                  cartData.items.values.toList()[index].quantity,
                  cartData.items.values.toList()[index].title,
                ),
                itemCount: cartData.itemCount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartData,
  }) : super(key: key);

  final CartProvider cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : TextButton(
            onPressed: widget.cartData.totalAmount <= 0
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<OrderProvider>(context, listen: false)
                        .addOrder(widget.cartData.items.values.toList(),
                            widget.cartData.totalAmount);
                    widget.cartData.clear();
                    setState(() {
                      _isLoading = false;
                    });
                  },
            child: Text(
              'Order Now',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ));
  }
}
