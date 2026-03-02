import 'package:peoplepro/models/search_option_model.dart';
import 'package:flutter/material.dart';
import 'package:peoplepro/screens/employee_directory_search_result.dart';
import 'package:peoplepro/services/directory_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  final TextEditingController ctrlSearchInput = TextEditingController();
  SearchOptionModel options = SearchOptionModel(
    companies: [],
    departments: [],
    designations: [],
    locations: [],
    bloodGroups: [],
    genders: [],
    religions: [],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadOption();
    });
  }

  void loadOption() async {
    Utils.showLoadingIndicator(context);
    options = await DirectoryService.getOption();
    Utils.hideLoadingIndicator(context);
    setState(() {});
  }

  void doSearch(String searchType) {
    var searchText = ctrlSearchInput.text;
    if (searchText.isEmpty) return;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EmployeeDirectorySearchResultScreen(
        searchText: searchText,
        searchType: searchType,
      ),
    ));
  }

  void showSearchOption(List<OptionModel> options, String searchType) {
    showModalBottomSheet(
      backgroundColor: Colors.white.withOpacity(0.9),
      context: context,
      builder: (context) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                border: Border.all(width: 1, color: Colors.grey.shade200),
              ),
              child: Text(
                "Select ${searchType == 'BloodGroup' ? 'Blood Group' : searchType}",
                style: TextStyle(fontSize: 16, color: UserColors.primaryColor),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(6.0),
                itemCount: options.length,
                separatorBuilder: (context, index) {
                  return Divider(
                      height: 1, color: Colors.grey.withOpacity(0.4));
                },
                itemBuilder: (ctx, idx) {
                  var option = options[idx];
                  return InkWell(
                    onTap: () {
                      ctrlSearchInput.text = option.name!;
                      Navigator.pop(context);
                      doSearch(searchType);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        option.name!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDirectoryButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ]),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 6.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "e-Dirctory",
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/bgi3d.png',
                    height: 90,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Text(
                      "Version 2.0.0",
                      style: TextStyle(
                        fontSize: 14,
                        color: UserColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Last updated on 20250618",
                    style:
                        TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      controller: ctrlSearchInput,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) => doSearch("*"),
                      decoration: InputDecoration(
                        hintText: 'e.g. Jakir',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 1.0, color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 1.0, color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 1.0, color: Colors.grey.shade300),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          onPressed: () => doSearch("*"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 200,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 4,
                      children: [
                        _buildDirectoryButton(
                          label: "Company",
                          icon: Icons.business_center_outlined,
                          color: Colors.black87,
                          onTap: () =>
                              showSearchOption(options.companies!, "Company"),
                        ),
                        _buildDirectoryButton(
                          label: "Department",
                          icon: Icons.apartment_outlined,
                          color: Colors.teal,
                          onTap: () => showSearchOption(
                              options.departments!, "Department"),
                        ),
                        _buildDirectoryButton(
                          label: "Designation",
                          icon: Icons.badge_outlined,
                          color: Colors.blue.shade600,
                          onTap: () => showSearchOption(
                              options.designations!, "Designation"),
                        ),
                        _buildDirectoryButton(
                          label: "Location",
                          icon: Icons.location_on_outlined,
                          color: Colors.orange,
                          onTap: () =>
                              showSearchOption(options.locations!, "Location"),
                        ),
                        _buildDirectoryButton(
                          label: "Gender",
                          icon: Icons.wc,
                          color: Colors.cyan,
                          onTap: () =>
                              showSearchOption(options.genders!, "Gender"),
                        ),
                        _buildDirectoryButton(
                          label: "Religion",
                          icon: Icons.auto_awesome,
                          color: Colors.green,
                          onTap: () =>
                              showSearchOption(options.religions!, "Religion"),
                        ),
                        _buildDirectoryButton(
                          label: "Blood Group",
                          icon: Icons.bloodtype_outlined,
                          color: Colors.red,
                          onTap: () => showSearchOption(
                              options.bloodGroups!, "BloodGroup"),
                        ),
                        _buildDirectoryButton(
                          label: "Disabled",
                          icon: Icons.help_outline,
                          color: Colors.grey,
                          onTap: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
