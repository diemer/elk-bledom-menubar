//
//  ContentView.swift
//  MenuLight
//
//  Created by Dan Diemer on 7/30/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bleManager = BLEManager()
    @State private var isOn = UserDefaults.standard.bool(forKey: "isOn")
    @State private var selectedColor: Color = Color(hex: UserDefaults.standard.string(forKey: "selectedColor") ?? "FFFFFF")

    var body: some View {
        VStack {
          Toggle("LED Power", isOn: $isOn)
            .toggleStyle(.switch)
            .onChange(of: isOn) { value in
                UserDefaults.standard.setValue(value, forKey: "isOn")
                if value {
                    bleManager.turnOn()
                } else {
                    bleManager.turnOff()
                }
            }
          
          

            ColorPicker("Select Color", selection: $selectedColor)
                .onChange(of: selectedColor) { newColor in
                    UserDefaults.standard.setValue(newColor.toHex(), forKey: "selectedColor")
                    if isOn {
                        bleManager.setColor(colorToHex(color: newColor))
                    }
                }
          
          Button("Quit") {
            NSApplication.shared.terminate(self)
          }
        }
        .padding()
        .frame(width: 200)
    }

    func colorToHex(color: Color) -> String {
        let components = color.cgColor?.components ?? [0, 0, 0]
        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        return String(format: "7E000503%02X%02X%02X00EF", red, green, blue)
    }
}

#Preview {
    ContentView()
}
