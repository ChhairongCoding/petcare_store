import 'package:flutter/material.dart';
import 'package:petcare_store/widgets/text_form_field_widgets.dart';

class AddressFormScreen extends StatelessWidget {
   AddressFormScreen({super.key});
  final TextEditingController addressName = TextEditingController();
  final TextEditingController addressDetail = TextEditingController();
  final  _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text("Address Form"),actions: [
        IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.grey.shade200),
          onPressed: (){}, icon: Icon(Icons.check),),
          SizedBox(width: 15,)
      ],),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 10,
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name",style: theme.bodyLarge,),
                TextFormFieldWidget(hintText: "Do something...", controller: addressDetail),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Address Detail",style: theme.bodyLarge,),
                TextFormFieldWidget(hintText: "", controller: addressDetail),
              ],
            )
        ],)),
      ),
    );
  }
}
