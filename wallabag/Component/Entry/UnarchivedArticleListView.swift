//
//  UnarchivedArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 27/10/2019.
//

import CoreData
import Foundation
import SwiftUI

struct UnarchivedArticleListView: View {
    static func fetchRequest() -> NSFetchRequest<Entry> {
        let fetchRequest = Entry.fetchRequestSorted()
        fetchRequest.predicate = RetrieveMode.unarchivedArticles.predicate()
        return fetchRequest
    }

    @FetchRequest(fetchRequest: fetchRequest()) var entries: FetchedResults
    var body: some View {
        ArticleListView(entries: .constant(entries))
    }
}