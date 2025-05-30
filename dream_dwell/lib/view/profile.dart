import 'package:flutter/material.dart';



class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar & Profile Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/images/google.png"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 8),
                      Text(
                        "Sanumaya",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "sanumayaf5@gmail.com",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.purple),
                  onPressed: () {
                    print("Edit button clicked");
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Profile Options
            _buildListItem(Icons.settings, "Settings"),
            _buildListItem(Icons.payment, "Payments"),
            _buildListItem(Icons.receipt_long, "Billing Details"),
            _buildListItem(Icons.person_outline, "My Account"),
            _buildListItem(
              Icons.logout,
              "Logout",
              isLogout: true,
              onTap: () {
                // Show confirmation dialog on logout tap
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text("Are you sure you want to Exit?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // close dialog
                          Navigator.of(context).pushReplacementNamed('/login'); // navigate to login
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
      IconData icon,
      String title, {
        bool isLogout = false,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: isLogout ? Colors.red : Colors.black),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
