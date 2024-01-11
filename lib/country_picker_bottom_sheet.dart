import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryPickerBottomSheet extends StatefulWidget {
  /// Here we have to provide the country list for showing the data.
  final List<Map<String, String>> countryList;

  /// this parameter is use to set initial selected value in country picker.
  final String? initialValue;

  /// this parameter is use to set text-style of country code and country name.
  final TextStyle? textStyle;

  /// this parameter is use to remove particular country from our list.
  final List<String>? excludeCountry;

  /// text overflow in use to mange text overflow for country name.
  final TextOverflow textOverflow;

  /// this properties is use for hide-show country flag in our screen.
  final bool showCountryMainFlag;

  /// this properties is use for hide-show country flag in our bottom sheet list.
  final bool showCountryFlag;

  /// this properties is use for hide-show country code in our screen.
  final bool showCountryMainCode;

  /// this properties is use for hide-show country code in our bottom sheet list.
  final bool showCountryCode;

  /// this properties is use for hide-show country name in our screen.
  final bool showCountryMainName;

  /// this properties is use for hide-show country name in our bottom sheet list.
  final bool showCountryName;

  /// [BoxDecoration] for the flag image
  final Decoration? flagDecoration;

  /// Width of the flag images
  final double? flagWidth;

  /// Height of the flag images
  final double? flagHeight;

  /// this properties is used to provide height of country picker.
  final double? heightOfPicker;

  /// Bottom sheet properties

  /// Whether to avoid system intrusions on the top, left, and right.
  /// If true, a [SafeArea] is inserted to keep the bottom sheet away from
  /// system intrusions at the top, left, and right sides of the screen.
  ///
  /// If false, the bottom sheet isn't exposed to the top padding of the
  /// MediaQuery.
  ///
  /// In either case, the bottom sheet extends all the way to the bottom of
  /// the screen, including any system intrusions.
  ///
  /// The default is false.
  final bool useSafeArea;

  /// The drag handle appears at the top of the bottom sheet. The default color is
  /// [ColorScheme.onSurfaceVariant] with an opacity of 0.4 and can be customized
  /// using dragHandleColor. The default size is `Size(32,4)` and can be customized
  /// with dragHandleSize.
  ///
  /// If null, then the value of  [BottomSheetThemeData.showDragHandle] is used. If
  /// that is also null, defaults to false.
  final bool showDragHandle;

  final bool? useRootNavigator;

  final AnimationController? transitionAnimationController;

  /// Cupertino picker properties

  /// Relative ratio between this picker's height and the simulated cylinder's diameter.
  ///
  /// Smaller values creates more pronounced curvatures in the scrollable wheel.
  ///
  /// For more details, see [ListWheelScrollView.diameterRatio].
  ///
  /// Defaults to 1.1 to visually mimic iOS.
  final double diameterRatio;

  /// The uniform height of all children.
  ///
  /// All children will be given the [BoxConstraints] to match this exact
  /// height. Must be a positive value.
  final double? itemExtent;

  /// A widget overlaid on the picker to highlight the currently selected entry.
  ///
  /// The [selectionOverlay] widget drawn above the [CupertinoPicker]'s picker
  /// wheel.
  /// It is vertically centered in the picker and is constrained to have the
  /// same height as the center row.
  ///
  /// If unspecified, it defaults to a [CupertinoPickerDefaultSelectionOverlay]
  /// which is a gray rounded rectangle overlay in iOS 14 style.
  /// This property can be set to null to remove the overlay.
  final Widget? selectionOverlayWidget;

  /// Background color behind the children.
  ///
  /// Defaults to null, which disables background painting entirely.
  /// (i.e. the picker is going to have a completely transparent background), to match
  /// the native UIPicker and UIDatePicker.
  ///
  /// Any alpha value less 255 (fully opaque) will cause the removal of the
  /// wheel list edge fade gradient from rendering of the widget.
  final Color? backgroundColor;

  final double offAxisFraction;
  final double squeeze;
  final double magnification;
  final bool useMagnifier;

  /// used to provide custom data.
  final CountryPickerThemeData? countryPickerThemeData;

  /// using this comparator to change the order of options.
  final Comparator<CountryCode>? comparator;

  /// used to customize the country list
  final List<String>? countryFilter;

  const CountryPickerBottomSheet({
    super.key,
    this.countryList = codes,
    this.initialValue,
    this.textStyle,
    this.excludeCountry,
    this.textOverflow = TextOverflow.ellipsis,
    this.showCountryMainFlag = true,
    this.showCountryFlag = true,
    this.showCountryMainCode = true,
    this.showCountryCode = true,
    this.showCountryMainName = true,
    this.showCountryName = true,
    this.flagDecoration,
    this.flagWidth,
    this.flagHeight,
    this.heightOfPicker,
    this.useSafeArea = true,
    this.showDragHandle = false,
    this.useRootNavigator,
    this.transitionAnimationController,
    this.diameterRatio = 1.1,
    this.itemExtent,
    this.selectionOverlayWidget,
    this.backgroundColor,
    this.offAxisFraction = 0.2,
    this.squeeze = 1.45,
    this.magnification = 1.0,
    this.useMagnifier = true,
    this.countryPickerThemeData,
    this.comparator,
    this.countryFilter,
  })  : assert((showCountryMainFlag || showCountryMainCode || showCountryMainName), 'At-least one data we need to show in a widget.'),
        assert((showCountryFlag || showCountryCode || showCountryName), 'At-least one data we need to show in a our country list.'),
        assert(((excludeCountry == null) || (countryFilter == null)),
            'We will provide either exclude country or country filter, So we are not providing both at a same time.');

  @override
  // ignore: no_logic_in_create_state
  State<CountryPickerBottomSheet> createState() {
    List<CountryCode> elements = countryList.map((json) => CountryCode.fromJson(json)).toList();

    if (comparator != null) {
      elements.sort(comparator);
    }

    if (countryFilter != null && countryFilter!.isNotEmpty) {
      final uppercaseFilterElement = countryFilter?.map((e) => e.toUpperCase()).toList();
      elements = elements
          .where((element) =>
              uppercaseFilterElement!.contains(element.name) ||
              uppercaseFilterElement.contains(element.dialCode) ||
              uppercaseFilterElement.contains(element.code))
          .toList();
    }
    return CountryPickerBottomSheetState(elements);
  }
}

class CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  CountryCode? selectedItem;
  List<CountryCode> elements = [];
  int initialItem = 0;

  CountryPickerBottomSheetState(this.elements);

  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 16);

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      selectedItem = elements.firstWhere(
          (item) =>
              (item.code!.toUpperCase() == widget.initialValue!.toUpperCase()) ||
              (item.dialCode == widget.initialValue) ||
              (item.name!.toUpperCase() == widget.initialValue!.toUpperCase()),
          orElse: () => elements[0]);

      for (int i = 0; i < elements.length; i++) {
        if (selectedItem == elements[i]) {
          initialItem = i;
        }
      }
    } else {
      selectedItem = elements[0];
      initialItem = 0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    elements = elements.map((element) => element.localize(context)).toList();

    if ((widget.excludeCountry?.isNotEmpty ?? false) && widget.excludeCountry != null) {
      for (int i = 0; i < (widget.excludeCountry?.length ?? 0); i++) {
        for (int j = 0; j < elements.length; j++) {
          if ((widget.excludeCountry?[i].toLowerCase() == elements[j].name?.toLowerCase()) ||
              (widget.excludeCountry?[i] == elements[j].dialCode) ||
              (widget.excludeCountry?[i].toUpperCase() == elements[j].code)) {
            elements.removeAt(j);
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showCountryPickerBottomSheet();
      },
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.showCountryMainFlag)
            Container(
              clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
              decoration: widget.flagDecoration,
              margin: const EdgeInsets.only(right: 12),
              child: Image.asset(
                selectedItem!.flagUri!,
                package: 'country_picker',
                fit: BoxFit.cover,
                width: widget.flagWidth ?? 32,
                height: widget.flagHeight ?? 20,
              ),
            ),
          Text(
            '${widget.showCountryMainCode ? selectedItem!.dialCode ?? '' : ''} ${widget.showCountryMainName ? selectedItem!.name! : ''}',
            style: widget.countryPickerThemeData?.textStyle ?? _defaultTextStyle,
            overflow: widget.textOverflow,
          ),
        ],
      ),
    );
  }

  void showCountryPickerBottomSheet() async {
    if ((widget.initialValue != null) || (selectedItem != null)) {
      for (int i = 0; i < elements.length; i++) {
        if (selectedItem == elements[i]) {
          initialItem = i;
        }
      }
    } else {
      initialItem = 0;
    }

    await showModalBottomSheet(
      backgroundColor: widget.countryPickerThemeData?.modalBackgroundColor ?? Theme.of(context).bottomSheetTheme.modalBackgroundColor,
      barrierColor: widget.countryPickerThemeData?.modalBarrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
      elevation: widget.countryPickerThemeData?.modalElevation ?? Theme.of(context).bottomSheetTheme.modalElevation,
      transitionAnimationController: widget.transitionAnimationController,
      clipBehavior: widget.countryPickerThemeData?.clipBehavior ?? Theme.of(context).bottomSheetTheme.clipBehavior,
      useRootNavigator: widget.useRootNavigator ?? false,
      showDragHandle: widget.showDragHandle,
      useSafeArea: widget.useSafeArea,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: widget.heightOfPicker ?? 250,
              child: CupertinoPicker(
                selectionOverlay: widget.selectionOverlayWidget ??
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                magnification: widget.magnification,
                useMagnifier: widget.useMagnifier,
                squeeze: widget.squeeze,
                offAxisFraction: widget.offAxisFraction,
                itemExtent: widget.itemExtent ?? 32,
                backgroundColor: widget.backgroundColor,
                onSelectedItemChanged: (int value) {
                  setState(() {
                    HapticFeedback.heavyImpact();
                    selectedItem = elements[value];
                  });
                },
                scrollController: FixedExtentScrollController(initialItem: initialItem),
                children: List<Widget>.generate(
                  elements.length,
                  (int index) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (widget.showCountryFlag)
                            Container(
                              clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
                              decoration: widget.flagDecoration,
                              margin: const EdgeInsets.only(right: 12),
                              child: Image.asset(
                                elements[index].flagUri ?? "",
                                package: 'country_picker',
                                fit: BoxFit.cover,
                                width: widget.flagWidth ?? 32,
                                height: widget.flagHeight ?? 20,
                              ),
                            ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              '${widget.showCountryCode ? elements[index].dialCode ?? '' : ''}  ${widget.showCountryName ? elements[index].name : ''}',
                              overflow: TextOverflow.ellipsis,
                              style: widget.countryPickerThemeData?.textStyle ?? _defaultTextStyle,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
