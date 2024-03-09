import 'package:flutter/material.dart';

class WarningBtnFunction extends StatefulWidget{
  const WarningBtnFunction({super.key});

  @override
  State<WarningBtnFunction> createState() => _WarningBtnFunctionState();
}

class _WarningBtnFunctionState extends State<WarningBtnFunction> {
  Widget build(BuildContext context){
    
    Size screenSize=MediaQuery.sizeOf(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
    ElevatedButton(
      onPressed: () {
        print('Button pressed!');
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, 
      ),
      child:const Row(
            children: [
            Icon(Icons.add),
            Text('Add to cart'),
          ],
            ),
    ),
    ])
    );
    }

    // Container btnFuntion (String txt,Image img)
    // {
    //   return Container(
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: [
    //       Container(
    //         padding: EdgeInsets.all(10),
    //         decoration: BoxDecoration(
    //           border: Border.all(color: Colors.white),
    //           borderRadius: BorderRadius.circular(20),
    //           ),
    //         child:Row(
    //           children: [
    //              Container(
    //                 width: 25,
    //                 child: img),
    //               SizedBox(width: 10),
    //               Text(txt,style: TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 15,
    //                 fontWeight: FontWeight.bold,
    //               ),)
    //             ],
    //           ) 
    //       )
    //     ]
    //   )
    // );
    //}
}