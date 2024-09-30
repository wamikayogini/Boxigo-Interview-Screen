import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;





class LeadsScreen extends StatefulWidget {
  @override
  _LeadsScreenState createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  List leads = [];
  bool isLoading = true; // To show loading indicator
  String errorMessage = ''; // To capture any error messages
  String selectedFilter = 'All'; // To keep track of the selected filter

  @override
  void initState() {
    super.initState();
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    try {
      final response = await http.get(Uri.parse('http://test.api.boxigo.in/sample-data/'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is Map && jsonResponse.containsKey('Customer_Estimate_Flow')) {
          final leadsData = jsonResponse['Customer_Estimate_Flow'];

          if (leadsData is List) {
            setState(() {
              leads = leadsData;
              isLoading = false;
            });
          } else {
            setState(() {
              errorMessage = "'Customer_Estimate_Flow' is not a list. Received: $leadsData";
              isLoading = false;
            });
          }
        } else {
          setState(() {
            errorMessage = "Invalid response format or 'Customer_Estimate_Flow' key not found.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to load leads. Status code: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e, stacktrace) {
      print("Error: $e");
      print("Stacktrace: $stacktrace");

      setState(() {
        errorMessage = "Error fetching leads: $e";
        isLoading = false;
      });
    }
  }

  void selectFilter(String filter) {
    setState(() {
      selectedFilter = filter; // Update the selected filter
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 8), // Space between logo and title
            Text('Leads'),
          ],
        ),
        actions: [
          // Search Button
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implement search functionality
            },
          ),
          // Notification Bell with Badge
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  
                },
              ),
              Positioned(
                right: 15,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: 16,
                    maxHeight: 19,
                  ),
                  child: Center(
                    child: Text(
                      '3', // Replace with the number of notifications
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs for filtering leads
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterButton(label: 'All', isSelected: selectedFilter == 'All', onTap: () => selectFilter('All')),
                FilterButton(label: 'New', isSelected: selectedFilter == 'New', onTap: () => selectFilter('New')),
                FilterButton(label: 'Follow Up', isSelected: selectedFilter == 'Follow Up', onTap: () => selectFilter('Follow Up')),
                FilterButton(label: 'Booked', isSelected: selectedFilter == 'Booked', onTap: () => selectFilter('Booked')),
                FilterButton(label: 'In Transit', isSelected: selectedFilter == 'In Transit', onTap: () => selectFilter('In Transit')),
              ],
            ),
          ),
          // List of leads
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage)) // Display error message if exists
                    : ListView.builder(
                        itemCount: leads.length,
                        itemBuilder: (context, index) {
                          final lead = leads[index];
                          return LeadTile(lead: lead);
                        },
                      ),
          ),
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
        currentIndex: 0, // Set the current index to 'Leads'
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true, // Show labels for unselected items
        type: BottomNavigationBarType.fixed, // Keep all items visible and prevent shifting
        onTap: (index) {
          // Handle navigation on item tap
        },
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({Key? key, required this.label, required this.isSelected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.red : Colors.black), // Change text color based on selection
      ),
      style: TextButton.styleFrom(
        // No border or background color
      ),
    );
  }
}

class LeadTile extends StatelessWidget {
  final Map<String, dynamic> lead;

  const LeadTile({Key? key, required this.lead}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6), // Set a max width
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead['moving_from'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Set text color to black
                        ),
                        overflow: TextOverflow.ellipsis, // Use ellipsis to show '...' when overflow occurs
                        maxLines: 3, // Limit to 3 lines
                      ),
                      SizedBox(height: 5),
                      Text(
                        'To: ${lead['moving_to']}',
                        style: TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis, // Use ellipsis here as well if needed
                        maxLines: 1, // Limit to 1 line
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      lead['moving_on'].substring(0, 10), // Format date
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      lead['moving_on'].substring(11), // Format time
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconText(icon: Icons.home, text: lead['property_size']),
                IconText(icon: Icons.location_on, text: lead['distance']),
                IconText(icon: Icons.directions_car, text: lead['old_parking_distance']),
                IconText(icon: Icons.elevator, text: 'Elevator: ${lead['old_elevator_availability']}'),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Implement view details functionality
                  },
                  child: Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red, // Text color
                    side: BorderSide(color: Colors.red), // Red border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Rounded corners
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Implement submit quote functionality
                  },
                  child: Text(
                    'Submit Quote',
                    style: TextStyle(color: Colors.white), // Change text color to white
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Rounded corners
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText({Key? key, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.red),
        SizedBox(width: 1),
        Text(text, style: TextStyle(color: Colors.black)), // Set text color to black
      ],
    );
  }
}