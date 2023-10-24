//
//  ContentView.swift
//  BetterRest
//
//  Created by Denis Postolov on 20/09/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    @State private var bedtimeError = false
    @State private var bedtimeMessage = ""
    
    
    var body: some View {
        NavigationView{
                Form {
                    Section("When do you want to get up?"){
                        HStack(spacing: 110){
                            Text("Wake up time")
                                .font(.headline)
                            DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .onChange(of: wakeUp){ newValue in
                                    calculateBedTime()
                                }
                        }
                    }
                    
                    Section("Desired amount of sleep"){
                        Stepper("\(sleepAmount.formatted()) hours",value: $sleepAmount, in: 4...12, step: 0.25)
                            .onChange(of: sleepAmount){ newValue in
                                calculateBedTime()
                            }
                    }
                    
                    Section("How much coffee did you drink today?"){
                        Picker("Daily Coffee Intake", selection: $coffeeAmount){
                            ForEach(1...20, id:\.self){ value in
                                value == 1 ? Text("1 cup"): Text("\(value) cups")
                            }
                        }
                        .onChange(of: coffeeAmount){ newValue in
                            calculateBedTime()
                        }
                        
                    }
                    Section("Your ideal bedtime is"){
                        VStack {
                            Spacer()
                                HStack {
                                    Spacer()
                                    if !bedtimeError {
                                        VStack {
                                            Text("🛏️")
                                                .font(.system(size: 100))
                                            Spacer()
                                            Text(bedtimeMessage)
                                                .font(.system(size: 30, weight: .heavy))
                                        }
                                    } else {
                                        VStack {
                                            Text("🤔")
                                                .font(.system(size: 100))
                                            Spacer()
                                            Text(bedtimeMessage)
                                                .font(.system(size: 15, weight: .heavy))
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                
                                
                            }
                        }
                }
            .onAppear {
                calculateBedTime()
            }
            .navigationTitle("BetterRest")

        }
    }
    
    // Component for creating a date refered to 7 am of the current day
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    func calculateBedTime(){
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0)*60*60
            let minute = (components.minute ?? 0)*60
            
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            bedtimeMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
            bedtimeError = false
            
        } catch{
            
            bedtimeError = true
            bedtimeMessage = "Sorry... there was a problem calculating your bedtime."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


