//
//  4DigitPickerView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 11/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI

struct FourDigitPickerView: View {
  @Binding var digit1: Float
  @Binding var digit2: Float
  @Binding var digit3: Float
  @Binding var digit4: Float

  @State private var focusedDigit: String = "1"

  var body: some View {
    HStack {
      DigitPicker(tag: "1", digit: $digit1, focusedDigit: $focusedDigit)
      DigitPicker(tag: "2", digit: $digit2, focusedDigit: $focusedDigit)
      DigitPicker(tag: "3", digit: $digit3, focusedDigit: $focusedDigit)
      DigitPicker(tag: "4", digit: $digit4, focusedDigit: $focusedDigit)
    }
  }
}

struct DigitPicker: View {
  var tag: String
  @Binding var digit: Float
  @Binding var focusedDigit: String

  @State private var isFocused = false

  var body: some View {
    Text("\(Int(digit))")
      .font(Font.system(size: 40, design: .rounded))
      .frame(width: 40, height: 40)
      .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)) : Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)), lineWidth: 2)
      )
      .padding(.vertical, 4)
      .focusable() {
        isFocused = $0
        print("\(tag): isFocused: \($0)")
      }
      .digitalCrownRotation(self.$digit,
                            from: 0,
                            through: 10,
                            by: 1,
                            sensitivity: .medium,
                            isContinuous: true,
                            isHapticFeedbackEnabled: false)
  }
}

struct _DigitPickerView_Previews: PreviewProvider {

  static var previews: some View {
    FourDigitPickerView(digit1: .constant(1), digit2: .constant(2), digit3: .constant(3), digit4: .constant(4))
  }
}
