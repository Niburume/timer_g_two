import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timerg/helpers/db_helper.dart';

import 'package:timerg/screens/set_project_screen.dart';
import 'package:timerg/widgets/serch_field.dart';

import '../Models/project_model.dart';
import '../controllers/data/data_cubit.dart';
import '../controllers/settings/settings_cubit.dart';
import '../controllers/timer/timer_cubit.dart';

class ChooseProjectScreen extends StatefulWidget {
  static const routeName = 'choose_porject_screen';

  const ChooseProjectScreen({Key? key}) : super(key: key);

  @override
  State<ChooseProjectScreen> createState() => _ChooseProjectScreenState();
}

class _ChooseProjectScreenState extends State<ChooseProjectScreen> {
  TextEditingController searchController = TextEditingController();
  List<Project> _projects = [];
  final List<Project> _searchResults = [];

  void queryProjects() async {
    _projects = await DBHelper.instance.queryAllProjects();
    setState(() {});
  }

  _handleSearch(String input) {
    _searchResults.clear();
    for (var project in _projects) {
      if (project.projectName.toLowerCase().contains(input.toLowerCase()) ||
          project.address.toLowerCase().contains(input.toLowerCase())) {
        print(project.projectName);
        setState(() {
          _searchResults.add(project);
        });
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    queryProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Choose project',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SetProjectScreen.routeName)
                        .then((value) => queryProjects());
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 35,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(
                searchController: searchController,
                searchHandle: _handleSearch,
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _searchResults.isEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: _projects.length,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<TimerCubit>()
                                    .setCurrentProject(_projects[i]);
                                context.read<SettingsCubit>().setTabBarIndex(1);
                                print(_projects[i].projectName);
                              },
                              child: listTile(_projects[i].projectName,
                                  _projects[i].address),
                            );
                          })
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<TimerCubit>()
                                    .setCurrentProject(_searchResults[i]);
                                Navigator.pop(
                                    context, _searchResults[i].projectName);
                              },
                              child: listTile(_searchResults[i].projectName,
                                  _searchResults[i].address),
                            );
                          }),
                ],
              ),
            ),
          ],
        ));
  }

  Widget listTile(String projectName, String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                projectName,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                address,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
