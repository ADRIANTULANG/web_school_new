import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:web_school/models/option.dart';

class CustomDropdown<T> extends FormField<T> {
  CustomDropdown({
    Key? key,
    required String label,
    required String hintText,
    bool enabled = true,
    T? value,
    required List<SchoolDropdownMenuItem<T>> items,
    FormFieldSetter<T?>? onSaved,
    FormFieldValidator<T?>? validator,
    T? initialValue,
    AutovalidateMode? autovalidateMode,
    ValueChanged<T?>? onChanged,
  }) : super(
    key: key,
    enabled: enabled,
    onSaved: onSaved,
    validator: validator,
    initialValue: value,
    autovalidateMode: autovalidateMode,
    builder: (FormFieldState<T> state) {
      return Builder(
          builder: (context) {
            final ThemeData theme = Theme.of(context);

            void Function()? onTap() {
              showModalBottomSheet<dynamic>(
                context: context,
                useSafeArea: true,
                barrierColor: Colors.black.withOpacity(0.5),
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Wrap(
                      children: [
                        WillPopScope(
                          onWillPop: () async {
                            if (value == null) {
                              state.validate();
                            }
                            return true;
                          },
                          child: Card(
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Select Option",
                                      style: theme.textTheme.headlineSmall!,
                                    ),
                                    const SizedBox(height: 16.0),
                                    if (items.length > 10)
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.6,
                                        child: RawScrollbar(
                                          thumbColor: theme.colorScheme.primary,
                                          thumbVisibility: true,
                                          trackBorderColor: Colors.transparent,
                                          trackVisibility: true,
                                          trackColor: const Color(0xFFF0F0F0),
                                          trackRadius: const Radius.circular(50.0),
                                          radius: const Radius.circular(20.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.only(right: 20.0),
                                            itemCount: items.length,
                                            itemBuilder: (context, index) {

                                              final SchoolDropdownMenuItem<T> item = items[index];

                                              return InkWell(
                                                splashColor: const Color(0xFFE0F8E5),
                                                highlightColor: const Color(0xFFE0F8E5),
                                                borderRadius: BorderRadius.circular(16.0),
                                                onTap: () {
                                                  state.didChange(item.value);

                                                  Navigator.of(context).pop();

                                                  if (onChanged != null) {
                                                    onChanged(item.value);
                                                  }

                                                  state.validate();
                                                },
                                                child: items[index].child,
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                    if (items.length <= 10)
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: items.map((SchoolDropdownMenuItem<T> item) {
                                            return InkWell(
                                              splashColor: const Color(0xFFE0F8E5),
                                              highlightColor: const Color(0xFFE0F8E5),
                                              borderRadius: BorderRadius.circular(16.0),
                                              onTap: () {
                                                state.didChange(item.value);

                                                Navigator.of(context).pop();

                                                if (onChanged != null) {
                                                  onChanged(item.value);
                                                }

                                                state.validate();
                                              },
                                              child: item.child,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

              return null;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(label,
                  style: const TextStyle(
                    color: Color(0xFF606060),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4.0),
                InkWell(
                  onTap: enabled ? onTap : null,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        width: 1.0,
                        color: state.hasError
                            ? theme.colorScheme.error
                            : Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(value != null
                              ? items[items.indexWhere((SchoolDropdownMenuItem item) => item.value == value)].label
                              : hintText,
                              style: value != null
                                  ? theme.textTheme.bodyMedium
                                  : theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.grey,
                              )
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.arrow_drop_down)
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, top: 8.0),
                  child: Text(state.hasError
                      ? "${state.errorText}"
                      : "",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
              ],
            );
          }
      );
    },
  );
}
