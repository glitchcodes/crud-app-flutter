import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/services/firebase_service.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final FirebaseService _firebaseService = FirebaseService();
  final SearchController _searchController = SearchController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Image objectClassIcon(String type) {
    return switch (type) {
      'safe' => Image.asset(
        'assets/images/safe-class.png',
        width: 40,
        height: 40,
      ),
      'euclid' => Image.asset(
        'assets/images/euclid-class.png',
        width: 40,
        height: 40,
      ),
      'keter' => Image.asset(
        'assets/images/keter-class.png',
        width: 40,
        height: 40,
      ),
      _ => Image.asset(
        'assets/images/safe-class.png',
        width: 40,
        height: 40,
      ) // TODO: Replace with unknown category
    };
  }

  Widget buildSearchResults() {
    Stream<QuerySnapshot> query = _firebaseService.searchSCPItems(_searchController.text);

    if (_searchController.text.isEmpty) {
      query = _firebaseService.getSCPItemsLimited();
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate the number of columns based on screen width
            int columns = (constraints.maxWidth / 150).floor();

            return StreamBuilder(
                stream: query,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final items = snapshot.data?.docs ?? [];

                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns, // Number of columns
                      crossAxisSpacing: 10,   // Space between columns
                      mainAxisSpacing: 10,    // Space between rows
                    ),
                    itemCount: items.length, // Total number of items
                    itemBuilder: (context, index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            context.go('/directory/${items[index]['seriesId']}/${items[index].id}');
                          },
                          customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                objectClassIcon(items[index]['objectClass']),
                                Spacer(),
                                TextHeading(
                                  text: '${items[index]['title']}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text('SCP-${items[index]['itemNumber']}')
                              ],
                            ),
                          )
                        )
                      );
                    },
                  );
                }
            );
          },
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: SearchBar(
              controller: _searchController,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16),
              ),
              focusNode: _searchFocusNode,
              onTap: () {
                _searchController.openView();
                _searchFocusNode.requestFocus();
              },
              onChanged: (_) => setState(() {

              }),
              leading: Icon(Icons.search),
              trailing: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    if (_searchController.text.isEmpty) {
                      _searchController.closeView(null);
                    } else {
                      _searchController.clear();
                    }
                  },
                )
              ],
              hintText: 'Search SCPs',
            )
          ),
          SizedBox(height: 20),
          buildSearchResults()
        ],
      ),
    );
  }
}