import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../providers/foundation_provider.dart';
import '../../../../widgets/donate_widget.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoundationProvider>().startLoop();
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    ///
    return Consumer<FoundationProvider>(
      builder: (_, prov, _) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(16.0, 94, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // About
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: lightBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // headline
                    Text('À propos du club', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),

                    // body text
                    Text(
                      'Lorem ipsum dolor sit amet consectetur. Velit pharetra ac amet vel in rhoncus sodales tempor faucibus. Quam pharetra orci nunc mauris euismod id semper. Suspendisse morbi integer sagittis viverra blandit sed sed est. Scelerisque nisl diam facilisi velit et. Lacus in blandit amet elit vitae. Pharetra blandit curabitur purus arcu molestie quam massa viverra quisque. A libero auctor sodales aliquam pellentesque. Mi pretium placerat nulla vitae et lacus urna diam. Elit aliquam elementum dictumst vel imperdiet scelerisque tellus. Consequat libero mauris vulputate faucibus vitae est turpis elit.',
                      softWrap: true,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Partners
              Text(
                'Nos partenaires majeurs',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: IgnorePointer(
                  child: InfiniteCarousel.builder(
                    loop: true,
                    itemCount: prov.logoPartners.length,
                    itemExtent: 135,
                    center: false,
                    controller: prov.scrollController,
                    velocityFactor: 0.2,
                    onIndexChanged: (index) {},
                    itemBuilder: (ctx, itemIndex, realIndex) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.asset(
                          prov.logoPartners[itemIndex],
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Info contact
              Text('Nous joindre', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(width: 1, color: strokeColor),
                ),
                child: ListView.separated(
                  itemCount: prov.infoContact.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  separatorBuilder: (ctx, i) =>
                      Divider(thickness: 1, color: strokeColor),
                  itemBuilder: (ctx, i) {
                    //
                    final info = prov.infoContact[i];
                    //
                    return ListTile(
                      onTap: info.onTap,
                      leading: CircleAvatar(
                        backgroundColor: darkBlue,
                        child: Icon(info.iconData, color: yellowLinguere),
                      ),
                      title: Text(
                        info.label,
                        style: theme.textTheme.labelSmall!.copyWith(
                          color: bodyText,
                        ),
                      ),
                      subtitle: Text(
                        info.content,
                        style: theme.textTheme.titleSmall,
                      ),
                      trailing: Icon(
                        CupertinoIcons.chevron_forward,
                        color: strokeColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Donating
              DonateWidget(theme: theme),
            ],
          ),
        );
      },
    );
  }
}
