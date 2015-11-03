//
//  ErrorAnswer.swift
//  WordScramble
//
//  Created by Kenneth Wilcox on 11/2/15.
//  Copyright © 2015 Kenneth Wilcox. All rights reserved.
//

import Foundation

struct ErrorAnswer: OptionSetType {
  let rawValue: Int
  static let None = ErrorAnswer(rawValue: 0)
  static let WordIsAnswer = ErrorAnswer(rawValue: 1 << 0)
  static let WordIsPossible = ErrorAnswer(rawValue: 1 << 1)
  static let WordIsOriginal = ErrorAnswer(rawValue: 1 << 2)
  static let WordIsReal = ErrorAnswer(rawValue: 1 << 3)
}
