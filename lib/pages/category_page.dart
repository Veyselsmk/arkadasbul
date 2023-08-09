import 'package:flutter/material.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/room_list_page.dart';

class CategoryPage extends StatelessWidget {
  final UserModel? user;

  const CategoryPage({Key? key, this.user}) : super(key: key);

  static const List<String> categories = ['Halı Saha', 'Gezi', 'Seminer', 'Sinema'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategoriler'),
      ),
      body: buildCategoryList(context),
    );
  }

  Widget buildCategoryList(BuildContext context) {
    final itemCount = categories.length;
    final crossAxisCount = MediaQuery.of(context).size.width ~/ 200;
    final padding = MediaQuery.of(context).padding;

    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, padding.bottom),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return buildCategoryCard(context, categories[index]);
              },
              childCount: itemCount,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryCard(BuildContext context, String category) {
    return Card(
      color: Colors.blue.shade100,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => navigateToRoomListPage(context, category),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void navigateToRoomListPage(BuildContext context, String category) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RoomListPage(user:user,category: category)),
    );
  }
}
