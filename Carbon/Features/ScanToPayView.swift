//
//  ScanToPayView.swift
//  Carbon
//
//  Created by Harsh on 16/03/24.
//

import SwiftUI
import CodeScanner

struct ScanToPayView: View {
    var body: some View {
        CodeScannerView(codeTypes: [.qr], simulatedData: TransactionCategory.travel(.domesticFlight).activity_id) { response in
            switch response {
            case .success(let result):
                print("Found code: \(result.string)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ScanToPayView()
}
