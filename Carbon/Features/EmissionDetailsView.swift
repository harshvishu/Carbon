//
//  EmissionDetailsView.swift
//  Carbon
//
//  Created by Harsh on 16/03/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct EmissionDetails {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id = UUID()
        var emissions: Emissions
    }
}

struct EmissionDetailsView: View {
    let store: StoreOf<EmissionDetails>
    
    var body: some View {
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
    }
}

#Preview {
    EmissionDetailsView(store: StoreOf<EmissionDetails>(initialState: EmissionDetails.State(emissions: .mock), reducer: {
        EmissionDetails()
    }))
}
