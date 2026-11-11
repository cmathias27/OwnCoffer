/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:owncoffer_client/src/protocol/protocol.dart' as _iylp5nsw;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'category.dart' as _issw2w8j;

/// « Ton année avec Pépite » (decision 0031): what the user did in [year],
/// from their own doings and the accounts they may see. Never compared to
/// anyone; amounts only for the subscriptions they stopped.
abstract class PepiteYear
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PepiteYear._({
    required this.year,
    required this.weeks,
    required this.badges,
    required this.challenges,
    required this.seeds,
    required this.goalMonthsKept,
    required this.goalMonthsTracked,
    this.bestCategory,
    this.bestCategoryMonths,
    required this.subscriptionsStopped,
    required this.subscriptionsMonthlyCents,
  });

  factory PepiteYear({
    required int year,
    required int weeks,
    required List<String> badges,
    required int challenges,
    required int seeds,
    required int goalMonthsKept,
    required int goalMonthsTracked,
    _issw2w8j.Category? bestCategory,
    int? bestCategoryMonths,
    required int subscriptionsStopped,
    required int subscriptionsMonthlyCents,
  }) = _PepiteYearImpl;

  factory PepiteYear.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteYear(
      year: jsonSerialization['year'] as int,
      weeks: jsonSerialization['weeks'] as int,
      badges: _iylp5nsw.Protocol().deserialize<List<String>>(
        jsonSerialization['badges'],
      ),
      challenges: jsonSerialization['challenges'] as int,
      seeds: jsonSerialization['seeds'] as int,
      goalMonthsKept: jsonSerialization['goalMonthsKept'] as int,
      goalMonthsTracked: jsonSerialization['goalMonthsTracked'] as int,
      bestCategory: jsonSerialization['bestCategory'] == null
          ? null
          : _iylp5nsw.Protocol().deserialize<_issw2w8j.Category>(
              jsonSerialization['bestCategory'],
            ),
      bestCategoryMonths: jsonSerialization['bestCategoryMonths'] as int?,
      subscriptionsStopped: jsonSerialization['subscriptionsStopped'] as int,
      subscriptionsMonthlyCents:
          jsonSerialization['subscriptionsMonthlyCents'] as int,
    );
  }

  int year;

  /// Weeks of the ritual counted in the year.
  int weeks;

  /// Badges earned in the year.
  List<String> badges;

  /// Challenges of the month done in the year.
  int challenges;

  /// Seeds earned in the year (weeks, badges, challenges).
  int seeds;

  /// Budget months of the year ended within a goal, over the months that
  /// had one (summed over the goals); 0 of 0 without goals.
  int goalMonthsKept;

  int goalMonthsTracked;

  /// The category whose goal was kept the most months, and how many.
  _issw2w8j.Category? bestCategory;

  int? bestCategoryMonths;

  /// Subscriptions the user stopped (deleted or given an end) in the year,
  /// and what they cost a month together.
  int subscriptionsStopped;

  int subscriptionsMonthlyCents;

  /// Returns a shallow copy of this [PepiteYear]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PepiteYear copyWith({
    int? year,
    int? weeks,
    List<String>? badges,
    int? challenges,
    int? seeds,
    int? goalMonthsKept,
    int? goalMonthsTracked,
    _issw2w8j.Category? bestCategory,
    int? bestCategoryMonths,
    int? subscriptionsStopped,
    int? subscriptionsMonthlyCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteYear',
      'year': year,
      'weeks': weeks,
      'badges': badges.toJson(),
      'challenges': challenges,
      'seeds': seeds,
      'goalMonthsKept': goalMonthsKept,
      'goalMonthsTracked': goalMonthsTracked,
      if (bestCategory != null) 'bestCategory': bestCategory?.toJson(),
      if (bestCategoryMonths != null) 'bestCategoryMonths': bestCategoryMonths,
      'subscriptionsStopped': subscriptionsStopped,
      'subscriptionsMonthlyCents': subscriptionsMonthlyCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PepiteYear',
      'year': year,
      'weeks': weeks,
      'badges': badges.toJson(),
      'challenges': challenges,
      'seeds': seeds,
      'goalMonthsKept': goalMonthsKept,
      'goalMonthsTracked': goalMonthsTracked,
      if (bestCategory != null)
        'bestCategory': bestCategory?.toJsonForProtocol(),
      if (bestCategoryMonths != null) 'bestCategoryMonths': bestCategoryMonths,
      'subscriptionsStopped': subscriptionsStopped,
      'subscriptionsMonthlyCents': subscriptionsMonthlyCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PepiteYearImpl extends PepiteYear {
  _PepiteYearImpl({
    required int year,
    required int weeks,
    required List<String> badges,
    required int challenges,
    required int seeds,
    required int goalMonthsKept,
    required int goalMonthsTracked,
    _issw2w8j.Category? bestCategory,
    int? bestCategoryMonths,
    required int subscriptionsStopped,
    required int subscriptionsMonthlyCents,
  }) : super._(
         year: year,
         weeks: weeks,
         badges: badges,
         challenges: challenges,
         seeds: seeds,
         goalMonthsKept: goalMonthsKept,
         goalMonthsTracked: goalMonthsTracked,
         bestCategory: bestCategory,
         bestCategoryMonths: bestCategoryMonths,
         subscriptionsStopped: subscriptionsStopped,
         subscriptionsMonthlyCents: subscriptionsMonthlyCents,
       );

  /// Returns a shallow copy of this [PepiteYear]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PepiteYear copyWith({
    int? year,
    int? weeks,
    List<String>? badges,
    int? challenges,
    int? seeds,
    int? goalMonthsKept,
    int? goalMonthsTracked,
    Object? bestCategory = _Undefined,
    Object? bestCategoryMonths = _Undefined,
    int? subscriptionsStopped,
    int? subscriptionsMonthlyCents,
  }) {
    return PepiteYear(
      year: year ?? this.year,
      weeks: weeks ?? this.weeks,
      badges: badges ?? this.badges.map((e0) => e0).toList(),
      challenges: challenges ?? this.challenges,
      seeds: seeds ?? this.seeds,
      goalMonthsKept: goalMonthsKept ?? this.goalMonthsKept,
      goalMonthsTracked: goalMonthsTracked ?? this.goalMonthsTracked,
      bestCategory: bestCategory is _issw2w8j.Category?
          ? bestCategory
          : this.bestCategory?.copyWith(),
      bestCategoryMonths: bestCategoryMonths is int?
          ? bestCategoryMonths
          : this.bestCategoryMonths,
      subscriptionsStopped: subscriptionsStopped ?? this.subscriptionsStopped,
      subscriptionsMonthlyCents:
          subscriptionsMonthlyCents ?? this.subscriptionsMonthlyCents,
    );
  }
}
