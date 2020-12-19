//
//  Histogram.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI
import Charts

struct Histogram: View {
    var data: [Float] = []
    var body: some View {
        Chart(data: data)
            .chartStyle(
                LineChartStyle(.line, lineColor: .blue, lineWidth: 1)
            )
    }
}

struct Histogram_Previews: PreviewProvider {
    static var previews: some View {
        Histogram()
    }
}
