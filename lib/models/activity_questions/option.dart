
class Option {
  final String key;
  final String option;
  const Option({required this.key,required this.option});

  @override
  String toString() => 'Option(key: $key, option: $option)';

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        key: json['key'] as String,
        option: json['option'] as String,
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'option': option,
      };
}
