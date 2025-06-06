//
//  PastHeights.swift
//  test
//
//  Created by Alessandro Rippa on 06/06/25.
//

import SwiftUI

struct PastProjectionView: View {
    
    var tree: Tree
    
    let barWidth: CGFloat = 40
    let chartHeight: CGFloat = 200
    
    //var heights : [Double] = [1.03, 1.04, 1.05]
    //var dates: [Date] = [Date(timeIntervalSinceNow: 10000), Date(timeIntervalSinceNow: 20000), Date(timeIntervalSinceNow: 30000)]
    
    
    
    var body: some View {
        
        List(Array(zip(tree.pastDiameters.reversed(), tree.pastDiametersDate.reversed())), id: \.1){ height, date in
            HStack{
                Text(String(format: "%.2f", height)+"m")
                Spacer()
                Text(Date.FormatStyle().format(date))
            }
            
        }
        .listStyle(.inset)
        .padding(.vertical)
        
        Divider()
        
        VStack{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 16) {
                    ForEach(Array(tree.pastDiameters.enumerated()), id: \.offset) { index, value in
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.accent)
                                .frame(
                                    width: barWidth,
                                    height: CGFloat(value / (tree.pastDiameters.max() ?? 1)) * (chartHeight - 50)
                                )
                            
                            Text(String(format: "%.1f", value) + "m")
                                .font(.caption)
                                .rotationEffect(.degrees(-45))
                                .frame(width: barWidth, height: 30)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Past measurements")
            .frame(height: chartHeight)
        }
        .padding(.vertical, 40)
        
    }
    
}

/*
#Preview {
    PastHeightsView()
}
*/
