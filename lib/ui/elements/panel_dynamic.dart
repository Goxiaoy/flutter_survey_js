import 'package:flutter/material.dart';
import 'package:flutter_survey_js/survey.dart' as s;
import 'package:flutter_survey_js/ui/form_control.dart';
import 'package:flutter_survey_js/ui/reactive/reactive_nested_form.dart';
import 'package:flutter_survey_js/ui/reactive/reactive_nested_group_array.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'question_title.dart';
import 'survey_element_factory.dart';

final SurveyElementBuilder panelDynamicBuilder =
    (context, element, {bool hasTitle = true}) {
  return PanelDynamicElement(
    formControlName: element.name!,
    element: element as s.PanelDynamic,
  ).wrapQuestionTitle(element, hasTitle: hasTitle);
};

class PanelDynamicElement extends StatelessWidget {
  final String formControlName;
  final s.PanelDynamic element;

  const PanelDynamicElement(
      {Key? key, required this.formControlName, required this.element})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createNew = () {
      //create new formGroup
      return elementsToFormGroup((element.templateElements ?? []).toList());
    };
    return ReactiveNestedGroupArray(
        createNew: createNew,
        formArrayName: formControlName,
        builder: (BuildContext context, FormGroup form, Widget? child) {
          return Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black26)),
              child: ReactiveNestedForm(
                  formGroup: form,
                  child: ListView.separated(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: element.templateElements?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final res = SurveyElementFactory()
                          .resolve(context, element.templateElements![index]);
                      return res;
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SurveyElementFactory().separatorBuilder(context);
                    },
                  )));
        });
  }
}
