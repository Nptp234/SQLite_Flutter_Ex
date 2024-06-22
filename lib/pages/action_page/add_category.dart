import 'dart:ui';

import 'package:bt_tuan6/data/database_service.dart';
import 'package:bt_tuan6/models/category.dart';
import 'package:bt_tuan6/pages/category_page.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:quickalert/quickalert.dart';

class FormCategoryPage extends StatelessWidget{

  CategoryModel? categoryModel = CategoryModel();
  DatabaseServiceCategory databaseServiceCategory = DatabaseServiceCategory();

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  FormCategoryPage({this.categoryModel});

  void addCategory(String name, String des){
    categoryModel = CategoryModel(id: Uuid().v4(), name: name, desc: des);
    databaseServiceCategory.insertCategory(categoryModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _headerCustom(context),
      body: _bodyCustom(context),
    );
  }

  PreferredSize _headerCustom(BuildContext context){
    return PreferredSize(
      preferredSize: Size.fromHeight(70), 
      child: Container(
        color: Colors.blueAccent,
        child: Center(
          child: Row(
            children: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                }, 
                icon: Icon(Icons.arrow_back, color: Colors.black, size: 30,)
              ),
              Text('Category Form Field', style: TextStyle(color: Colors.white, fontSize: 20),),
            ],
          ),
        ),
      )
    );
  }

  Widget _bodyCustom(BuildContext context){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
              ),
            ),
            const SizedBox(height: 30,),

            SizedBox(
              width: double.infinity,
              height: 200,

              child: TextFormField(
                controller: descController,
                maxLines: 20,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
                ),
              ),
            ),
            const SizedBox(height: 30,),

            GestureDetector(
              onTap: (){
                addCategory(nameController.text, descController.text);
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),

                child: Center(child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 20),),),
              ),
            )
          ],
        ),
      ),
    );
  }
}