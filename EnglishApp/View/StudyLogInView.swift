import SwiftUI

struct StudyLogInView: View {
    @State private var studyRecords: Set<Date> = [] // 学習済み日
    @State private var currentMonth: Date = Date()  // 表示中の月
    @State private var showMonthPicker: Bool = false // 月選択表示
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["日", "月", "火", "水", "木", "金", "土"]
    
    private var monthDates: [Date] {
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    var body: some View {
        VStack(spacing: 25){
       
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(currentMonth, format: .dateTime.year().month(.wide))
                    .font(.title2).bold()
                    .onTapGesture {
                        showMonthPicker = true
                    }
                Spacer()
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
      
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 10) {
                let firstWeekday = calendar.component(.weekday, from: monthDates.first!) - 1
                ForEach(0..<firstWeekday, id: \.self) { _ in
                    Text("").frame(height: 40)
                }
                
                ForEach(monthDates, id: \.self) { date in
                    let didStudy = studyRecords.contains(date)
                    
                    Text("\(calendar.component(.day, from: date))")
                        .frame(width: 35, height: 35)
                        .background(didStudy ? Color.green.opacity(0.7) : Color.clear)
                        .foregroundColor(didStudy ? .white : .primary)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            Spacer()
        }
        .sheet(isPresented: $showMonthPicker) {
            MonthPickerView(selectedMonth: $currentMonth)
        }
        .onAppear {
            
            studyRecords.insert(Date())
        }
    }
    
    private func changeMonth(by offset: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: offset, to: currentMonth) {
            currentMonth = newMonth
        }
    }
}

// 🔹 月選択専用ビュー
struct MonthPickerView: View {
    @Binding var selectedMonth: Date
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            DatePicker("月を選択", selection: $selectedMonth, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .labelsHidden()
            Button("閉じる") {
                dismiss()
            }
            .padding()
        }
    }
}

#Preview {
    StudyLogInView()
}

