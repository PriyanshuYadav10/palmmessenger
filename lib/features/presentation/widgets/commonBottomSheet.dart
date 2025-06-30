import 'package:flutter/material.dart';

import '../../../config/theme/app_themes.dart';
import '../utility/global.dart';

Future commonBottomSheet(title, data, dataCtrl, context,idCtrl,onDataSelected) {
  double itemHeight = 50.0; // Set your desired height for each item
  double maxHeight = MediaQuery.of(context).size.height *
      0.75; // Set the maximum height for the bottom sheet

  int itemCount = data.length;
  double calculatedHeight = itemHeight * itemCount;

  double sheetHeight =
  calculatedHeight > maxHeight ? maxHeight : calculatedHeight;
  return showModalBottomSheet(
                                        constraints: const BoxConstraints(
                                          maxWidth: double.infinity
                                        ),
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(25),
        topLeft: Radius.circular(25),
      ),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return SizedBox(
          height: sheetHeight + 50,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: ColorResources.appColor, // Use your app's primary color here
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (dataCtrl is List) {
                            // Check if dataCtrl is an empty list
                            dataCtrl.add(data[index].name);
                            idCtrl.add(data[index].id.toString());
                            onDataSelected(data[index].name, data[index].id.toString());
                            print(dataCtrl.toString());
                            print(idCtrl);
                          } else if (dataCtrl is TextEditingController) {
                            // Check if dataCtrl is a TextEditingController
                            dataCtrl.text = data[index].name.toString();
                            idCtrl.text = data[index].id.toString();
                          }

                        });
                        Navigator.pop(context, dataCtrl);
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        // Remove fixed height and width properties
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 2.5)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          child: Text(
                            data[index].name.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}
