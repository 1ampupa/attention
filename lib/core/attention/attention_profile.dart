import 'package:attention/core/attention/dimension_score.dart';

class AttentionProfile {

  final DimensionScore focused;
  final DimensionScore sustained;
  final DimensionScore selective;
  final DimensionScore alternating;
  final DimensionScore divided;

  AttentionProfile({
    DimensionScore? focused,
    DimensionScore? sustained,
    DimensionScore? selective,  
    DimensionScore? alternating,
    DimensionScore? divided,
  }) :
    focused = focused ?? DimensionScore(score: 0),
    sustained = sustained ?? DimensionScore(score: 0),
    selective = selective ?? DimensionScore(score: 0),
    alternating = alternating ?? DimensionScore(score: 0),
    divided = divided ?? DimensionScore(score: 0);
    
} 