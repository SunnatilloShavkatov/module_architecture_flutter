# Data Models (Stable Standard)

This document defines a fixed model-writing standard for this repository.

## 1. Why This Is Strict

Model parsing errors break runtime behavior.  
Do not invent a new parse style for each feature.

Use this same model standard every time unless task explicitly requires a migration.

## 2. Model Location

- `modules/<module>/lib/src/data/models/<name>_model.dart`

## 3. Non-Negotiable Rules

- model extends domain entity;
- entity contains no JSON parsing;
- model contains `fromMap` and `toMap`;
- include `fromEntity` when mapping is needed in repository flow;
- list fields must be non-null and `required`;
- scalar/object fields should be nullable by default for API response contracts;
- do not force fallback values like `''`, `0`, `false` unless business rule explicitly requires it;
- always parse nested map/list with type checks.

## 4. Required Parse Contract

For `fromMap`:

- if API response is wrapped, safely extract wrapper map (example: `result`);
- initialize list fields as empty list first;
- only iterate when source is `List`;
- parse each child via child model `fromMap`;
- use nullable casts for scalar fields (`as String?`, `as int?`, `as double?`, ...).

For `toMap`:

- keep serialization in model only;
- serialize nested list using each child model `toMap`.

## 5. Reference Template (Survey Shape)

```dart
class SurveyModel extends Survey {
  const SurveyModel({
    required super.id,
    required super.title,
    required super.questions,
    required super.coin,
    required super.point,
  });

  factory SurveyModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> data =
        map['result'] is Map<String, dynamic> ? map['result'] as Map<String, dynamic> : <String, dynamic>{};
    final List<SurveyQuestionModel> questions = [];

    if (data['questions'] is List) {
      final List<dynamic> items = data['questions'] as List<dynamic>;
      for (int i = 0; i < items.length; i++) {
        final dynamic item = items[i];
        if (item is Map<String, dynamic>) {
          questions.add(SurveyQuestionModel.fromMap(item));
        }
      }
    }

    return SurveyModel(
      id: data['id'] as String?,
      title: data['name'] as String?,
      questions: questions,
      coin: data['coin'] as int?,
      point: data['point'] as int?,
    );
  }

  factory SurveyModel.fromEntity(Survey entity) {
    final List<SurveyQuestionModel> questions = [];
    for (int i = 0; i < entity.questions.length; i++) {
      questions.add(SurveyQuestionModel.fromEntity(entity.questions[i]));
    }

    return SurveyModel(
      id: entity.id,
      title: entity.title,
      questions: questions,
      coin: entity.coin,
      point: entity.point,
    );
  }

  Map<String, dynamic> toMap() {
    final List<Map<String, dynamic>> questions = [];
    for (int i = 0; i < this.questions.length; i++) {
      questions.add((this.questions[i] as SurveyQuestionModel).toMap());
    }

    return {
      'id': id,
      'name': title,
      'coin': coin,
      'point': point,
      'questions': questions,
    };
  }
}

class SurveyQuestionModel extends SurveyQuestion {
  const SurveyQuestionModel({
    required super.id,
    required super.text,
    required super.type,
    required super.answers,
    required super.fileUrl,
  });

  factory SurveyQuestionModel.fromMap(Map<String, dynamic> map) {
    final List<SurveyOptionModel> answers = [];
    if (map['answers'] is List) {
      final List<dynamic> items = map['answers'] as List<dynamic>;
      for (int i = 0; i < items.length; i++) {
        final dynamic item = items[i];
        if (item is Map<String, dynamic>) {
          answers.add(SurveyOptionModel.fromMap(item));
        }
      }
    }

    return SurveyQuestionModel(
      id: map['id'] as int?,
      text: map['text'] as String?,
      type: map['type'] as int?,
      answers: answers,
      fileUrl: map['file_url'] as String?,
    );
  }

  factory SurveyQuestionModel.fromEntity(SurveyQuestion entity) {
    final List<SurveyOptionModel> answers = [];
    for (int i = 0; i < entity.answers.length; i++) {
      answers.add(SurveyOptionModel.fromEntity(entity.answers[i]));
    }

    return SurveyQuestionModel(
      id: entity.id,
      text: entity.text,
      type: entity.type,
      answers: answers,
      fileUrl: entity.fileUrl,
    );
  }

  Map<String, dynamic> toMap() {
    final List<Map<String, dynamic>> answers = [];
    for (int i = 0; i < this.answers.length; i++) {
      answers.add((this.answers[i] as SurveyOptionModel).toMap());
    }

    return {
      'id': id,
      'text': text,
      'type': type,
      'file_url': fileUrl,
      'answers': answers,
    };
  }
}

class SurveyOptionModel extends SurveyOption {
  const SurveyOptionModel({super.id, super.text});

  factory SurveyOptionModel.fromMap(Map<String, dynamic> map) {
    return SurveyOptionModel(
      id: map['id'] as int?,
      text: map['text'] as String?,
    );
  }

  factory SurveyOptionModel.fromEntity(SurveyOption entity) {
    return SurveyOptionModel(
      id: entity.id,
      text: entity.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }
}
```

## 6. Do Not Do

- parse JSON in entity, repository, bloc, page, or widget;
- assume list fields can be null;
- skip map/list type checks;
- use ad-hoc fallback values without business requirement.

## 7. Model Checklist

- [ ] extends correct entity
- [ ] `fromMap` exists
- [ ] `toMap` exists
- [ ] `fromEntity` added when needed
- [ ] list fields parsed as non-null lists
- [ ] scalar/object fields parsed as nullable
- [ ] nested map/list parsing uses runtime type checks
