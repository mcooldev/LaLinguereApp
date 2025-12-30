import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/providers/support_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/app_colors.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    // todo: create form key
    // todo: Set the controllers for the form

    ///
    return Consumer<SupportProvider>(
      builder: (_, prov, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Besoin d'aide ?"),
            centerTitle: false,
            //
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: lightStrokeColor),
                  ),
                ),
              ),
            ),
          ),

          /// Body
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headline
                Text(
                  "N’hésitez pas à nous joindre!",
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                // body text
                Text(
                  "Utilisez le formulaire ci-dessous pour nous envoyer vos questions ou signaler un problème. Nous sommes là pour vous aider !",
                  style: theme.textTheme.bodyMedium!.copyWith(color: bodyText),
                ),
                const SizedBox(height: 32),

                // support form
                Form(
                  key: prov.supportFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      /// email text field
                      TextFormField(
                        //
                        onTapOutside: (pointer) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        //
                        controller: prov.emailController,
                        //
                        focusNode: FocusNode(),
                        //
                        validator: (val) {
                          if (!val.toString().contains('@')) {
                            return 'Veuillez entrer une adresse mail valide';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        //
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: bodyText,
                        ),
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
                          hintText: 'Adresse mail',
                          hintStyle: theme.textTheme.bodyMedium!.copyWith(
                            color: bodyText.withValues(alpha: 0.5),
                          ),

                          //
                          prefixIcon: Icon(
                            CupertinoIcons.at,
                            size: 22,
                            color: bodyText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// object text field
                      TextFormField(
                        //
                        onTapOutside: (pointer) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        //
                        controller: prov.objectController,
                        //
                        focusNode: FocusNode(),
                        //
                        textCapitalization: TextCapitalization.sentences,
                        //
                        validator: (val) {
                          if (val.toString().isEmpty) {
                            return "Veuillez décrire votre l'objet de votre demande";
                          }
                          return null;
                        },
                        //
                        keyboardType: TextInputType.text,
                        //
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: bodyText,
                        ),
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
                          hintText: 'Objet de votre message',
                          hintStyle: theme.textTheme.bodyMedium!.copyWith(
                            color: bodyText.withValues(alpha: 0.5),
                          ),

                          //
                          prefixIcon: Icon(
                            CupertinoIcons.pencil_ellipsis_rectangle,
                            size: 22,
                            color: bodyText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// message content text field
                      SizedBox(
                        height: 200,
                        child: TextFormField(
                          //
                          onTapOutside: (pointer) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          //
                          controller: prov.messageController,
                          //
                          focusNode: FocusNode(),
                          //
                          keyboardType: TextInputType.multiline,
                          //
                          validator: (val) {
                            if (val.toString().isEmpty) {
                              return "Veuillez décrire votre message";
                            }
                            return null;
                          },
                          //
                          expands: true,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.start,
                          textCapitalization: TextCapitalization.sentences,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: bodyText,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                width: 1,
                                color: strokeColor,
                              ),
                            ),
                            //
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            //
                            hintText: 'Objet de votre message',
                            hintStyle: theme.textTheme.bodyMedium!.copyWith(
                              color: bodyText.withValues(alpha: 0.5),
                            ),
                            //
                            alignLabelWithHint: true,
                            prefixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 18),
                                  child: Icon(
                                    CupertinoIcons.doc_plaintext,
                                    size: 22,
                                    color: bodyText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      /// submit btn
                      MaterialButton(
                        onPressed: () {
                          prov.onSubmitForm();
                          //
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '🥳 Message envoyé avec succès !',
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: blueLinguere,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                            ),
                          );
                        },
                        color: blueLinguere,
                        height: 48,
                        elevation: 0,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: Text(
                          'Soumettre ma demande',
                          style: theme.textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
