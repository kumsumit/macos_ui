import 'dart:io';

import 'package:example/pages/buttons_page.dart';
import 'package:example/pages/colors_page.dart';
import 'package:example/pages/dialogs_page.dart';
import 'package:example/pages/fields_page.dart';
import 'package:example/pages/indicators_page.dart';
import 'package:example/pages/resizable_pane_page.dart';
import 'package:example/pages/selectors_page.dart';
import 'package:example/pages/sliver_toolbar_page.dart';
import 'package:example/pages/tabview_page.dart';
import 'package:example/pages/toolbar_page.dart';
import 'package:example/pages/typography_page.dart';
import 'package:example/platform_menus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme.dart';

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

Future<void> main() async {
  if (!kIsWeb) {
    if (Platform.isMacOS) {
      await _configureMacosWindowUtils();
    }
  }

  runApp(const MacosUIGalleryApp());
}

class MacosUIGalleryApp extends StatelessWidget {
  const MacosUIGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return MacosApp(
          title: 'macos_ui Widget Gallery',
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          home: const WidgetGallery(),
        );
      },
    );
  }
}

class WidgetGallery extends StatefulWidget {
  const WidgetGallery({super.key});

  @override
  State<WidgetGallery> createState() => _WidgetGalleryState();
}

class _WidgetGalleryState extends State<WidgetGallery> {
  int pageIndex = 0;

  late final searchFieldController = TextEditingController();

  static const _pageIndexes = {
    'Buttons': 0,
    'Indicators': 1,
    'Fields': 2,
    'Colors': 3,
    'Dialogs and Sheets': 4,
    'Toolbar': 5,
    'SliverToolbar': 6,
    'TabView': 7,
    'ResizablePane': 8,
    'Selectors': 9,
    'Typography': 10,
  };

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: menuBarItems(),
      child: MacosWindow(
        sidebar: Sidebar(
          top: MacosSearchField(
            placeholder: 'Search components',
            controller: searchFieldController,
            onResultSelected: (result) {
              final index = _pageIndexes[result.searchKey];
              if (index != null) {
                setState(() => pageIndex = index);
              }
              searchFieldController.clear();
            },
            results: _pageIndexes.keys.map(SearchResultItem.new).toList(),
          ),
          minWidth: 220,
          startWidth: 240,
          builder: (context, scrollController) {
            return SidebarItems(
              currentIndex: pageIndex,
              onChanged: (i) {
                if (kIsWeb && i == 10) {
                  launchUrl(
                    Uri.parse(
                      'https://www.figma.com/file/IX6ph2VWrJiRoMTI1Byz0K/Apple-Design-Resources---macOS-(Community)?node-id=0%3A1745&mode=dev',
                    ),
                  );
                } else {
                  setState(() => pageIndex = i);
                }
              },
              scrollController: scrollController,
              itemSize: SidebarItemSize.large,
              items: const [
                SidebarItem(
                  label: Text('Basic UI Elements'),
                  section: true,
                  expandDisclosureItems: true,
                  disclosureItems: [
                    SidebarItem(
                      leading: MacosImageIcon(
                        AssetImage(
                          'assets/sf_symbols/button_programmable_2x.png',
                        ),
                      ),
                      label: Text('Buttons'),
                    ),
                    SidebarItem(
                      leading: MacosImageIcon(
                        AssetImage(
                          'assets/sf_symbols/lines_measurement_horizontal_2x.png',
                        ),
                      ),
                      label: Text('Indicators'),
                    ),
                    SidebarItem(
                      leading: MacosImageIcon(
                        AssetImage(
                          'assets/sf_symbols/character_cursor_ibeam_2x.png',
                        ),
                      ),
                      label: Text('Fields'),
                    ),
                    SidebarItem(
                      leading: MacosImageIcon(
                        AssetImage(
                          'assets/sf_symbols/rectangle_3_group_2x.png',
                        ),
                      ),
                      label: Text('Colors'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.square_on_square),
                      label: Text('Dialogs & Sheets'),
                    ),
                  ],
                ),
                SidebarItem(
                  leading: MacosImageIcon(
                    AssetImage(
                      'assets/sf_symbols/macwindow.on.rectangle_2x.png',
                    ),
                  ),
                  label: Text('Layout'),
                  section: true,
                  disclosureItems: [
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.macwindow),
                      label: Text('Toolbar'),
                    ),
                    SidebarItem(
                      leading: MacosImageIcon(
                        AssetImage(
                          'assets/sf_symbols/menubar.rectangle_2x.png',
                        ),
                      ),
                      label: Text('SliverToolbar'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.uiwindow_split_2x1),
                      label: Text('TabView'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.rectangle_split_3x1),
                      label: Text('ResizablePane'),
                    ),
                  ],
                  expandDisclosureItems: true,
                ),
                SidebarItem(
                  label: Text('Additional UI Elements'),
                  section: true,
                  expandDisclosureItems: true,
                  disclosureItems: [
                    SidebarItem(
                      leading: MacosImageIcon(
                        AssetImage(
                          'assets/sf_symbols/filemenu_and_selection_2x.png',
                        ),
                      ),
                      label: Text('Selectors'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.textformat_size),
                      label: Text('Typography'),
                    ),
                  ],
                ),
              ],
            );
          },
          bottom: const MacosListTile(
            leading: MacosIcon(CupertinoIcons.square_grid_2x2),
            title: Text('macos_ui'),
            subtitle: Text('Widget Gallery'),
          ),
        ),
        endSidebar: Sidebar(
          startWidth: 200,
          minWidth: 200,
          maxWidth: 300,
          shownByDefault: false,
          builder: (context, _) {
            return const Center(child: Text('End Sidebar'));
          },
        ),
        child: [
          CupertinoTabView(builder: (_) => const ButtonsPage()),
          const IndicatorsPage(),
          const FieldsPage(),
          const ColorsPage(),
          const DialogsPage(),
          const ToolbarPage(),
          const SliverToolbarPage(isVisible: !kIsWeb),
          const TabViewPage(),
          const ResizablePanePage(),
          const SelectorsPage(),
          const TypographyPage(),
        ][pageIndex],
      ),
    );
  }
}
