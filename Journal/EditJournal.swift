import SwiftUI

struct EditJournal: View {
    @Binding var journalEntry: JournalEntry
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            TextField("Title", text: $journalEntry.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $journalEntry.content)
                .border(Color.gray)
                .padding()

            Button("Save") {
                dismiss()
            }
            .padding()
        }
        .navigationTitle("Edit Journal Entry")
        .padding()
    }
}

struct EditJournal_Previews: PreviewProvider {
    @State static var sampleEntry = JournalEntry(title: "Sample Title", content: "Sample content.", date: Date())

    static var previews: some View {
        NavigationView {
            EditJournal(journalEntry: $sampleEntry)
        }
    }
}
