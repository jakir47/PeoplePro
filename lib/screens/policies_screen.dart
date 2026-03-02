import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class PoliciesScreen extends StatefulWidget {
  const PoliciesScreen({Key? key}) : super(key: key);

  @override
  State<PoliciesScreen> createState() => _PoliciesScreenState();
}

class _PoliciesScreenState extends State<PoliciesScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  int _expandedPanelIndex = -1; // -1 indicates no panel is expanded

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "HR Policies",
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
              child: isLoading
                  ? const SizedBox.shrink()
                  : ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        _expandedPanelIndex = isExpanded ? -1 : index;
                        setState(() {});
                      },
                      children: Session.userData.policies!.map((policy) {
                        return ExpansionPanel(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0.0),
                                dense: true,
                                leading: SizedBox(
                                  width: 42.0,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star_outline,
                                        size: 14,
                                        color: Colors.yellow.shade800,
                                      ),
                                      Icon(
                                        Icons.star_outline,
                                        size: 14,
                                        color: Colors.yellow.shade800,
                                      ),
                                      Icon(
                                        Icons.star_outline,
                                        size: 14,
                                        color: Colors.yellow.shade800,
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(
                                  policy.title!,
                                  style: TextStyle(
                                      color: UserColors.primaryColor,
                                      fontSize: 14.0),
                                ),
                                subtitle: Text(
                                  policy.subtitle!,
                                  style: const TextStyle(fontSize: 10.0),
                                ),
                              ),
                            );
                          },
                          body: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Text(policy.content!),
                          ),
                          isExpanded: _expandedPanelIndex ==
                              Session.userData.policies!.indexOf(policy),
                          canTapOnHeader: true,
                        );
                      }).toList(),
                    )),
        ),
      ),
    );
  }
}
