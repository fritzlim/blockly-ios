/*
 * Copyright 2016 Google Inc. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

/**
 Class for a `FieldAngle`-based `Layout`.
 */
@objc(BKYFieldAngleLayout)
open class FieldAngleLayout: FieldLayout {

  // MARK: - Properties

  /// The `FieldAngle` that backs this layout
  private let fieldAngle: FieldAngle

  /// The text value that should be used when rendering this layout
  open var textValue: String {
    return (_localizedNumberFormatter.string(for: fieldAngle.angle) ?? "") + "°"
  }

  /// The angle value.
  public var angle: Double {
    return fieldAngle.angle
  }

  /// Number formatter used for outputting the value as localized text
  fileprivate let _localizedNumberFormatter: NumberFormatter = {
    // Note: `self._localizedNumberFormatter` is already set to the default locale.
    let numberFormatter = NumberFormatter()
    numberFormatter.minimumIntegerDigits = 1
    return numberFormatter
  }()

  // MARK: - Initializers

  /**
   Initializes the angle field layout.

   - parameter fieldAngle: The `FieldAngle` model for this layout.
   - parameter engine: The `LayoutEngine` to associate with the new layout.
   - parameter measurer: The `FieldLayoutMeasurer.Type` to measure this layout.
   */
  public init(fieldAngle: FieldAngle, engine: LayoutEngine, measurer: FieldLayoutMeasurer.Type) {
    self.fieldAngle = fieldAngle
    super.init(field: fieldAngle, engine: engine, measurer: measurer)
  }

  // MARK: - Public

  /**
   Updates `self.fieldAngle` from the given text value. If the value was changed, the layout tree
   is updated to reflect the change.

   - parameter text: A valid integer that will be used to update `self.fieldAngle`. If this value
   is not a valid integer, `self.fieldAngle` is not updated.
   */
  open func updateAngle(_ angle: Double) {
    guard fieldAngle.angle != angle else { return }

    captureChangeEvent {
      fieldAngle.angle = angle
    }

    // Perform a layout up the tree
    updateLayoutUpTree()
  }
}
