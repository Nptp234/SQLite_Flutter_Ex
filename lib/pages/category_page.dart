import 'package:bt_tuan6/data/database_service.dart';
import 'package:bt_tuan6/models/category.dart';
import 'package:bt_tuan6/pages/action_page/add_category.dart';
import 'package:bt_tuan6/pages/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quickalert/quickalert.dart';

class CategoryPage extends StatefulWidget{

  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage>{

  CategoryModel categoryModel = CategoryModel();
  DatabaseServiceCategory databaseServiceCategory = DatabaseServiceCategory();
  static List<CategoryModel> listCategory = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();


  @override
  void initState() {
    super.initState();
    setState(() {
      getList();
    });
  }

  getList() async{
    databaseServiceCategory.getCategoyList().whenComplete(() {
      setState(() async{
        listCategory = await databaseServiceCategory.getCategoyList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _headerCustom(),
      body: _bodyCustom(),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FormCategoryPage()));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  PreferredSize _headerCustom(){
    return PreferredSize(
      preferredSize: Size.fromHeight(200), 
      child: Container(
        color: Colors.blueAccent,
        padding: EdgeInsets.all(10),

        child: Text('Category List', style: TextStyle(color: Colors.white, fontSize: 25),),
      )
    );
  }

  Widget _bodyCustom(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),

      child: Container(
        padding: EdgeInsets.all(10),

        child: FutureBuilder(
          future: databaseServiceCategory.getCategoyList(), 
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No data found'),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true, 

                itemBuilder: (BuildContext context, int index) { 
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(cateId: snapshot.data![index].id,)));
                    },
                    child: _customItem(index, snapshot.data![index]),
                  );
                },
              );
            }
            return const Center(
              child: Text('No data found'),
            );
          }
        ),
      ),
    );  
  }

  Widget _customItem(int index, CategoryModel categoryModel){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 30),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 0, blurStyle: BlurStyle.solid)
        ],
        color: Colors.white,
      ),

      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //id
            Expanded(
              flex: 1,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.blueAccent,
                ),

                child: Center(
                  child: Text('$index', style: TextStyle(color: Colors.white, fontSize: 25),),
                ),
              ),
            ),
            const SizedBox(width: 20,),
            //name and desc
            // ignore: prefer_const_constructors
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 190, child: Text('${categoryModel.name}', style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),),),
                  SizedBox(width: 190, child: Text('${categoryModel.desc}', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.normal),),),
                ],
              ),
            ),

            //action delete
            IconButton(
              onPressed: (){
                QuickAlert.show(
                  context: context,
                  showCancelBtn: true,
                  type: QuickAlertType.warning,
                  title: 'Are you sure?',
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  onConfirmBtnTap: (){
                    setState((){
                      databaseServiceCategory.deleteCategory(categoryModel.id!);
                      QuickAlert.show(context: context, type: QuickAlertType.success);
                    });
                    return;
                  },
                );
              }, 
              icon: Icon(Icons.delete, color: Colors.red, size: 25,)
            ),
            //action edit
            IconButton(
              onPressed: (){
                nameController.text = categoryModel.name!;
                descController.text = categoryModel.desc!;
                QuickAlert.show(
                  context: context, 
                  type: QuickAlertType.custom,
                  barrierDismissible: true,
                  confirmBtnText: 'Save',
                  customAsset: 'assets/custom.png',
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
                        ),
                      ),
                    ],
                  ),
                  onConfirmBtnTap: () {
                    setState(() {
                      databaseServiceCategory.editCategory(CategoryModel(id: categoryModel.id, name: nameController.text, desc: descController.text));
                      QuickAlert.show(context: context, type: QuickAlertType.success);
                    });
                  },
                );
              }, 
              icon: Icon(Icons.edit, color: Colors.blue, size: 25,)
            ),
          ],
        ),
      ),
    );
  }
  
}