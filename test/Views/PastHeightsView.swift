//
//  PastHeights.swift
//  test
//
//  Created by Alessandro Rippa on 06/06/25.
//

import SwiftUI

struct PastHeightsView: View {
    
    var tree: Tree
    
    //var heights : [Double] = [1.03, 1.04, 1.05]
    //var dates: [Date] = [Date(timeIntervalSinceNow: 10000), Date(timeIntervalSinceNow: 20000), Date(timeIntervalSinceNow: 30000)]
    
    var body: some View {
        
        List(Array(zip(tree.pastHeights.reversed(), tree.pastHeightsDate.reversed())), id: \.1){ height, date in
            HStack{
                Text(String(format: "%.2f", height)+"m")
                Spacer()
                Text(Date.FormatStyle().format(date))
            }
            
        }
        
    }
    
}

/*
#Preview {
    PastHeightsView()
}
*/
