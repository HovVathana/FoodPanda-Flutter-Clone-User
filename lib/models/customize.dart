import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Choice {
  final String choice;
  final double price;
  Choice({
    required this.choice,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'choice': choice,
      'price': price,
    };
  }

  factory Choice.fromMap(Map<String, dynamic> map) {
    return Choice(
      choice: map['choice'] as String,
      price: map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Choice.fromJson(String source) =>
      Choice.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Customize {
  final String title;
  final bool isRequired;
  final bool isRadio;
  final bool isVariation;
  final int selectAmount;
  final List<Choice> choices;
  Customize({
    required this.title,
    required this.isRequired,
    required this.isRadio,
    required this.isVariation,
    required this.selectAmount,
    required this.choices,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isRequired': isRequired,
      'isRadio': isRadio,
      'isVariation': isVariation,
      'selectAmount': selectAmount,
      'choices': choices,
    };
  }

  factory Customize.fromMap(Map<String, dynamic> map) {
    return Customize(
      title: map['title'] as String,
      isRequired: map['isRequired'] as bool,
      isRadio: map['isRadio'] as bool,
      isVariation: map['isVariation'] as bool,
      selectAmount: map['selectAmount'] as int,
      choices: List<Choice>.from(
        (map['choices']).map<Choice>(
          (x) => Choice.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Customize.fromJson(String source) =>
      Customize.fromMap(json.decode(source) as Map<String, dynamic>);
}
