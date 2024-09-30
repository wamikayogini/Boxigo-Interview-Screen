// lib/inventory_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<List<Inventory>> _inventoryList;

  @override
  void initState() {
    super.initState();
    _inventoryList = ApiService().fetchInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
      ),
      body: FutureBuilder<List<Inventory>>(
        future: _inventoryList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final inventories = snapshot.data!;
            return ListView.builder(
              itemCount: inventories.length,
              itemBuilder: (context, index) {
                final inventory = inventories[index];
                return ExpansionTile(
                  title: Text(inventory.displayName),
                  children: inventory.categories.map((category) {
                    return ExpansionTile(
                      title: Text(category.displayName),
                      children: category.items.map((item) {
                        return ListTile(
                          title: Text(item.displayName),
                          subtitle: Text(item.typeOptions.join(', ')),
                          trailing: Text('Qty: ${item.qty}'),
                        );
                      }).toList(),
                    );
                  }).toList(),
                );
              },
            );
          }
        },
      ),
    );
  }
}
