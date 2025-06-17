//
//  OTPTextBox.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 11/4/25.
//
import SwiftUI
struct OTPTextBox: View {
    let index: Int
    @Binding var otpValues: [String]
    @FocusState var focusedField: Int?

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.secondarySystemBackground))
                .frame(width: 50, height: 50)
                .cornerRadius(10)

            TextField("", text: $otpValues[index])
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.title2)
                .focused($focusedField, equals: index)
                .onChange(of: otpValues[index]) { newValue in
                    if newValue.count > 1 {
                        otpValues[index] = String(newValue.prefix(1))
                    }

                    if !newValue.isEmpty {
                        // Move to next field if available
                        if index < otpValues.count - 1 {
                            focusedField = index + 1
                        }
                    } else {
                        // Move to previous if deleting
                        if index > 0 {
                            focusedField = index - 1
                        }
                    }
                }
        }
    }
}
