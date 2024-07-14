// import 'package:flutter/material.dart';
// import 'package:tuan_080910/app/model/phonecategory.dart';

// class PhoneCategoryScreen extends StatefulWidget {
//   const PhoneCategoryScreen({Key? key}) : super(key: key);

//   @override
//   _PhoneCategoryScreenState createState() => _PhoneCategoryScreenState();
// }

// class _PhoneCategoryScreenState extends State<PhoneCategoryScreen> {
//   List<PhoneCategory> categories = []; // Danh sách các category

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Phone Categories'),
//       ),
//       body: ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(categories[index].name),
//             subtitle: Text(categories[index].description),
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(categories[index].imageUrl),
//             ),
//             onTap: () {
//               // Xử lý khi nhấn vào từng category
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Xử lý khi nhấn nút thêm category mới
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }