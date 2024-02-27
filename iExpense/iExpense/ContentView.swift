//
//  ContentView.swift
//  iExpense
//
//  Created by Denis Postolov on 16/02/24.
//

import SwiftUI
import Observation

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            // encoding and storing into UserDefaults
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: ("Items")) {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Personal Expenses").padding(.top)){
                    ForEach(expenses.items) { item in
                        if item.type == "Personal" {
                            HStack {
                                VStack(alignment: .leading){
                                    Text(item.name)
                                        .font(.headline)
                                        
                                    Text(item.type)
                                }
                                
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(item.amount < 10 ? .title3 : item.amount < 100 ? .title2: .title)
                                    .foregroundStyle(
                                        item.amount < 10 ?
                                        LinearGradient(colors: [.teal, .green], startPoint: .top, endPoint: .bottom) : item.amount < 100 ? LinearGradient(colors: [.secondary, .orange], startPoint: .top, endPoint: .bottom) : LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
                                    )
                            }
                        }
                    }
                    .onDelete(perform: removeExpenceItems)
                }
                Section(header: Text("Business Expenses").padding(.top)){
                    ForEach(expenses.items) { item in
                        if item.type == "Business" {
                            HStack {
                                VStack(alignment: .leading){
                                    Text(item.name)
                                        .font(.headline)
                                        
                                    Text(item.type)
                                }
                                
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(item.amount < 10 ? .title3 : item.amount < 100 ? .title2: .title)
                                    .foregroundStyle(
                                        item.amount < 10 ?
                                        LinearGradient(colors: [.teal, .green], startPoint: .top, endPoint: .bottom) : item.amount < 100 ? LinearGradient(colors: [.secondary, .orange], startPoint: .top, endPoint: .bottom) : LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
                                    )
                            }
                        }
                    }
                    .onDelete(perform: removeExpenceItems)
                }
            }
            .toolbar {
                Button("Add Expense", systemImage: "plus"){
                    showingAddExpense = true
                }
            }
            .navigationTitle("iExpense")
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
    }
    
    func removeExpenceItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
}


#Preview {
    ContentView()
}
