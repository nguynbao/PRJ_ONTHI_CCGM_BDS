import 'package:client_app/config/routes/app_navigator.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                AppNavigator.pop(context);
              },
              icon: Icon(
                Iconsax.arrow_left,
                size: 30,
                color: AppColor.textpriCol,
              ),
            ),
            Text(
              'Terms & Conditions',
              style: TextStyle(
                color: AppColor.textpriCol,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            _condition(),
            const SizedBox(height: 30,),
            _terms()
          ]
        ),
      ),
    );
  }

  Widget _condition() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Title
        Text(
          'Condition & Attending',
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10,),
        Text(
          'At enim hic etiam dolore. Dulce amarum, leve asperum, prope longe, stare movere, quadratum rotundum. At certe gravius. Nullus est igitur cuiusquam dies natalis. Paulum, cum regem Persem captum adduceret, eodem flumine invectio?',
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 20,),
        Text(
          'Quare hoc videndum est, possitne nobis hoc ratio philosophorum dare.Sed finge non solum callidum eum, qui aliquid improbe faciat, verum etiam praepotentem, ut M.Est autem officium, quod ita factum est, ut eius facti probabilis ratio reddi possit.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
  Widget _terms() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Title
        Text(
          'Terms & Use',
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10,),
        Text(
          'Ut proverbia non nulla veriora sint quam vestra dogmata. Tamen aberramus a proposito, et, ne longius, prorsus, inquam, Piso, si ista mala sunt, placet. Omnes enim iucundum motum, quo sensus hilaretur. Cum id fugiunt, re eadem defendunt, quae Peripatetici, verba. Quibusnam praeteritis? Portenta haec esse dicit, quidem hactenus; Si id dicis, vicimus. Qui ita affectus, beatum esse numquam probabis; Igitur neque stultorum quisquam beatus neque sapientium non beatus.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 20,),
        Text(
          'Dicam, inquam, et quidem discendi causa magis, quam quo te aut Epicurum reprehensum velim. Dolor ergo, id est summum malum, metuetur semper, etiamsi non ader.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
