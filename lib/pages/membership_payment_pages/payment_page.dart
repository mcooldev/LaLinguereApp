import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la_linguere/main.dart';
import 'package:la_linguere/models/user_model.dart';
import 'package:la_linguere/providers/membership_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers/authentication_provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    this.subsName,
    this.subsAmount,
    required this.isDonation,
  });

  final String? subsName, subsAmount;
  final bool isDonation;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    ///

    ///
    return Scaffold(
      body: Consumer2<MembershipProvider, LoginProvider>(
        builder: (_, prov, logProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            child: Column(
              children: [
                // badge if not connected
                if (logProvider.signedAsGuest && !widget.isDonation)
                  Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: lightBg,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          CupertinoIcons.multiply_circle_fill,
                          color: redLaLinguere,
                          size: 44,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Vous n'êtes pas connecté !",
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(
                                color: bodyText,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              navKey.currentState?.pushNamed("/login");
                            },
                            child: Text(
                              "Se connecter",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: blueLinguere,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.isDonation)
                  donationForm(context, prov, logProvider)
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // headline subscribing
                      Text(
                        "Souscription d'abonnement",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),

                      // subscription details
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(width: 1, color: lightStrokeColor),
                        ),
                        child: Column(
                          children: [
                            // subs. name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Abonnement choisi",
                                  style: Theme.of(context).textTheme.labelLarge!
                                      .copyWith(
                                        color: bodyText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Text(
                                  widget.subsName ?? "",
                                  style: Theme.of(context).textTheme.labelLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: lightStrokeColor,
                              height: 20,
                            ),
                            // subs. duration
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Durée de l’abonnement",
                                  style: Theme.of(context).textTheme.labelLarge!
                                      .copyWith(
                                        color: bodyText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Text(
                                  "1 année",
                                  style: Theme.of(context).textTheme.labelLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: lightStrokeColor,
                              height: 20,
                            ),
                            // subs. price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Montant de l’abonnement",
                                  style: Theme.of(context).textTheme.labelLarge!
                                      .copyWith(
                                        color: bodyText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Text(
                                  "${widget.subsAmount} FCFA",
                                  style: Theme.of(context).textTheme.labelLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: greenLaLinguere,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // headline payment method
                      Text(
                        "Moyens de paiement",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),

                      // payment methods
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: List.generate(prov.paymentList.length, (i) {
                          //
                          final payment = prov.paymentList[i];
                          final isSelected = i == prov.paymentIndex;

                          //
                          return GestureDetector(
                            onTap: () {
                              prov.setPaymentIndex(i);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              width: MediaQuery.sizeOf(context).width * 0.29,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? blueLinguere.withValues(alpha: 0.15)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  width: 1,
                                  color: isSelected
                                      ? blueLinguere
                                      : lightStrokeColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                      payment["image"].toString(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    payment["title"].toString(),
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: isSelected
                                              ? blueLinguere
                                              : bodyText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),

                      // btn proceed
                      MaterialButton(
                        onPressed: () async {
                          final phoneNumber = logProvider.user?.phoneNumber;
                          final amount = widget.subsAmount ?? "";
                          final membershipType = widget.subsName ?? "";

                          MembershipType? selectedType;

                          if (!widget.isDonation) {
                            int index = membershipTypeName.indexOf(membershipType);
                            selectedType = (index != -1) ? MembershipType.values[index] : null;
                          } else {
                            selectedType = null;
                          }

                          // call proceed to payment
                          await prov.proceedToPayment(
                            context: context,
                            phoneNumber: phoneNumber,
                            amount: amount,
                            isDonation: widget.isDonation,
                            newMembershipType: selectedType
                          );
                        },
                        color: blueLinguere,
                        height: 48,
                        elevation: 0,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: prov.isLoading
                            ? const CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                'Procéder au paiement',
                                style: Theme.of(context).textTheme.labelLarge!
                                    .copyWith(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Column donationForm(
    BuildContext context,
    MembershipProvider prov,
    LoginProvider logProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // headline card details
        Text(
          "Veuillez saisir le montant dont vous souhaitez faire un don",
          softWrap: true,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Form(
          key: prov.donationFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card name
              Text(
                "Montant",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: bodyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: prov.amountController,
                //
                onTapOutside: (pointer) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                //
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Veuillez entrer un montant";
                  }
                  //
                  final amount = double.tryParse(val);
                  if (amount == null) {
                    return "Veuillez entrer un montant valide";
                  }
                  if (amount < 3) {
                    return "Le montant minimum est de 3 FCFA";
                  }
                  //
                  return null;
                },
                //
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: bodyText),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                  signed: false,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                  //
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90),
                    borderSide: BorderSide(width: 1, color: strokeColor),
                  ),
                  //
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  //
                  hintText: 'min. 3',
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: bodyText.withValues(alpha: 0.5),
                  ),
                  suffixText: "FCFA",
                ),
              ),
              const SizedBox(height: 24),

              // headline payment method
              Text(
                "Moyens de paiement",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              // payment methods
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(prov.paymentList.length, (i) {
                  //
                  final payment = prov.paymentList[i];
                  final isSelected = i == prov.paymentIndex;

                  //
                  return GestureDetector(
                    onTap: () {
                      prov.setPaymentIndex(i);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      width: MediaQuery.sizeOf(context).width * 0.29,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? blueLinguere.withValues(alpha: 0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          width: 1,
                          color: isSelected ? blueLinguere : lightStrokeColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(payment["image"].toString()),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            payment["title"].toString(),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(
                                  color: isSelected ? blueLinguere : bodyText,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // btn proceed
              MaterialButton(
                onPressed: () async {
                  final phoneNumber = logProvider.user?.phoneNumber;
                  final amount = prov.amountController.text.trim();

                  // call proceed to payment
                  if (prov.donationFormKey.currentState!.validate()) {
                    await prov.proceedToPayment(
                      context: context,
                      phoneNumber: phoneNumber,
                      amount: amount,
                      isDonation: widget.isDonation,
                      newMembershipType: null
                    );
                  }
                },
                color: blueLinguere,
                height: 48,
                elevation: 0,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
                child: prov.isLoading
                    ? const CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      )
                    : Text(
                        'Procéder au paiement',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.copyWith(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
