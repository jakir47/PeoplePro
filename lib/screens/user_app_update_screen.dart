import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peoplepro/models/user_app_updated_model.dart';
import 'package:peoplepro/screens/employee_directory_search_result.dart';
import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/widgets/background_widget.dart';

class UserAppUpdatedScreen extends StatefulWidget {
  const UserAppUpdatedScreen({Key? key}) : super(key: key);

  @override
  State<UserAppUpdatedScreen> createState() => _UserAppUpdatedScreenState();
}

class _UserAppUpdatedScreenState extends State<UserAppUpdatedScreen> {
  List<UserAppUpdatedModel> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadList();
  }

  loadList() async {
    try {
      final data = await UserService.getUserAppUpdated();
      setState(() {
        data.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        users = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "App Updated Users",
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Summary Card
              _buildSummaryCard(),
              const SizedBox(height: 16),
              // List Header
              _buildListHeader(),
              const SizedBox(height: 8),
              // User List
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildUserList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(
                "Total Users", users.length, UserColors.primaryColor),
            if (users.isNotEmpty)
              _buildStatItem(
                "Last Updated",
                null,
                Colors.grey,
                subtitle: DateFormat('MMM dd, yyyy').format(users[0].updatedAt),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, int? count, Color color,
      {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        if (count != null)
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: UserColors.primaryColor,
            ),
          ),
      ],
    );
  }

  Widget _buildListHeader() {
    return const Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "Name",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Text(
            "Updated",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserList() {
    if (users.isEmpty) {
      return const Center(
        child: Text(
          "No users found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserListItem(user);
      },
    );
  }

  Widget _buildUserListItem(UserAppUpdatedModel user) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeDirectorySearchResultScreen(
              searchText: user.userId,
              searchType: "EmpCode",
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 0.0),
                      decoration: BoxDecoration(
                          color: UserColors.primaryColor,
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Text(
                        user.designation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      user.department,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
              // Updated At Column
              Expanded(
                child: Text(
                  DateFormat('MMM dd, hh:mm a').format(user.updatedAt),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
