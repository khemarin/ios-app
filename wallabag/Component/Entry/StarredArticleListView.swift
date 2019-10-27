//
//  StarredArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 27/10/2019.
//

import Foundation
import SwiftUI
import CoreData

struct StarredArticleListView: View {
    static func fetchRequest() -> NSFetchRequest<Entry> {
        let fetchRequest = Entry.fetchRequestSorted()
        fetchRequest.predicate = RetrieveMode.starredArticles.predicate()
        return fetchRequest
    }
    
    @FetchRequest(fetchRequest: fetchRequest()) var entries: FetchedResults
    var body: some View {
        ArticleListView(entries: .constant(entries))
    }
}
