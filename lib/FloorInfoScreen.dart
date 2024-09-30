import 'package:flutter/material.dart';


class FloorInfoScreen extends StatelessWidget {
  final Map<String, dynamic> apiData;
  final Map<String, dynamic> oldHouseDetails; // Added oldHouseDetails
  final Map<String, dynamic> newHouseDetails; // Added newHouseDetails

  FloorInfoScreen({
    required this.apiData,
    required this.oldHouseDetails,
    required this.newHouseDetails,
  });

  @override
  Widget build(BuildContext context) {
    // Extracting additional info safely
    String oldHouseAdditionalInfo = apiData['old_house_additional_info'] ?? 'No additional info';
    String newHouseAdditionalInfo = apiData['new_house_additional_info'] ?? 'No additional info';
    String totalItems = apiData['total_items'] ?? 'N/A';
    String status = apiData['status'] ?? 'N/A';
    String orderDate = apiData['order_date'] ?? 'N/A';
    String dateCreated = apiData['date_created'] ?? 'N/A';
    String dateOfComplete = apiData['date_of_complete']?.toString() ?? 'Not completed';
    String dateOfCancel = apiData['date_of_cancel']?.toString() ?? 'Not canceled';
    String estimateStatus = apiData['estimate_status'] ?? 'N/A';
    String customStatus = apiData['custom_status'] ?? 'N/A';
    String estimateComparison = apiData['estimate_comparison']?.toString() ?? 'N/A';
    String estimateAmount = apiData['estimateAmount']?.toString() ?? 'N/A';
    String orderReviewed = apiData['order_reviewed'] ?? '0';
    String callBack = apiData['call_back'] ?? '0';
    String moveDateFlexible = apiData['move_date_flexible'] ?? '0';

    // New fields
    String storageItems = apiData['storage_items']?.toString() ?? 'No storage items';
    String successfulPayments = (apiData['successfulPayments'] as List).isNotEmpty
        ? apiData['successfulPayments'].toString()
        : 'No successful payments';

    // Extract address details
    Map<String, dynamic> fromAddress = apiData['from_address'] ?? {};
    Map<String, dynamic> toAddress = apiData['to_address'] ?? {};

    // Updated fromAddress with first name and last name
    String fromFullName = "${fromAddress['firstName']} ${fromAddress['lastName']}".trim();
    String fromAddressString = "${fromAddress['fromAddress']}, ${fromAddress['fromCity']}, ${fromAddress['fromState']} - ${fromAddress['pincode']}";

    // Added full name for the toAddress
    String toFullName = "${toAddress['firstName']} ${toAddress['lastName']}".trim();
    String toAddressString = "${toAddress['toAddress']}, ${toAddress['toCity']}, ${toAddress['toState']} - ${toAddress['pincode']}";

    // Custom items details
    String customItemsUnits = apiData['customItems']?['units'] ?? 'N/A';
    List<dynamic> customItems = apiData['customItems']?['items'] ?? [];

    // New service type and storage type fields
    String serviceType = apiData['service_type'] ?? 'N/A';
    String storageType = apiData['storage_type'] ?? 'N/A';

    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Image.asset('assets/arrow.png', height: 25, width: 20), // Use the arrow image
            onPressed: () {
              // Handle back navigation
              Navigator.of(context).pop();
            },
          ),
          title: Text('New Leads'),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    // Notification functionality
                  },
                ),
                Positioned(
                  right: 10,
                  top: 2,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 14,
                    ),
                    child: Center(
                      child: Text(
                        '1', // Number of unread notifications
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Search functionality
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'Items'),
              Tab(text: 'Floor Info'),
              Tab(text: 'Send Quote'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Items tab content (Dummy data for demonstration)
            Center(child: Text('Items content here')),
            // Floor Info content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Additional Info Section
                    Text(
                      'Floor Additional Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 10),
                    buildDetailRow('Old House Additional Info', oldHouseAdditionalInfo),
                    buildDetailRow('New House Additional Info', newHouseAdditionalInfo),
                    buildDetailRow('Total Items', totalItems),
                    buildDetailRow('Status', status),
                    buildDetailRow('Order Date', orderDate),
                    buildDetailRow('Date Created', dateCreated),
                    buildDetailRow('Date of Complete', dateOfComplete),
                    buildDetailRow('Date of Cancel', dateOfCancel),
                    buildDetailRow('Estimate Status', estimateStatus),
                    buildDetailRow('Custom Status', customStatus),
                    buildDetailRow('Estimate Comparison', estimateComparison),
                    buildDetailRow('Estimate Amount', estimateAmount),
                    buildDetailRow('Order Reviewed', orderReviewed),
                    buildDetailRow('Call Back', callBack),
                    buildDetailRow('Move Date Flexible', moveDateFlexible),
                    buildDetailRow('From Address', fromFullName, isAddress: true), // Display full name
                    buildDetailRow('From Address Details', fromAddressString, isAddress: true), // Address details
                    buildDetailRow('To Address', toFullName, isAddress: true), // Display full name for To Address
                    buildDetailRow('To Address Details', toAddressString, isAddress: true), // Address details for To Address
                    buildDetailRow('Service Type', serviceType),
                    buildDetailRow('Storage Type', storageType), // New field added
                    buildDetailRow('Storage Items', storageItems),
                    buildDetailRow('Successful Payments', successfulPayments),
                    buildDetailRow('Custom Items Units', customItemsUnits),
                    buildDetailRow('Custom Items', customItems.isNotEmpty ? customItems.toString() : 'No custom items'),
                  ],
                ),
              ),
            ),
            // Placeholder for Send Quote tab content
            Center(child: Text('Send Quote Content')),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Leads',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
          currentIndex: 2, // Set the current index to 'Leads'
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            // Handle navigation on item tap
          },
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value, {bool isAddress = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: isAddress ? 2 : 1, // Limit to 2 lines for address
              overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            ),
          ),
        ],
      ),
    );
  }
}


