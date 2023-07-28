import 'package:flutter/material.dart';
import 'package:foodpanda_user/search/controllers/search_shop_controller.dart';

class RecentSearch extends StatefulWidget {
  final Function(String) handleSubmit;
  const RecentSearch({super.key, required this.handleSubmit});

  @override
  State<RecentSearch> createState() => _RecentSearchState();
}

class _RecentSearchState extends State<RecentSearch> {
  List<String> searchHistory = [];
  SearchShopController searchShopController = SearchShopController();

  getData() async {
    searchHistory = await searchShopController.getSearchHistory();
    setState(() {});
  }

  removeSearchHistory(int index) async {
    searchHistory.removeAt(index);
    await searchShopController.removeSearchHistory(
        searchHistory: searchHistory);
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent searches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            searchHistory.isEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => widget.handleSubmit('Starbuck'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.history,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Starbuck',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.close,
                                    color: Colors.grey[700],
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => widget.handleSubmit('KOI'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.history,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'KOI',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.close,
                                    color: Colors.grey[700],
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    })
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        searchHistory.length < 5 ? searchHistory.length : 5,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          widget.handleSubmit(searchHistory[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  searchHistory[index],
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => removeSearchHistory(index),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey[700],
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
          ],
        ),
      ),
    );
  }
}
