import SwiftUI

struct JournalEntry: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var isBookmarked: Bool = false
}

struct ContentView: View {
    @State private var selectedFilter: String = "All"
    @State private var showSplash = true
    @State private var isShowingNewJournal = false
    @State private var journalEntries: [JournalEntry] = []
    @State private var searchText: String = ""

    var body: some View {
        ZStack {
            if showSplash {
                Splash()
                    .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { showSplash = false } }
            } else {
                mainContentView
                    .onAppear {
                        loadJournalEntries()
                    }
            }
        }
    }

    private var mainContentView: some View {
        NavigationView {
            ZStack {
                Color(hex: "000000")
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        Menu {
                            Button(action: {
                                selectedFilter = "Bookmark"
                            }) {
                                Text("Bookmark")
                            }
                            Button(action: {
                                selectedFilter = "Journal Date"
                            }) {
                                Text("Journal Date")
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#1F1F22"))
                                    .frame(width: 35, height: 35)
                                Image(systemName: "line.3.horizontal.decrease")
                                    .resizable()
                                    .foregroundColor(Color(hex: "#D4C8FF"))
                                    .frame(width: 18, height: 15)
                            }
                        }
                        Button(action: {
                            isShowingNewJournal = true
                        }){
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#1F1F22"))
                                    .frame(width: 35, height: 35)
                                Image(systemName: "plus")
                                    .resizable()
                                    .foregroundColor(Color(hex: "#D4C8FF"))
                                    .frame(width: 18, height: 18)
                            }
                        }
                        .sheet(isPresented: $isShowingNewJournal) {
                            NewJournal(journalEntries: $journalEntries)
                                .onDisappear {
                                    saveJournalEntries()
                                }
                        }
                    }
                    .padding()
                    
                    Text("Journal")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 116, height: 40)
                        .foregroundColor(Color(hex: "FFFFFF"))
                        .padding(.top, 20)
                        .padding(.trailing, 270)

                    if !journalEntries.isEmpty {
                        ZStack {
                            TextField("Search...", text: $searchText)
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundColor(Color.white)
                            
                            Image(systemName: "microphone.fill")
                                .resizable()
                                .frame(width: 17, height: 20)
                                .foregroundColor(Color(hex: "8E8E93"))
                                .padding(.leading, 300)
                        }
                        .padding(.bottom, 50)
                    }

                    if journalEntries.isEmpty {
                        introductoryContent
                    } else {
                        journalList
                            .cornerRadius(14)
                    }
                }
            }
        }
    }

    private var introductoryContent: some View {
        VStack {
            Spacer()
            Image("Journal")
                .resizable()
                .frame(width: 77.7, height: 101)
                .padding(.bottom, 10)

            Text("Begin Your Journal")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "D4C8FF"))
                .padding(.bottom, 8)

            Text("Craft your personal diary, tap the plus icon to begin")
                .lineLimit(nil)
                .frame(width: 282, height: 53)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "FFFFFF"))
        }
        .padding(.bottom, 280)
    }

    private var journalList: some View {
        List {
            ForEach(filteredJournalEntries()) { entry in
                HStack {
                    VStack(alignment: .leading) {
                        Text(entry.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(Color(hex: "D4C8FF"))

                        Text("\(entry.date, formatter: DateFormatter.shortDate)")
                            .font(.footnote)
                            .foregroundColor(Color(hex: "9F9F9F"))

                        Text(entry.content)
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "FFFFFF"))
                    }
                    
                    Spacer()
                    Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(Color(hex: "#D4C8FF"))
                        .frame(width: 25, height: 29)
                        .onTapGesture {
                            if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
                                journalEntries[index].isBookmarked.toggle()
                                saveJournalEntries()
                            }
                        }
                }
                .padding()
                .background(Color(hex: "171719"))
                .cornerRadius(14)
                .padding(.vertical, 5)
                .listRowBackground(Color.clear)
                .swipeActions(edge: .leading) {
                    Button("Edit") {
                        editJournal(entry: entry)
                    }
                    .tint(Color(hex: "#7F81FF"))
                }
                .swipeActions(edge: .trailing) {
                    Button("Delete") {
                        deleteJournalEntry(at: IndexSet(integer: journalEntries.firstIndex(where: { $0.id == entry.id })!))
                    }
                    .tint(.red)
                }
            }
            .onDelete(perform: deleteJournalEntry)
        }
        .listStyle(PlainListStyle())
        .background(Color(hex: "000000"))
    }

    private func filteredJournalEntries() -> [JournalEntry] {
        let filteredBySearch = journalEntries.filter {
            searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText) || $0.content.localizedCaseInsensitiveContains(searchText)
        }
        
        switch selectedFilter {
        case "Bookmark":
            return filteredBySearch.filter { $0.isBookmarked }
        case "Journal Date":
            return filteredBySearch.sorted { $0.date > $1.date }
        default:
            return filteredBySearch
        }
    }

    private func editJournal(entry: JournalEntry) {
        // Edit journal entry logic here
        saveJournalEntries()
    }

    private func deleteJournalEntry(at offsets: IndexSet) {
        journalEntries.remove(atOffsets: offsets)
        saveJournalEntries()  
    }

    private func loadJournalEntries() {
        if let data = UserDefaults.standard.data(forKey: "journalEntries") {
            let decoder = JSONDecoder()
            if let loadedEntries = try? decoder.decode([JournalEntry].self, from: data) {
                journalEntries = loadedEntries
            }
        }
    }

    private func saveJournalEntries() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(journalEntries) {
            UserDefaults.standard.set(encoded, forKey: "journalEntries")
        }
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

#Preview {
    ContentView()
}
