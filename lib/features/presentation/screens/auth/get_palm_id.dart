import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/features/presentation/screens/auth/palm_id_generate.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../config/theme/textstyles.dart';
import '../../../../core/constants/images.dart';
import '../../../helper/alertDiaolg.dart';
import '../../../provider/authProvider.dart';
import '../../utility/app_shared_prefrence.dart';
import '../../utility/global.dart';
import '../../utility/gradient_text.dart';
import '../../widgets/button.dart';
import '../../widgets/textfeild.dart';
import 'LoginScreen.dart';

class GetPalmIdScreen extends StatefulWidget {
  const GetPalmIdScreen({super.key});

  @override
  State<GetPalmIdScreen> createState() => _GetPalmIdScreenState();
}

class _GetPalmIdScreenState extends State<GetPalmIdScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController confirmPasswordCtrl = TextEditingController();
  Future<void> createOrder() async {
    Map<String, dynamic> param={
      "amount":'9900'
    };
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.createOrder(param);
    if (authProvider.createOrderModel?.orderId != ''&&authProvider.createOrderModel?.orderId != null){
      Razorpay razorpay = Razorpay();
      var options = {
        'key': 'rzp_test_1s6298WJQ20aHr',
        'amount': 9900,
        'order_id':authProvider.createOrderModel?.orderId.toString(),
        'name': 'Palm Messenger',
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'external': {
          'wallets': ['paytm']
        }
      };
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
      razorpay.open(options);
    }else{
      showAlertError(authProvider.message, context);
    }
  }

  Future<void> registerPalId(orderId,paymentId,signature) async {
    Map<String, dynamic> param={
      "name":nameCtrl.text,
      "password":passwordCtrl.text,
      "orderId":orderId.toString(),
      "paymentId":paymentId.toString(),
      "signature":signature.toString(),
    };
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.registerPalmId(param);
    if (authProvider.palmIdModel?.palmId != ''&&authProvider.palmIdModel?.palmId !=null){
      if(authProvider.isLoading==false) {

        final prefs = AppSharedPref();
        prefs.save("userData", authProvider.palmIdModel);
        prefs.read('userData').then((data) {
          print('data--> ${data}');
        });
        accessToken=authProvider.palmIdModel!.accessToken.toString();
        Get.offAll(PalmIdGenerateScreen(name: nameCtrl.text));
        showAlertSuccess(authProvider.message, context);
      }
    }else{
      showAlertError(authProvider.message, context);
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response){
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    print("Payment ID: ${response.paymentId},");
    print("Payment orderId: ${response.orderId},");
    print("Payment data: ${response.data},");
    print("Payment signature: ${response.signature},");
    registerPalId(response.orderId,response.paymentId,response.signature);
    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage(app_bg), fit: BoxFit.cover)),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: ListView(
              children: [
                hSpace(50),
                Image.asset(
                  global2,
                  height: 40,
                ),
                hSpace(30),
                GradientText(
                  'Get Your Palm ID',
                  style: Styles.extraBoldTextStyle(size: 36),
                ),
                hSpace(20),
                Text(
                  'Quantum-Secure Identity for',
                  textAlign: TextAlign.center,
                  style: Styles.mediumTextStyle(
                      size: 14, color: ColorResources.whiteColor),
                ),
                hSpace(5),
                GradientText(
                  'Palm Messenger',
                  style: Styles.mediumTextStyle(size: 14),
                ),
                hSpace(25),
                Text(
                  'Name(optional)',
                  style: Styles.mediumTextStyle(
                      size: 15, color: ColorResources.whiteColor),
                ),
                hSpace(5),
                buildTextField(nameCtrl, '',
                    MediaQuery.sizeOf(context).width * 0.57, 45, TextInputType.text,
                    fun: () {}),
                hSpace(15),
                Text(
                  'Create password',
                  style: Styles.mediumTextStyle(
                      size: 15, color: ColorResources.whiteColor),
                ),
                hSpace(5),
                buildTextField(passwordCtrl, '',
                    MediaQuery.sizeOf(context).width * 0.57, 45, TextInputType.text,
                    fun: () {}),
                hSpace(15),
                Text(
                  'Confirm password',
                  style: Styles.mediumTextStyle(
                      size: 15, color: ColorResources.whiteColor),
                ),
                hSpace(5),
                buildTextField(confirmPasswordCtrl, '',
                    MediaQuery.sizeOf(context).width * 0.57, 45, TextInputType.text,
                    fun: () {}),
                hSpace(20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 25,
                        child: Icon(
                          Icons.lightbulb_outline_rounded,
                          color: ColorResources.whiteColor,
                        )),
                    wSpace(5),
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.68,
                        child: Text(
                          'Your Palm ID will be generated after payment using a secure, quantum-safr process and will look like:',
                          style: Styles.regularTextStyle(
                              size: 13, color: ColorResources.whiteColor),
                        ))
                  ],
                ),
                hSpace(15),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why Palm ID?',
                        style: Styles.mediumTextStyle(
                            size: 18, color: ColorResources.whiteColor),
                      ),
                      hSpace(8),
                      Text(
                        '• Anonymous, phone-free login',
                        style: Styles.mediumTextStyle(
                            size: 13, color: ColorResources.whiteColor),
                      ),
                      hSpace(5),
                      Text(
                        '• End-to-end quantum encryption',
                        style: Styles.mediumTextStyle(
                            size: 13, color: ColorResources.whiteColor),
                      ),
                      hSpace(5),
                      Text(
                        '• Lifetime secure handle',
                        style: Styles.mediumTextStyle(
                            size: 13, color: ColorResources.whiteColor),
                      ),
                    ],
                  ),
                ),
                hSpace(50),
                customButton(() {
                  createOrder();
                }, 'Proceed to Payment ₹ 99/year', context,isLoading: authProvider.isLoading),
                hSpace(20),
                InkWell(
                    onTap: () {
                      Get.offAll(LoginScreen());
                    },
                    child: Text("Already have a Palm ID?",
                        textAlign: TextAlign.center,
                        style: Styles.mediumTextStyle(
                            size: 15, color: ColorResources.whiteColor)))
              ],
            ),
          ),
        );
      }
    );
  }
}
