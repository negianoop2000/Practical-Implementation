import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Edit_Page extends StatefulWidget {
  const Edit_Page({key});

  @override
  State<Edit_Page> createState() => _Edit_PageState();
}

class _Edit_PageState extends State<Edit_Page> {
 final TextEditingController name = TextEditingController();
  final TextEditingController quantity = TextEditingController();

  List<Map<String, dynamic>> items =[];
  final shoppingBox = Hive.box('shopping_box');

  Future<void> createItem(Map<String, dynamic> newItem) async{
    await shoppingBox.add(newItem);
  }
@override
  void initState(){
    super.initState();
    refreshItems();
  }
  void refreshItems(){
    final data = shoppingBox.keys.map((key){
      final item = shoppingBox.get(key);
      return{"key" : key, "name": item["name"],"quantity":quantity };
    }).toList();

    setState(() {

      items = data.reversed.toList();
    });
  }

void showform(BuildContext ctx, int? itemkey) async{
  showModalBottomSheet(context: ctx,
      elevation: 5,
      isScrollControlled: true,

      builder: (_) => Container(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      top: 15,
      left: 15,
      right: 15,

    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: name,
          decoration: const InputDecoration(hintText:"Name"),
        ),
        SizedBox(height: 10,),
        TextField(
            controller: quantity,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText:"Quantity"),
        ),
        ElevatedButton(onPressed: () async {
          createItem({
            "name":name.text,
            "quantity":quantity.text
          });

          name.text ='';
          quantity.text ='';
       Navigator.of(context).pop();
        }, child: Text('Create New'))
      ],
    ),
  ));
}



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Edit Page"),),
      body: ListView.builder(
        itemCount: items.length,
          itemBuilder: (_,index){
          final currentItem = items[index];
          return Card(
            color : Colors.orange.shade100,
            margin: EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text(currentItem['name']),
              subtitle: Text(currentItem['quantity'].toString()),



            ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showform(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
