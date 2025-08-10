import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/product_card.dart';

class ContentRow extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final VoidCallback? onViewAll;
  final bool showViewAll;

  const ContentRow({
    super.key,
    required this.title,
    required this.items,
    this.onViewAll,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),
              if (showViewAll && onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('View All'),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: 140,
                  child: ProductCard(
                    id: item['id'] as String,
                    name: item['name'] as String,
                    price: item['price'] as double,
                    imageUrl: item['image'] as String,
                    discount: item['discount'] as int?,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
