import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/models/cart.dart';
import 'package:provider_shopper/models/catalog.dart';

class MyCatalog extends StatelessWidget {
  const MyCatalog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _MyAppBar(),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 12,
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _MyListItem(index),
              // childCount: 20,
              )),
        ],
      ),
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  const _MyListItem(this.index);

  @override
  Widget build(BuildContext context) {
    // 用provider 获得item
    // 根据CatalogModel获得item
    var item = context
        .select<CatalogModel, Item>((catalog) => catalog.getByPosition(index));
    var textTheme = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: item.color,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(child: Text(item.name, style: textTheme)),
            const SizedBox(width: 24),
            _AddButton(item: item)
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final Item item;

  const _AddButton({required this.item});

  @override
  Widget build(BuildContext context) {
    // 获取购物车状态 判断当前item是否在购物车里面
    var isInCart =
        context.select<CartModel, bool>((cart) => cart.items.contains(item));

    return TextButton(
        onPressed: isInCart
            ? null
            : () {
                //context.read<T>()方法不会在值变化时让 widget 重新构建， 并且不能在 StatelessWidget.build 和 State.build 内调用.
                // 换句话说，它可以在除了这两个方法以外的任意位置调用
                // 获取购物车状态并添加新商品
                var cart = context.read<CartModel>();
                cart.add(item);
              },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Theme.of(context).primaryColor;
            }
            return null; // Defer to the widget's default.
          }),
        ),
        child: isInCart
            ? const Icon(
                Icons.check,
                semanticLabel: 'ADDED',
              )
            : const Text('ADD'));
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        'Catalog',
        style: Theme.of(context).textTheme.displayLarge,
      ),
      floating: true,
      actions: [
        IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart))
      ],
    );
  }
}
