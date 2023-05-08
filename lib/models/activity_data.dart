import 'dart:convert';

import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  final String? id;
  final String name;
  final int grade;

  const Subject({
    this.id,
    required this.name,
    required this.grade,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['_id'] as String,
      name: map['name'] as String,
      grade: map['grade'] as int,
    );
  }

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Subject(id: $id, name: $name, grade: $grade)';

  @override
  List<Object?> get props => [id, name, grade];
}

class Topic extends Equatable {
  final String id;
  Subject? subject;
  final String title;
  final int seq;
  Topic({
    required this.id,
    required this.title,
    this.subject,
    required this.seq,
  });

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['_id'] as String,
      subject: Subject.fromMap(map['subject'] as Map<String, dynamic>),
      title: map['title'] as String,
      seq: map['seq'] as int,
    );
  }

  factory Topic.fromJson(String source) =>
      Topic.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Topic(id: $id, subject: $subject, title: $title, seq: $seq)';
  }

  @override
  List<Object?> get props => [id, subject, title, seq];
}

class Activity extends Equatable {
  final String id;
  final String name;
  final String videoUrl;
  final String description;
  final int seq;
  Activity({
    required this.id,
    required this.name,
    required this.videoUrl,
    required this.description,
    required this.seq,
  });

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['_id'] as String,
      name: map['name'] as String,
      videoUrl: map['videoUrl'] as String,
      description: map['description'] as String,
      seq: map['seq'] as int,
    );
  }
  factory Activity.fromJson(String source) =>
      Activity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Activity(id: $id,name: $name, videoUrl: $videoUrl, description: $description, seq: $seq)';
  }

  @override
  List<Object?> get props => [name, videoUrl, description, seq];
}
