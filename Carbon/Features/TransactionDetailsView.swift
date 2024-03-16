//
//  TransactionDetailsView.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TransactionDetail {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: ObjectIdentifier {
            transaction.id
        }
        var transaction: Transaction
    }
}

struct TransactionDetailsView: View {
    let store: StoreOf<TransactionDetail>
    
    var body: some View {
        Form {
            Section {
                LabeledContent("Amount", value: "\(store.transaction.amount.formatted(.currency(code: "INR")))")
                LabeledContent("Description", value: store.transaction._description)
                LabeledContent("Category", value: store.transaction.category.name)
                LabeledContent("Date", value: store.transaction.date.formatted())
            }
            
            Section("Emissions") {
                Button(action: {}, label: {
                    Text("Emissions")
                })
                
                // TODO: More
                Text("Know your CO2 emissions")
            }
        }
        .navigationTitle(Text("Transaction Details"))
        /*
        Form {
            
            Section("CO2") {
                if let co2E = store.emissions.co2E, let unit =  store.emissions.co2EUnit {
                    LabeledContent("co2e") {
                        Text(co2E, format: .number.precision(.fractionLength(2)))
                        + Text(unit)
                    }
                }
                
                if let co2ECalculationMethod = store.emissions.co2ECalculationMethod {
                    LabeledContent("Calculation Method") {
                        Text(co2ECalculationMethod)
                    }
                }
            }
            if let emissionFactor = store.emissions.emissionFactor {
                Section("Emission Factors") {
                    if let name = emissionFactor.name {
                        LabeledContent("Name") {
                            Text(name)
                        }
                    }
                    
                    if let accessType = emissionFactor.accessType {
                        LabeledContent("Access Type") {
                            Text(accessType)
                        }
                    }
                    
                    if let sourceDataset = emissionFactor.sourceDataset {
                        LabeledContent("Source") {
                            Text(sourceDataset)
                                .lineLimit(1)
                        }
                    }
                    
                    if let region = emissionFactor.region {
                        LabeledContent("Region") {
                            Text(region)
                        }
                    }
                    
                    if let category = emissionFactor.category {
                        LabeledContent("Category") {
                            Text(category)
                        }
                    }
                }
            }
            
//            if let activity_data = store.emissions.activityData {
//                Section("Activity") {
//                    LabeledContent("Value") {
//                        Text(activity_data.activityUnit)
//                    }
//                }
//            }
        }
        .navigationTitle(Text("Emissions"))
         */
    }
}

//#Preview {
//    TransactionDetailsView()
//}
