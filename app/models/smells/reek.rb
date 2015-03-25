module Smells
  class Reek < Smell
    # see https://github.com/troessner/reek/wiki/Code-Smells
    # and https://github.com/troessner/reek/tree/master/lib/reek/smells
    RATING = {
      'Attribute' => 1,
      'ClassVariable' => 5,
      'IrresponsibleModule' => 1,
      'BooleanParameter' => 3,
      'ControlParameter' => 3,
      'DataClump' => 2,
      'DuplicateMethodCall' => 2,
      'FeatureEnvy' => 2,
      'LongParameterList' => 4,
      'LongYieldList' => 4,
      'ModuleInitialize' => 5,
      'NestedIterators' => 2,
      'PrimaDonnaMethod' => 4,
      'RepeatedConditional' => 3,
      'TooManyInstanceVariables' => 2,
      'TooManyMethods' => 3,
      'TooManyStatements' => 3,
      'UncommunicativeMethodName' => 3,
      'UncommunicativeModuleName' => 3,
      'UncommunicativeParameterName' => 2,
      'UncommunicativeVariableName' => 2,
      'UnusedParameters' => 3,
      'UtilityFunction' => 2,
      'NilCheck' => 2
    }.freeze

    validates :trait, inclusion: {in: RATING.keys}

    def rating
      RATING[trait]
    end
  end
end
