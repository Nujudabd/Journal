

import SwiftUI

struct NewJournal: View {
    @Environment(\.dismiss) var dismiss
    @Binding var journalEntries: [JournalEntry]
    @State private var journalTitle: String = ""
    @State private var journalContent: String = ""

    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: Date())
    }

    var body: some View {
        ZStack {
            Color(hex: "#1A1A1C").ignoresSafeArea()

            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .padding()
                            .foregroundColor(Color(hex: "#A499FF"))
                    }
                    .padding(.trailing, 220)

                    Button(action: {
                        saveJournal()
                    }) {
                        Text("Save")
                            .padding()
                            .foregroundColor(Color(hex: "#A499FF"))
                    }
                    .padding(.trailing)
                }

                TextField("Title", text: $journalTitle, axis: .vertical)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(height: 50)
                    .padding(.leading, 10)

                Text("\(currentDate)")
                    .foregroundColor(Color(hex: "#A39A9A"))
                    .font(.headline)
                    .padding(.trailing, 290)
                    .padding(.bottom, 5)

                TextField("Type your Journal...", text: $journalContent, axis: .vertical)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .frame(width: 380, height: 450, alignment: .top)
                    .padding(.leading, 10)
                    .padding(.bottom, 160)
            }
        }
    }

    private func saveJournal() {
        let newEntry = JournalEntry(title: journalTitle, content: journalContent, date: Date())
        journalEntries.append(newEntry)
        dismiss()
    }
}

#Preview {
    NewJournal(journalEntries: .constant([]))
}
