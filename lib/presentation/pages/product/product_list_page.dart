import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _selectedCategory = 'All';
  String _sortBy = 'Popularity';
  
  // Mock data
  final List<String> categories = [
    'All',
    'Electronics',
    'Clothing',
    'Home',
    'Beauty',
  ];
  
  final List<String> sortOptions = [
    'Popularity',
    'Price: Low to High',
    'Price: High to Low',
    'Newest',
  ];
  
  final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Wireless Headphones',
      'price': 99.99,
      'image': 'https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'discount': 15,
      'category': 'Electronics',
    },
    {
      'id': '2',
      'name': 'Smart Watch',
      'price': 199.99,
      'image': 'https://images.pexels.com/photos/437037/pexels-photo-437037.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'category': 'Electronics',
    },
    {
      'id': '3',
      'name': 'Laptop Pro',
      'price': 1299.99,
      'image': 'https://images.pexels.com/photos/1229861/pexels-photo-1229861.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'discount': 10,
      'category': 'Electronics',
    },
    {
      'id': '4',
      'name': 'Smartphone X',
      'price': 899.99,
      'image': 'https://images.pexels.com/photos/47261/pexels-photo-47261.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'category': 'Electronics',
    },
    {
      'id': '5',
      'name': 'Cotton T-Shirt',
      'price': 24.99,
      'image': 'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'category': 'Clothing',
    },
    {
      'id': '6',
      'name': 'Denim Jacket',
      'price': 89.99,
      'image': 'https://images.pexels.com/photos/1082529/pexels-photo-1082529.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'discount': 20,
      'category': 'Clothing',
    },
  ];
  
  List<Map<String, dynamic>> get filteredProducts {
    // First apply category filter
    List<Map<String, dynamic>> result = _selectedCategory == 'All'
        ? List.from(products)
        : products.where((p) => p['category'] == _selectedCategory).toList();
    
    // Then apply sorting
    switch (_sortBy) {
      case 'Price: Low to High':
        result.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
        break;
      case 'Price: High to Low':
        result.sort((a, b) => (b['price'] as double).compareTo(a['price'] as double));
        break;
      case 'Newest':
        // In a real app, this would sort by date
        break;
      case 'Popularity':
      default:
        // In a real app, this would sort by popularity metric
        break;
    }
    
    return result;
  }
  
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter & Sort',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Categories
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      return ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  // Sort by
                  Text(
                    'Sort by',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: sortOptions.map((option) {
                      return ChoiceChip(
                        label: Text(option),
                        selected: _sortBy == option,
                        onSelected: (selected) {
                          setState(() {
                            _sortBy = option;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        this.setState(() {});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category chips
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: _selectedCategory == categories[index],
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = categories[index];
                      });
                    },
                  ),
                );
              },
            ),
          ),
          
          // Current filter info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredProducts.length} products',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showFilterBottomSheet,
                  icon: const Icon(Icons.sort),
                  label: Text('Sort: $_sortBy'),
                ),
              ],
            ),
          ),
          
          // Product grid
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text('No products found'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        id: product['id'],
                        name: product['name'],
                        price: product['price'],
                        imageUrl: product['image'],
                        discount: product['discount'],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}