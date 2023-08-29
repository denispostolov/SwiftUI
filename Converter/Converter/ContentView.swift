//
//  ContentView.swift
//  Converter
//
//  Created by Denis Postolov on 11/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var unitType = "Length"
    @State private var inputType = ""
    @State private var outputType = ""
    @State private var inputValue = 0.0
    @FocusState private var inputIsFocused: Bool
    
    let unitTypes = ["Temperature", "Length", "Time", "Volume"]
    let temperatureUnits = ["Celsius", "Fahrenheit", "Kelvin"]
    let lengthUnits = ["Meters", "Km", "Feet", "Yards", "Miles"]
    let timeUnits = ["Seconds", "Minutes", "Hours", "Days"]
    let volumeUnits = ["ml", "Liters", "Cups", "Pints", "Gallons"]
    
    var outputValue : Double {
        var result = 0.0
        if inputType == outputType {
            result = inputValue
        }
        else {
            result = applyConversion()
        }
        
        return result
    }
    
    // Function to handle the conversion
    // Not best solution
    func applyConversion() -> Double {
        
        var result = 0.0
        
        // Temperature conversion
        if inputType == "Celsius" {
            if outputType == "Fahrenheit" {
                result = (inputValue * 9/5) + 32
            } else if outputType == "Kelvin" {
                result = inputValue + 273.15
            }
        }
        
        if inputType == "Fahrenheit" {
            if outputType == "Celsius" {
                result = (inputValue - 32) * 5/9
            } else if outputType == "Kelvin" {
                result = (inputValue - 32) * 5/9 + 273.15
            }
        }
        
        if inputType == "Kelvin" {
            if outputType == "Celsius" {
                result = inputValue - 273.15
            } else if outputType == "Fahrenheit" {
                result = (inputValue - 273.15) * 9/5 + 32
            }
        }
        
        // Length conversion
        if inputType == "Meters" {
            if outputType == "Km" {
                result = inputValue/1000
            } else if outputType == "Feet" {
                result = inputValue * 3.281
            } else if outputType == "Yards" {
                result = inputValue * 1.094
            } else if outputType == "Miles" {
                result = inputValue / 1609
            }
        }
        
        if inputType == "Km" {
            if outputType == "Meters" {
                result = inputValue * 1000
            } else if outputType == "Feet" {
                result = inputValue * 3281
            } else if outputType == "Yards" {
                result = inputValue * 1094
            } else if outputType == "Miles" {
                result = inputValue / 1.609
            }
        }
        
        if inputType == "Feet" {
            if outputType == "Meters" {
                result = inputValue / 3.281
            } else if outputType == "Km" {
                result = inputValue / 3281
            } else if outputType == "Yards" {
                result = inputValue / 3
            } else if outputType == "Miles" {
                result = inputValue / 5280
            }
        }
        
        if inputType == "Yards" {
            if outputType == "Meters" {
                result = inputValue / 1.094
            } else if outputType == "Km" {
                result = inputValue / 1094
            } else if outputType == "Feet" {
                result = inputValue * 3
            } else if outputType == "Miles" {
                result = inputValue / 1760
            }
        }
        
        if inputType == "Miles" {
            if outputType == "Meters" {
                result = inputValue * 1609
            } else if outputType == "Km" {
                result = inputValue * 1.609
            } else if outputType == "Feet" {
                result = inputValue * 5280
            } else if outputType == "Yards" {
                result = inputValue * 1760
            }
        }
        
        // Time conversion
        if inputType == "Seconds" {
            if outputType == "Minutes" {
                result = inputValue / 60
            } else if outputType == "Hours" {
                result = inputValue / 3600
            } else if outputType == "Days" {
                result = inputValue / 86400
            }
        }
        
        if inputType == "Minutes" {
            if outputType == "Seconds" {
                result = inputValue * 60
            } else if outputType == "Hours" {
                result = inputValue / 60
            } else if outputType == "Days" {
                result = inputValue / 1440
            }
        }
        
        if inputType == "Hours" {
            if outputType == "Seconds" {
                result = inputValue * 3600
            } else if outputType == "Minutes" {
                result = inputValue * 60
            } else if outputType == "Days" {
                result = inputValue / 24
            }
        }
        
        if inputType == "Days" {
            if outputType == "Seconds" {
                result = inputValue * 86400
            } else if outputType == "Minutes" {
                result = inputValue * 1440
            } else if outputType == "Hours" {
                result = inputValue * 24
            }
        }
        
        // Volume conversion
        if inputType == "ml" {
            if outputType == "Liters" {
                result = inputValue/1000
            } else if outputType == "Cups" {
                result = inputValue / 236.6
            } else if outputType == "Pints" {
                result = inputValue / 473.2
            } else if outputType == "Gallons" {
                result = inputValue /  3785
            }
        }
        
        if inputType == "Liters" {
            if outputType == "ml" {
                result = inputValue * 1000
            } else if outputType == "Cups" {
                result = inputValue * 4.227
            } else if outputType == "Pints" {
                result = inputValue * 2.113
            } else if outputType == "Gallons" {
                result = inputValue / 3.785
            }
        }
        
        if inputType == "Cups" {
            if outputType == "ml" {
                result = inputValue * 236.6
            } else if outputType == "Liters" {
                result = inputValue / 4.227
            } else if outputType == "Pints" {
                result = inputValue / 2
            } else if outputType == "Gallons" {
                result = inputValue / 16
            }
        }
        
        if inputType == "Pints" {
            if outputType == "ml" {
                result = inputValue * 473.2
            } else if outputType == "Liters" {
                result = inputValue / 2.113
            } else if outputType == "Cups" {
                result = inputValue * 2
            } else if outputType == "Gallons" {
                result = inputValue / 8
            }
        }
        
        if inputType == "Gallons" {
            if outputType == "ml" {
                result = inputValue * 3785
            } else if outputType == "Liters" {
                result = inputValue * 3.785
            } else if outputType == "Cups" {
                result = inputValue * 16
            } else if outputType == "Pints" {
                result = inputValue * 8
            }
        }
        
        
        return result
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Unit Type", selection: $unitType) {
                        ForEach(unitTypes, id: \.self){
                            Text($0)
                        }
                    }
                } header: {
                    Text("Specify the type of the conversion")
                }
                
                Section {
                    Picker("Input Type", selection: $inputType){
                        switch unitType {
                            case "Temperature":
                                ForEach(temperatureUnits, id: \.self){
                                    Text($0)
                                }
                            case "Length":
                                ForEach(lengthUnits, id: \.self){
                                    Text($0)
                                }
                            case "Time":
                                ForEach(timeUnits, id: \.self){
                                    Text($0)
                                }
                            case "Volume":
                                ForEach(volumeUnits, id: \.self){
                                    Text($0)
                                }
                            default:
                                let _ = print("Error")
                                
                        }
                        
                    }
                    .pickerStyle(.segmented)
                    
                } header: {
                    Text("Specify the input unit")
                }
                
                Section {
                    Picker("Output Type", selection: $outputType){
                        switch unitType {
                            case "Temperature":
                                ForEach(temperatureUnits, id: \.self){
                                    Text($0)
                                }
                            case "Length":
                                ForEach(lengthUnits, id: \.self){
                                    Text($0)
                                }
                            case "Time":
                                ForEach(timeUnits, id: \.self){
                                    Text($0)
                                }
                            case "Volume":
                                ForEach(volumeUnits, id: \.self){
                                    Text($0)
                                }
                            default:
                                let _ = print("Error")
                                
                        }
                        
                    }
                    .pickerStyle(.segmented)
                    
                } header: {
                    Text("Specify the output unit")
                }
                
                Section {
                    // HStack let us have a label next to the TextField
                    HStack {
                        Text("Value to convert: ")
                        Spacer()
                        TextField("", value: $inputValue, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($inputIsFocused)
                    }
                    
                } header: {
                    Text("Specify the value to be converted")
                }
                
                Section {
                    Text("Result: \(outputValue, specifier: "%.4f")")
                        .font(
                            .largeTitle
                            .weight(.bold)
                        )
                }
                
                }
            
            .navigationTitle("Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done") {
                        inputIsFocused = false
                        
                    }
                    
                }
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
