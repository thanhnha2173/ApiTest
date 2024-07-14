import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuan_080910/app/model/phonecategory.dart';

class PhoneCategoryScreen extends StatefulWidget {
  const PhoneCategoryScreen({super.key});

  @override
  _PhoneCategoryScreenState createState() => _PhoneCategoryScreenState();
}

class _PhoneCategoryScreenState extends State<PhoneCategoryScreen> {
  List<PhoneCategory> categories = []; // Danh sách các category

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Tải danh sách categories từ SharedPreferences khi khởi động màn hình
  }

  Future<void> _loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? categoriesJson = prefs.getStringList('phoneCategories');

    if (categoriesJson != null) {
      setState(() {
        categories = categoriesJson.map((json) => PhoneCategory.fromJson(jsonDecode(json))).toList();
      });
    }
  }

  Future<void> _saveCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> categoriesJson = categories.map((category) => jsonEncode(category.toJson())).toList();
    await prefs.setStringList('phoneCategories', categoriesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index].name),
            subtitle: Text(categories[index].description),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(categories[index].imageUrl),
            ),
            onTap: () {
              _showEditCategoryDialog(index);
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  categories.removeAt(index);
                  _saveCategories(); // Lưu lại sau khi xóa
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog() {
    _nameController.text = '';
    _descriptionController.text = '';
    _imageUrlController.text = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  int newId = categories.isNotEmpty ? categories.last.id + 1 : 1;
                  categories.add(
                    PhoneCategory(
                      id: newId,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      imageUrl: _imageUrlController.text,
                    ),
                  );
                  _saveCategories(); // Lưu lại sau khi thêm
                });
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditCategoryDialog(int index) {
    _nameController.text = categories[index].name;
    _descriptionController.text = categories[index].description;
    _imageUrlController.text = categories[index].imageUrl;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  categories[index] = PhoneCategory(
                    id: categories[index].id,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    imageUrl: _imageUrlController.text,
                  );
                  _saveCategories(); // Lưu lại sau khi chỉnh sửa
                });
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
          ],
        );
      },
    );
  }
}
