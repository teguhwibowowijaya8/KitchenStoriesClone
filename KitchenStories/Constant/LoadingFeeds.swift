//
//  LoadingFeeds.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 13/04/23.
//

import Foundation

enum LoadingFeeds {
    static let feeds: FeedResultsModel = FeedResultsModel(results: [
        FeedModel(
            type: .featured,
            name: "Featured",
            category: "featured",
            minItems: 1,
            item: nil,
            items: [FeedItemModel]()
        ),
        FeedModel(
            type: .shoppableCarousel,
            name: "Shoppable Carousel",
            category: "shoppable-carousel",
            minItems: 3,
            item: nil,
            items: [FeedItemModel]()
        ),
        FeedModel(
            type: .carousel,
            name: "Carousel 1",
            category: "carousel-1",
            minItems: 5,
            item: nil,
            items: [FeedItemModel]()
        ),
        FeedModel(
            type: .carousel,
            name: "Carousel 2",
            category: "carousel-2",
            minItems: 5,
            item: nil,
            items: [FeedItemModel]()
        ),
        FeedModel(
            type: .carousel,
            name: "Carousel 3",
            category: "carousel-3",
            minItems: 5,
            item: nil,
            items: [FeedItemModel]()
        ),
        FeedModel(
            type: .recent,
            name: "Recent",
            category: "recent",
            minItems: 10,
            item: nil,
            items: [FeedItemModel]()
        ),
    ])
}
