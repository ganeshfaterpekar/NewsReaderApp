//
//  NewsReaderUI.swift
//  NewsReaderApp
//
//  Created by Ganesh Faterpekar on 2/1/2026.
//

import MBUILibrary
import Foundation

enum NewsReaderUI {
    typealias HeadlinesRowView =  ThumbnailDescriptionView
    typealias SavedRowItemsView = ThumbnailDescriptionView
    
    static func makeHeadlinesRowItemsView(articleItem: Article, isSaved:Bool, onSave:@escaping () -> Void ) -> HeadlinesRowView {
        return HeadlinesRowView(
            imageUrl: articleItem.imageUrl,
            title: articleItem.title,
            subtitle: articleItem.author,
            description: articleItem.description,
            isSaved: isSaved,
            OnToggleSave: onSave
        )
    }
    
    static func makeSavedRowItemsView(articleItem: Article) -> SavedRowItemsView {
        return SavedRowItemsView(
            imageUrl: articleItem.imageUrl,
            title: articleItem.title,
            subtitle: articleItem.author ,
            description: articleItem.description,
            isSaved: true,
            OnToggleSave: {}
        )
    }
}
