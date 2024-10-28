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
            VStack(spacing: 10) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .padding()
                            .foregroundColor(Color(hex: "#A499FF"))
                    }
                    .padding(.trailing, 240)

                    Button(action: {
                        saveJournal()
                    }) {
                        Text("Save")
                            .padding()
                            .foregroundColor(Color(hex: "#A499FF"))
                    }
                }

                TextField("Title", text: $journalTitle)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 10)

                Text("\(currentDate)")
                    .foregroundColor(Color(hex: "#A39A9A"))
                    .font(.headline)
                    .padding(.trailing, 280)

                TextEditor(text: $journalContent)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(10)
                    .scrollContentBackground(.hidden)
                    .background(Color(hex: "#1A1A1C"))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                            }
            .padding(.top, 20)
        }
    }

    private func saveJournal() {
        guard !journalTitle.isEmpty || !journalContent.isEmpty else { return }
        let newEntry = JournalEntry(title: journalTitle, content: journalContent, date: Date())
        journalEntries.append(newEntry)
        dismiss()
    }
}

#Preview {
    NewJournal(journalEntries: .constant([]))
}
