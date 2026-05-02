// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atelier_database.dart';

// ignore_for_file: type=lint
class $GoalCategoriesTableTable extends GoalCategoriesTable
    with TableInfo<$GoalCategoriesTableTable, GoalCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalCategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAddSlotMeta = const VerificationMeta(
    'isAddSlot',
  );
  @override
  late final GeneratedColumn<bool> isAddSlot = GeneratedColumn<bool>(
    'is_add_slot',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_add_slot" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder, isAddSlot];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_add_slot')) {
      context.handle(
        _isAddSlotMeta,
        isAddSlot.isAcceptableOrUnknown(data['is_add_slot']!, _isAddSlotMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalCategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isAddSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_add_slot'],
      )!,
    );
  }

  @override
  $GoalCategoriesTableTable createAlias(String alias) {
    return $GoalCategoriesTableTable(attachedDatabase, alias);
  }
}

class GoalCategoryRow extends DataClass implements Insertable<GoalCategoryRow> {
  final String id;
  final String name;
  final int sortOrder;
  final bool isAddSlot;
  const GoalCategoryRow({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.isAddSlot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_add_slot'] = Variable<bool>(isAddSlot);
    return map;
  }

  GoalCategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return GoalCategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isAddSlot: Value(isAddSlot),
    );
  }

  factory GoalCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalCategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isAddSlot: serializer.fromJson<bool>(json['isAddSlot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isAddSlot': serializer.toJson<bool>(isAddSlot),
    };
  }

  GoalCategoryRow copyWith({
    String? id,
    String? name,
    int? sortOrder,
    bool? isAddSlot,
  }) => GoalCategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isAddSlot: isAddSlot ?? this.isAddSlot,
  );
  GoalCategoryRow copyWithCompanion(GoalCategoriesTableCompanion data) {
    return GoalCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isAddSlot: data.isAddSlot.present ? data.isAddSlot.value : this.isAddSlot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalCategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isAddSlot: $isAddSlot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, isAddSlot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalCategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isAddSlot == this.isAddSlot);
}

class GoalCategoriesTableCompanion extends UpdateCompanion<GoalCategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isAddSlot;
  final Value<int> rowid;
  const GoalCategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isAddSlot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalCategoriesTableCompanion.insert({
    required String id,
    required String name,
    required int sortOrder,
    this.isAddSlot = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<GoalCategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isAddSlot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isAddSlot != null) 'is_add_slot': isAddSlot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalCategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isAddSlot,
    Value<int>? rowid,
  }) {
    return GoalCategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isAddSlot: isAddSlot ?? this.isAddSlot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isAddSlot.present) {
      map['is_add_slot'] = Variable<bool>(isAddSlot.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalCategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isAddSlot: $isAddSlot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTableTable extends GoalsTable
    with TableInfo<$GoalsTableTable, GoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalCategoryIdMeta = const VerificationMeta(
    'goalCategoryId',
  );
  @override
  late final GeneratedColumn<String> goalCategoryId = GeneratedColumn<String>(
    'goal_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goal_categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starredMeta = const VerificationMeta(
    'starred',
  );
  @override
  late final GeneratedColumn<bool> starred = GeneratedColumn<bool>(
    'starred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("starred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalCategoryId,
    title,
    starred,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_category_id')) {
      context.handle(
        _goalCategoryIdMeta,
        goalCategoryId.isAcceptableOrUnknown(
          data['goal_category_id']!,
          _goalCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_goalCategoryIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('starred')) {
      context.handle(
        _starredMeta,
        starred.isAcceptableOrUnknown(data['starred']!, _starredMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_category_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      starred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}starred'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $GoalsTableTable createAlias(String alias) {
    return $GoalsTableTable(attachedDatabase, alias);
  }
}

class GoalRow extends DataClass implements Insertable<GoalRow> {
  final String id;
  final String goalCategoryId;
  final String title;
  final bool starred;
  final DateTime addedAt;
  const GoalRow({
    required this.id,
    required this.goalCategoryId,
    required this.title,
    required this.starred,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_category_id'] = Variable<String>(goalCategoryId);
    map['title'] = Variable<String>(title);
    map['starred'] = Variable<bool>(starred);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  GoalsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalsTableCompanion(
      id: Value(id),
      goalCategoryId: Value(goalCategoryId),
      title: Value(title),
      starred: Value(starred),
      addedAt: Value(addedAt),
    );
  }

  factory GoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalRow(
      id: serializer.fromJson<String>(json['id']),
      goalCategoryId: serializer.fromJson<String>(json['goalCategoryId']),
      title: serializer.fromJson<String>(json['title']),
      starred: serializer.fromJson<bool>(json['starred']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalCategoryId': serializer.toJson<String>(goalCategoryId),
      'title': serializer.toJson<String>(title),
      'starred': serializer.toJson<bool>(starred),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  GoalRow copyWith({
    String? id,
    String? goalCategoryId,
    String? title,
    bool? starred,
    DateTime? addedAt,
  }) => GoalRow(
    id: id ?? this.id,
    goalCategoryId: goalCategoryId ?? this.goalCategoryId,
    title: title ?? this.title,
    starred: starred ?? this.starred,
    addedAt: addedAt ?? this.addedAt,
  );
  GoalRow copyWithCompanion(GoalsTableCompanion data) {
    return GoalRow(
      id: data.id.present ? data.id.value : this.id,
      goalCategoryId: data.goalCategoryId.present
          ? data.goalCategoryId.value
          : this.goalCategoryId,
      title: data.title.present ? data.title.value : this.title,
      starred: data.starred.present ? data.starred.value : this.starred,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalRow(')
          ..write('id: $id, ')
          ..write('goalCategoryId: $goalCategoryId, ')
          ..write('title: $title, ')
          ..write('starred: $starred, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalCategoryId, title, starred, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalRow &&
          other.id == this.id &&
          other.goalCategoryId == this.goalCategoryId &&
          other.title == this.title &&
          other.starred == this.starred &&
          other.addedAt == this.addedAt);
}

class GoalsTableCompanion extends UpdateCompanion<GoalRow> {
  final Value<String> id;
  final Value<String> goalCategoryId;
  final Value<String> title;
  final Value<bool> starred;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const GoalsTableCompanion({
    this.id = const Value.absent(),
    this.goalCategoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.starred = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsTableCompanion.insert({
    required String id,
    required String goalCategoryId,
    required String title,
    this.starred = const Value.absent(),
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalCategoryId = Value(goalCategoryId),
       title = Value(title),
       addedAt = Value(addedAt);
  static Insertable<GoalRow> custom({
    Expression<String>? id,
    Expression<String>? goalCategoryId,
    Expression<String>? title,
    Expression<bool>? starred,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalCategoryId != null) 'goal_category_id': goalCategoryId,
      if (title != null) 'title': title,
      if (starred != null) 'starred': starred,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? goalCategoryId,
    Value<String>? title,
    Value<bool>? starred,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return GoalsTableCompanion(
      id: id ?? this.id,
      goalCategoryId: goalCategoryId ?? this.goalCategoryId,
      title: title ?? this.title,
      starred: starred ?? this.starred,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalCategoryId.present) {
      map['goal_category_id'] = Variable<String>(goalCategoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (starred.present) {
      map['starred'] = Variable<bool>(starred.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('goalCategoryId: $goalCategoryId, ')
          ..write('title: $title, ')
          ..write('starred: $starred, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $YearGoalsTableTable extends YearGoalsTable
    with TableInfo<$YearGoalsTableTable, YearGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $YearGoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalCategoryIdMeta = const VerificationMeta(
    'goalCategoryId',
  );
  @override
  late final GeneratedColumn<String> goalCategoryId = GeneratedColumn<String>(
    'goal_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goal_categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expandedMeta = const VerificationMeta(
    'expanded',
  );
  @override
  late final GeneratedColumn<bool> expanded = GeneratedColumn<bool>(
    'expanded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("expanded" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, goalCategoryId, title, expanded];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'year_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<YearGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_category_id')) {
      context.handle(
        _goalCategoryIdMeta,
        goalCategoryId.isAcceptableOrUnknown(
          data['goal_category_id']!,
          _goalCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_goalCategoryIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('expanded')) {
      context.handle(
        _expandedMeta,
        expanded.isAcceptableOrUnknown(data['expanded']!, _expandedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  YearGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return YearGoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_category_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      expanded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}expanded'],
      )!,
    );
  }

  @override
  $YearGoalsTableTable createAlias(String alias) {
    return $YearGoalsTableTable(attachedDatabase, alias);
  }
}

class YearGoalRow extends DataClass implements Insertable<YearGoalRow> {
  final String id;
  final String goalCategoryId;
  final String title;
  final bool expanded;
  const YearGoalRow({
    required this.id,
    required this.goalCategoryId,
    required this.title,
    required this.expanded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_category_id'] = Variable<String>(goalCategoryId);
    map['title'] = Variable<String>(title);
    map['expanded'] = Variable<bool>(expanded);
    return map;
  }

  YearGoalsTableCompanion toCompanion(bool nullToAbsent) {
    return YearGoalsTableCompanion(
      id: Value(id),
      goalCategoryId: Value(goalCategoryId),
      title: Value(title),
      expanded: Value(expanded),
    );
  }

  factory YearGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return YearGoalRow(
      id: serializer.fromJson<String>(json['id']),
      goalCategoryId: serializer.fromJson<String>(json['goalCategoryId']),
      title: serializer.fromJson<String>(json['title']),
      expanded: serializer.fromJson<bool>(json['expanded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalCategoryId': serializer.toJson<String>(goalCategoryId),
      'title': serializer.toJson<String>(title),
      'expanded': serializer.toJson<bool>(expanded),
    };
  }

  YearGoalRow copyWith({
    String? id,
    String? goalCategoryId,
    String? title,
    bool? expanded,
  }) => YearGoalRow(
    id: id ?? this.id,
    goalCategoryId: goalCategoryId ?? this.goalCategoryId,
    title: title ?? this.title,
    expanded: expanded ?? this.expanded,
  );
  YearGoalRow copyWithCompanion(YearGoalsTableCompanion data) {
    return YearGoalRow(
      id: data.id.present ? data.id.value : this.id,
      goalCategoryId: data.goalCategoryId.present
          ? data.goalCategoryId.value
          : this.goalCategoryId,
      title: data.title.present ? data.title.value : this.title,
      expanded: data.expanded.present ? data.expanded.value : this.expanded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('YearGoalRow(')
          ..write('id: $id, ')
          ..write('goalCategoryId: $goalCategoryId, ')
          ..write('title: $title, ')
          ..write('expanded: $expanded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalCategoryId, title, expanded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is YearGoalRow &&
          other.id == this.id &&
          other.goalCategoryId == this.goalCategoryId &&
          other.title == this.title &&
          other.expanded == this.expanded);
}

class YearGoalsTableCompanion extends UpdateCompanion<YearGoalRow> {
  final Value<String> id;
  final Value<String> goalCategoryId;
  final Value<String> title;
  final Value<bool> expanded;
  final Value<int> rowid;
  const YearGoalsTableCompanion({
    this.id = const Value.absent(),
    this.goalCategoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.expanded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  YearGoalsTableCompanion.insert({
    required String id,
    required String goalCategoryId,
    required String title,
    this.expanded = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalCategoryId = Value(goalCategoryId),
       title = Value(title);
  static Insertable<YearGoalRow> custom({
    Expression<String>? id,
    Expression<String>? goalCategoryId,
    Expression<String>? title,
    Expression<bool>? expanded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalCategoryId != null) 'goal_category_id': goalCategoryId,
      if (title != null) 'title': title,
      if (expanded != null) 'expanded': expanded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  YearGoalsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? goalCategoryId,
    Value<String>? title,
    Value<bool>? expanded,
    Value<int>? rowid,
  }) {
    return YearGoalsTableCompanion(
      id: id ?? this.id,
      goalCategoryId: goalCategoryId ?? this.goalCategoryId,
      title: title ?? this.title,
      expanded: expanded ?? this.expanded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalCategoryId.present) {
      map['goal_category_id'] = Variable<String>(goalCategoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (expanded.present) {
      map['expanded'] = Variable<bool>(expanded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('YearGoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('goalCategoryId: $goalCategoryId, ')
          ..write('title: $title, ')
          ..write('expanded: $expanded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AtelierDatabase extends GeneratedDatabase {
  _$AtelierDatabase(QueryExecutor e) : super(e);
  $AtelierDatabaseManager get managers => $AtelierDatabaseManager(this);
  late final $GoalCategoriesTableTable goalCategoriesTable =
      $GoalCategoriesTableTable(this);
  late final $GoalsTableTable goalsTable = $GoalsTableTable(this);
  late final $YearGoalsTableTable yearGoalsTable = $YearGoalsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    goalCategoriesTable,
    goalsTable,
    yearGoalsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'goal_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('goals', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'goal_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('year_goals', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$GoalCategoriesTableTableCreateCompanionBuilder =
    GoalCategoriesTableCompanion Function({
      required String id,
      required String name,
      required int sortOrder,
      Value<bool> isAddSlot,
      Value<int> rowid,
    });
typedef $$GoalCategoriesTableTableUpdateCompanionBuilder =
    GoalCategoriesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isAddSlot,
      Value<int> rowid,
    });

final class $$GoalCategoriesTableTableReferences
    extends
        BaseReferences<
          _$AtelierDatabase,
          $GoalCategoriesTableTable,
          GoalCategoryRow
        > {
  $$GoalCategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$GoalsTableTable, List<GoalRow>>
  _goalsTableRefsTable(_$AtelierDatabase db) => MultiTypedResultKey.fromTable(
    db.goalsTable,
    aliasName: $_aliasNameGenerator(
      db.goalCategoriesTable.id,
      db.goalsTable.goalCategoryId,
    ),
  );

  $$GoalsTableTableProcessedTableManager get goalsTableRefs {
    final manager = $$GoalsTableTableTableManager(
      $_db,
      $_db.goalsTable,
    ).filter((f) => f.goalCategoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$YearGoalsTableTable, List<YearGoalRow>>
  _yearGoalsTableRefsTable(_$AtelierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.yearGoalsTable,
        aliasName: $_aliasNameGenerator(
          db.goalCategoriesTable.id,
          db.yearGoalsTable.goalCategoryId,
        ),
      );

  $$YearGoalsTableTableProcessedTableManager get yearGoalsTableRefs {
    final manager = $$YearGoalsTableTableTableManager(
      $_db,
      $_db.yearGoalsTable,
    ).filter((f) => f.goalCategoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_yearGoalsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GoalCategoriesTableTableFilterComposer
    extends Composer<_$AtelierDatabase, $GoalCategoriesTableTable> {
  $$GoalCategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAddSlot => $composableBuilder(
    column: $table.isAddSlot,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> goalsTableRefs(
    Expression<bool> Function($$GoalsTableTableFilterComposer f) f,
  ) {
    final $$GoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalsTable,
      getReferencedColumn: (t) => t.goalCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.goalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> yearGoalsTableRefs(
    Expression<bool> Function($$YearGoalsTableTableFilterComposer f) f,
  ) {
    final $$YearGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.yearGoalsTable,
      getReferencedColumn: (t) => t.goalCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YearGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.yearGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalCategoriesTableTableOrderingComposer
    extends Composer<_$AtelierDatabase, $GoalCategoriesTableTable> {
  $$GoalCategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAddSlot => $composableBuilder(
    column: $table.isAddSlot,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalCategoriesTableTableAnnotationComposer
    extends Composer<_$AtelierDatabase, $GoalCategoriesTableTable> {
  $$GoalCategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isAddSlot =>
      $composableBuilder(column: $table.isAddSlot, builder: (column) => column);

  Expression<T> goalsTableRefs<T extends Object>(
    Expression<T> Function($$GoalsTableTableAnnotationComposer a) f,
  ) {
    final $$GoalsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalsTable,
      getReferencedColumn: (t) => t.goalCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.goalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> yearGoalsTableRefs<T extends Object>(
    Expression<T> Function($$YearGoalsTableTableAnnotationComposer a) f,
  ) {
    final $$YearGoalsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.yearGoalsTable,
      getReferencedColumn: (t) => t.goalCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YearGoalsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.yearGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalCategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AtelierDatabase,
          $GoalCategoriesTableTable,
          GoalCategoryRow,
          $$GoalCategoriesTableTableFilterComposer,
          $$GoalCategoriesTableTableOrderingComposer,
          $$GoalCategoriesTableTableAnnotationComposer,
          $$GoalCategoriesTableTableCreateCompanionBuilder,
          $$GoalCategoriesTableTableUpdateCompanionBuilder,
          (GoalCategoryRow, $$GoalCategoriesTableTableReferences),
          GoalCategoryRow,
          PrefetchHooks Function({bool goalsTableRefs, bool yearGoalsTableRefs})
        > {
  $$GoalCategoriesTableTableTableManager(
    _$AtelierDatabase db,
    $GoalCategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalCategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalCategoriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GoalCategoriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isAddSlot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalCategoriesTableCompanion(
                id: id,
                name: name,
                sortOrder: sortOrder,
                isAddSlot: isAddSlot,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int sortOrder,
                Value<bool> isAddSlot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalCategoriesTableCompanion.insert(
                id: id,
                name: name,
                sortOrder: sortOrder,
                isAddSlot: isAddSlot,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalCategoriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({goalsTableRefs = false, yearGoalsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (goalsTableRefs) db.goalsTable,
                    if (yearGoalsTableRefs) db.yearGoalsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (goalsTableRefs)
                        await $_getPrefetchedData<
                          GoalCategoryRow,
                          $GoalCategoriesTableTable,
                          GoalRow
                        >(
                          currentTable: table,
                          referencedTable: $$GoalCategoriesTableTableReferences
                              ._goalsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalCategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).goalsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (yearGoalsTableRefs)
                        await $_getPrefetchedData<
                          GoalCategoryRow,
                          $GoalCategoriesTableTable,
                          YearGoalRow
                        >(
                          currentTable: table,
                          referencedTable: $$GoalCategoriesTableTableReferences
                              ._yearGoalsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalCategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).yearGoalsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GoalCategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AtelierDatabase,
      $GoalCategoriesTableTable,
      GoalCategoryRow,
      $$GoalCategoriesTableTableFilterComposer,
      $$GoalCategoriesTableTableOrderingComposer,
      $$GoalCategoriesTableTableAnnotationComposer,
      $$GoalCategoriesTableTableCreateCompanionBuilder,
      $$GoalCategoriesTableTableUpdateCompanionBuilder,
      (GoalCategoryRow, $$GoalCategoriesTableTableReferences),
      GoalCategoryRow,
      PrefetchHooks Function({bool goalsTableRefs, bool yearGoalsTableRefs})
    >;
typedef $$GoalsTableTableCreateCompanionBuilder =
    GoalsTableCompanion Function({
      required String id,
      required String goalCategoryId,
      required String title,
      Value<bool> starred,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$GoalsTableTableUpdateCompanionBuilder =
    GoalsTableCompanion Function({
      Value<String> id,
      Value<String> goalCategoryId,
      Value<String> title,
      Value<bool> starred,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

final class $$GoalsTableTableReferences
    extends BaseReferences<_$AtelierDatabase, $GoalsTableTable, GoalRow> {
  $$GoalsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GoalCategoriesTableTable _goalCategoryIdTable(_$AtelierDatabase db) =>
      db.goalCategoriesTable.createAlias(
        $_aliasNameGenerator(
          db.goalsTable.goalCategoryId,
          db.goalCategoriesTable.id,
        ),
      );

  $$GoalCategoriesTableTableProcessedTableManager get goalCategoryId {
    final $_column = $_itemColumn<String>('goal_category_id')!;

    final manager = $$GoalCategoriesTableTableTableManager(
      $_db,
      $_db.goalCategoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalsTableTableFilterComposer
    extends Composer<_$AtelierDatabase, $GoalsTableTable> {
  $$GoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get starred => $composableBuilder(
    column: $table.starred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalCategoriesTableTableFilterComposer get goalCategoryId {
    final $$GoalCategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalCategoryId,
      referencedTable: $db.goalCategoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalCategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.goalCategoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableTableOrderingComposer
    extends Composer<_$AtelierDatabase, $GoalsTableTable> {
  $$GoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get starred => $composableBuilder(
    column: $table.starred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalCategoriesTableTableOrderingComposer get goalCategoryId {
    final $$GoalCategoriesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalCategoryId,
          referencedTable: $db.goalCategoriesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalCategoriesTableTableOrderingComposer(
                $db: $db,
                $table: $db.goalCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GoalsTableTableAnnotationComposer
    extends Composer<_$AtelierDatabase, $GoalsTableTable> {
  $$GoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get starred =>
      $composableBuilder(column: $table.starred, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$GoalCategoriesTableTableAnnotationComposer get goalCategoryId {
    final $$GoalCategoriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalCategoryId,
          referencedTable: $db.goalCategoriesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalCategoriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.goalCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GoalsTableTableTableManager
    extends
        RootTableManager<
          _$AtelierDatabase,
          $GoalsTableTable,
          GoalRow,
          $$GoalsTableTableFilterComposer,
          $$GoalsTableTableOrderingComposer,
          $$GoalsTableTableAnnotationComposer,
          $$GoalsTableTableCreateCompanionBuilder,
          $$GoalsTableTableUpdateCompanionBuilder,
          (GoalRow, $$GoalsTableTableReferences),
          GoalRow,
          PrefetchHooks Function({bool goalCategoryId})
        > {
  $$GoalsTableTableTableManager(_$AtelierDatabase db, $GoalsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalCategoryId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> starred = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion(
                id: id,
                goalCategoryId: goalCategoryId,
                title: title,
                starred: starred,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalCategoryId,
                required String title,
                Value<bool> starred = const Value.absent(),
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion.insert(
                id: id,
                goalCategoryId: goalCategoryId,
                title: title,
                starred: starred,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalCategoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalCategoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalCategoryId,
                                referencedTable: $$GoalsTableTableReferences
                                    ._goalCategoryIdTable(db),
                                referencedColumn: $$GoalsTableTableReferences
                                    ._goalCategoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AtelierDatabase,
      $GoalsTableTable,
      GoalRow,
      $$GoalsTableTableFilterComposer,
      $$GoalsTableTableOrderingComposer,
      $$GoalsTableTableAnnotationComposer,
      $$GoalsTableTableCreateCompanionBuilder,
      $$GoalsTableTableUpdateCompanionBuilder,
      (GoalRow, $$GoalsTableTableReferences),
      GoalRow,
      PrefetchHooks Function({bool goalCategoryId})
    >;
typedef $$YearGoalsTableTableCreateCompanionBuilder =
    YearGoalsTableCompanion Function({
      required String id,
      required String goalCategoryId,
      required String title,
      Value<bool> expanded,
      Value<int> rowid,
    });
typedef $$YearGoalsTableTableUpdateCompanionBuilder =
    YearGoalsTableCompanion Function({
      Value<String> id,
      Value<String> goalCategoryId,
      Value<String> title,
      Value<bool> expanded,
      Value<int> rowid,
    });

final class $$YearGoalsTableTableReferences
    extends
        BaseReferences<_$AtelierDatabase, $YearGoalsTableTable, YearGoalRow> {
  $$YearGoalsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GoalCategoriesTableTable _goalCategoryIdTable(_$AtelierDatabase db) =>
      db.goalCategoriesTable.createAlias(
        $_aliasNameGenerator(
          db.yearGoalsTable.goalCategoryId,
          db.goalCategoriesTable.id,
        ),
      );

  $$GoalCategoriesTableTableProcessedTableManager get goalCategoryId {
    final $_column = $_itemColumn<String>('goal_category_id')!;

    final manager = $$GoalCategoriesTableTableTableManager(
      $_db,
      $_db.goalCategoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$YearGoalsTableTableFilterComposer
    extends Composer<_$AtelierDatabase, $YearGoalsTableTable> {
  $$YearGoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get expanded => $composableBuilder(
    column: $table.expanded,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalCategoriesTableTableFilterComposer get goalCategoryId {
    final $$GoalCategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalCategoryId,
      referencedTable: $db.goalCategoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalCategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.goalCategoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$YearGoalsTableTableOrderingComposer
    extends Composer<_$AtelierDatabase, $YearGoalsTableTable> {
  $$YearGoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get expanded => $composableBuilder(
    column: $table.expanded,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalCategoriesTableTableOrderingComposer get goalCategoryId {
    final $$GoalCategoriesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalCategoryId,
          referencedTable: $db.goalCategoriesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalCategoriesTableTableOrderingComposer(
                $db: $db,
                $table: $db.goalCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$YearGoalsTableTableAnnotationComposer
    extends Composer<_$AtelierDatabase, $YearGoalsTableTable> {
  $$YearGoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get expanded =>
      $composableBuilder(column: $table.expanded, builder: (column) => column);

  $$GoalCategoriesTableTableAnnotationComposer get goalCategoryId {
    final $$GoalCategoriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalCategoryId,
          referencedTable: $db.goalCategoriesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalCategoriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.goalCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$YearGoalsTableTableTableManager
    extends
        RootTableManager<
          _$AtelierDatabase,
          $YearGoalsTableTable,
          YearGoalRow,
          $$YearGoalsTableTableFilterComposer,
          $$YearGoalsTableTableOrderingComposer,
          $$YearGoalsTableTableAnnotationComposer,
          $$YearGoalsTableTableCreateCompanionBuilder,
          $$YearGoalsTableTableUpdateCompanionBuilder,
          (YearGoalRow, $$YearGoalsTableTableReferences),
          YearGoalRow,
          PrefetchHooks Function({bool goalCategoryId})
        > {
  $$YearGoalsTableTableTableManager(
    _$AtelierDatabase db,
    $YearGoalsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$YearGoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$YearGoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$YearGoalsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalCategoryId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> expanded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => YearGoalsTableCompanion(
                id: id,
                goalCategoryId: goalCategoryId,
                title: title,
                expanded: expanded,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalCategoryId,
                required String title,
                Value<bool> expanded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => YearGoalsTableCompanion.insert(
                id: id,
                goalCategoryId: goalCategoryId,
                title: title,
                expanded: expanded,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$YearGoalsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalCategoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalCategoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalCategoryId,
                                referencedTable: $$YearGoalsTableTableReferences
                                    ._goalCategoryIdTable(db),
                                referencedColumn:
                                    $$YearGoalsTableTableReferences
                                        ._goalCategoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$YearGoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AtelierDatabase,
      $YearGoalsTableTable,
      YearGoalRow,
      $$YearGoalsTableTableFilterComposer,
      $$YearGoalsTableTableOrderingComposer,
      $$YearGoalsTableTableAnnotationComposer,
      $$YearGoalsTableTableCreateCompanionBuilder,
      $$YearGoalsTableTableUpdateCompanionBuilder,
      (YearGoalRow, $$YearGoalsTableTableReferences),
      YearGoalRow,
      PrefetchHooks Function({bool goalCategoryId})
    >;

class $AtelierDatabaseManager {
  final _$AtelierDatabase _db;
  $AtelierDatabaseManager(this._db);
  $$GoalCategoriesTableTableTableManager get goalCategoriesTable =>
      $$GoalCategoriesTableTableTableManager(_db, _db.goalCategoriesTable);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db, _db.goalsTable);
  $$YearGoalsTableTableTableManager get yearGoalsTable =>
      $$YearGoalsTableTableTableManager(_db, _db.yearGoalsTable);
}
