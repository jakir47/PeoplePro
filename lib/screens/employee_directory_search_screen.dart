import 'package:peoplepro/models/search_option_model.dart';
import 'package:peoplepro/screens/employee_directory_search_result.dart';
import 'package:peoplepro/services/directory_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/mini_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class EmployeeDirectorySearchScreen extends StatefulWidget {
  const EmployeeDirectorySearchScreen({super.key});

  @override
  State<EmployeeDirectorySearchScreen> createState() =>
      _EmployeeDirectorySearchScreenState();
}

class _EmployeeDirectorySearchScreenState
    extends State<EmployeeDirectorySearchScreen> {
  final ctrlSearchInput = TextEditingController();
  var keyboardVisibilityController = KeyboardVisibilityController();
  SearchOptionModel options = SearchOptionModel(
    companies: [],
    departments: [],
    designations: [],
    locations: [],
    bloodGroups: [],
    genders: [],
    religions: [],
  );

  bool isWidgetVisiabled = true;

  @override
  void initState() {
    super.initState();
    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isWidgetVisiabled = !visible;
      });
    });
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

  void doSearch(BuildContext context, String searchType) {
    var searchText = ctrlSearchInput.text;
    if (searchText.isEmpty) return;

    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EmployeeDirectorySearchResultScreen(
            searchText: searchText, searchType: searchType)));
  }

  void showSearchOption(
      BuildContext context, List<OptionModel> options, String searchType) {
    showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(0.7),
        context: context,
        builder: (context) {
          return Column(
            children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    border: Border.all(width: 1, color: Colors.grey.shade200),
                  ),
                  child: Text(
                      "Select ${searchType == 'BloodGroup' ? 'Blood Group' : searchType}",
                      style: TextStyle(
                          fontSize: 14, color: UserColors.primaryColor))),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Divider(
                          height: 1, color: Colors.grey.withOpacity(0.4)),
                    );
                  }),
                  itemBuilder: (ctx, idx) {
                    var option = options[idx];
                    return InkWell(
                      onTap: () {
                        ctrlSearchInput.text = option.name!;
                        Navigator.pop(context);
                        doSearch(context, searchType);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(option.name!,
                            style: const TextStyle(fontSize: 14)),
                      ),
                    );
                  },
                ),
              )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "e-Directory",
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0, right: 24.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) =>
                    //         EmployeeDirectoryAdvancedSearchScreen()));
                  },
                  child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: UserColors.primaryColor,
                        borderRadius: BorderRadiusDirectional.circular(50.0),
                      ),
                      child: const Icon(
                        Icons.settings,
                        size: 18.0,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/bgi3d.png',
                    height: 140,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    "Version ${Settings.eDirectoryVersion}",
                    style:
                        const TextStyle(fontSize: 14.0, color: Colors.black87),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Updated on ${Utils.formatDate(Settings.eDirectoryLastUpdated, format: "MMMM dd, yyyy")}",
                    style: TextStyle(
                        fontSize: 10.0, color: UserColors.primaryColor),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: ctrlSearchInput,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        doSearch(context, "*");
                      },
                      decoration: InputDecoration(
                        hintText: 'e.g. Jakir',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(width: 1.0)),
                        suffixIcon: InkWell(
                          child: Icon(
                            Icons.search,
                            color: UserColors.primaryColor,
                          ),
                          onTap: () {
                            doSearch(context, "*");
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        children: [
                          MiniButtonWidget(
                              label: "Company",
                              icon: Icons.work,
                              color: UserColors.red,
                              onTap: () {
                                showSearchOption(
                                    context, options.companies!, "Company");
                              }),
                          MiniButtonWidget(
                              label: "Department",
                              icon: Icons.location_city_outlined,
                              color: Colors.teal,
                              onTap: () {
                                showSearchOption(context, options.departments!,
                                    "Department");
                              }),
                          MiniButtonWidget(
                              label: "Designation",
                              icon: Icons.title_outlined,
                              color: Colors.blue.shade600,
                              onTap: () {
                                showSearchOption(context, options.designations!,
                                    "Designation");
                              }),
                          MiniButtonWidget(
                              label: "Location",
                              icon: Icons.location_pin,
                              color: Colors.brown,
                              onTap: () {
                                showSearchOption(
                                    context, options.locations!, "Location");
                              }),
                          MiniButtonWidget(
                              label: "Gender",
                              icon: Icons.male,
                              color: Colors.cyan,
                              onTap: () {
                                showSearchOption(
                                    context, options.genders!, "Gender");
                              }),
                          MiniButtonWidget(
                              label: "Religion",
                              icon: Icons.mosque,
                              color: UserColors.green,
                              onTap: () {
                                showSearchOption(
                                    context, options.religions!, "Religion");
                              }),
                          MiniButtonWidget(
                              label: "Blood Group",
                              icon: Icons.bloodtype_outlined,
                              color: Colors.deepOrange,
                              onTap: () {
                                showSearchOption(context, options.bloodGroups!,
                                    "BloodGroup");
                              }),
                          MiniButtonWidget(
                              label: "Blood Donor",
                              icon: Icons.bloodtype_outlined,
                              color: Colors.indigo,
                              onTap: () {
                                showSearchOption(context, options.bloodGroups!,
                                    "BloodGroup");
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isWidgetVisiabled,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 3.0,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3.0)),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "POWERED BY ",
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade800),
                        children: [
                          TextSpan(
                              text: "BENGAL GROUP IT",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: UserColors.primaryColor)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
