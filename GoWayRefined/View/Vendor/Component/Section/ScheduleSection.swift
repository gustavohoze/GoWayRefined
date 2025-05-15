//
//  ScheduleSection.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//

import SwiftUI

struct ScheduleSection: View {
    let scheduleList: [Schedule]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Schedule:")
                .font(.title2)
                .padding(.top)
                .frame(maxWidth: .infinity)
            
            ForEach(scheduleList, id: \.dayName) { schedule in
                Text("\(schedule.dayName): \(schedule.hour)")
                    .padding(.vertical, 5)
            }
        }
    }
}
