//
//  ArticleView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import CoreData
import SwiftUI

struct EntryView: View {
    @ObservedObject var entry: Entry
    @EnvironmentObject var entryPublisher: EntryPublisher
    @EnvironmentObject var appState: AppState
    @State var showTag: Bool = false

    var body: some View {
        VStack {
            WebView(entry: entry)
            HStack {
                ArchiveEntryButton(entry: entry, showText: false)
                StarEntryButton(entry: entry, showText: false)
                Button(action: {
                    self.showTag.toggle()
                }, label: {
                    Image(systemName: "tag")
                })
                Spacer()
                DeleteEntryButton(entry: entry, showText: false)
            }.padding()
                .sheet(isPresented: $showTag, content: {
                    TagListFor(entry: self.entry)
                        .environmentObject(self.appState)
                        .environment(\.managedObjectContext, CoreData.shared.viewContext)
                })
        }.navigationBarTitle(entry.title ?? "")
    }
}

#if DEBUG
    struct EntryView_Previews: PreviewProvider {
        static var previews: some View {
            EntryView(entry: Entry())
        }
    }
#endif