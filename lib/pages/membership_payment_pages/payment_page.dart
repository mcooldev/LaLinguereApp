import 'package:custom_input_formatter/custom_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la_linguere/main.dart';
import 'package:la_linguere/providers/membership_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers/authentication_provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.subsName,
    required this.subsAmount,
    required this.isDonation,
  });

  final String subsName;
  final String subsAmount;
  final bool isDonation;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    ///

    ///
    return Consumer2<MembershipProvider, LoginProvider>(
      builder: (_, prov, logProvider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // badge if not connected
              if (logProvider.signedAsGuest)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: lightBg,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.multiply_circle_fill,
                        color: redLaLinguere,
                        size: 46,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Vous n'êtes pas connecté !",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: bodyText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          navKey.currentState?.pushNamed("/login");
                        },
                        child: Text(
                          "Se connecter",
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(
                                color: blueLinguere,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

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
                          widget.subsName,
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(thickness: 1, color: lightStrokeColor, height: 20),
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
                    Divider(thickness: 1, color: lightStrokeColor, height: 20),
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

              /// if (prov.paymentIndex == 2) creditCardForm(context, prov),

              // btn proceed
              MaterialButton(
                onPressed: () async {
                  final phoneNumber = logProvider.user?.phoneNumber;
                  final amount = widget.subsAmount;

                  // call proceed to payment
                  await prov.proceedToPayment(
                    context: context,
                    phoneNumber: phoneNumber,
                    amount: amount,
                    isDonation: widget.isDonation,
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
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.copyWith(color: Colors.white),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Column creditCardForm(BuildContext context, MembershipProvider prov) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // headline card details
        Text(
          "Informations bancaires",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Form(
          key: prov.cardFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card name
              Text(
                "Nom sur la carte",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: bodyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: prov.cardNameController,
                //
                onTapOutside: (pointer) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                //
                validator: (val) {
                  if (val == null || val.isEmpty || val.length < 3) {
                    return "Veuillez entrer le nom complet";
                  }
                  return null;
                },
                //
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: bodyText),
                keyboardType: TextInputType.name,
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
                  hintText: 'Nom sur la carte',
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: bodyText.withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // card number
              Text(
                "Numéro de la carte",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: bodyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: prov.cardNumberController,
                //
                onTapOutside: (pointer) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                //
                validator: (val) {
                  if (val == null || val.isEmpty || val.length < 16) {
                    return "Veuillez entrer les 16 chiffres de la carte";
                  }
                  return null;
                },
                //
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: bodyText),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CustomNumberInputFormatter(formatType: FormatType.creditCard),
                ],
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
                  hintText: '**** **** **** ****',
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: bodyText.withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // card date & security code
              Row(
                children: [
                  // expiration date
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date d'expiration",
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(
                                color: bodyText,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: prov.cardDateController,
                          //
                          onTapOutside: (pointer) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          //
                          validator: (val) {
                            if (val == null || val.isEmpty || val.length < 4) {
                              return "Veuillez entrer la date d'expiration";
                            }
                            return null;
                          },
                          //
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(color: bodyText),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CustomNumberInputFormatter(
                              separator: "/",
                              groupBy: 2,
                              maxLength: 4,
                            ),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                            //
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90),
                              borderSide: BorderSide(
                                width: 1,
                                color: strokeColor,
                              ),
                            ),
                            //
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            //
                            hintText: '00/00',
                            hintStyle: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: bodyText.withValues(alpha: 0.5),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Cvv
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sécurité",
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(
                                color: bodyText,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: prov.cardCvvController,
                          //
                          onTapOutside: (pointer) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          //
                          validator: (val) {
                            if (val == null || val.isEmpty || val.length < 3) {
                              return "Veuillez entrer le code de sécurité";
                            }
                            return null;
                          },
                          //
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(color: bodyText),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CustomNumberInputFormatter(maxLength: 3),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                            //
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90),
                              borderSide: BorderSide(
                                width: 1,
                                color: strokeColor,
                              ),
                            ),
                            //
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            //
                            hintText: 'CVV',
                            hintStyle: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: bodyText.withValues(alpha: 0.5),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
