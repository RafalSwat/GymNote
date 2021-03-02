//
//  CalendarView.swift
//  GymNote
//
//  Created by Rafał Swat on 02/03/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    @State var dateToScrollTo: Date = Date()

    let interval: DateInterval
    let showHeaders: Bool
    let content: (Date) -> DateView

    init(
        interval: DateInterval,
        showHeaders: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.interval = interval
        self.showHeaders = showHeaders
        self.content = content
    }

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                    ForEach(months, id: \.self) { month in
                        Section(header: header(for: month)) {
                            ForEach(days(for: month), id: \.self) { date in
                                if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                                    content(date).id(date)
                                } else {
                                    content(date).hidden()
                                }
                            }
                        }
                    }
                }
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.dateToScrollTo = Date()
                }
            }
            .onChange(of: self.dateToScrollTo, perform: { value in
                withAnimation {
                    var components = Calendar.current.dateComponents([.day, .month, .year], from: value)
                    components.hour = 0
                    components.minute = 0
                    let date = Calendar.current.date(from: components)
                    scrollProxy.scrollTo(date, anchor: .center)
                }
            })
        }
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    private func header(for month: Date) -> some View {
        //let component = calendar.component(.month, from: month)
        //let formatter = component == 1 ? DateConverter.monthAndYearFormat : DateConverter.monthFormat
        let formatter = DateConverter.monthAndYearFormat

        return Group {
            if showHeaders {
                Text(formatter.string(from: month))
                    .font(.title)
                    .padding()
            }
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(getWeekDaysSorted(), id: \.self) { day in
                            Text(day)
                                .bold()
                        }
                    }
                    Divider()
        }
    }

    private func days(for month: Date) -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(
            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    private func getWeekDaysSorted() -> [String]{
            let weekDays = Calendar.current.shortWeekdaySymbols
            let sortedWeekDays = Array(weekDays[Calendar.current.firstWeekday - 1 ..< Calendar.current.shortWeekdaySymbols.count] + weekDays[0 ..< Calendar.current.firstWeekday - 1])
            return sortedWeekDays
        }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}
