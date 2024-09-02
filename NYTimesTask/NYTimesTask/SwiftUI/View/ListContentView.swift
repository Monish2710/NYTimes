//
//  ListContentView.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import CoreData
import SwiftUI

struct ListContentView: View {
    @StateObject private var viewModel = GenericViewModel<DataResponseModel>(
        apiClient: NYTimesAPIClient()
    )

    var body: some View {
        NavigationView {
            List {
                if let articles = viewModel.data {
                    ForEach(articles) { article in
                        ArticleRowView(article: article)
                            .onTapGesture {
                                if let url = URL(string: article.url) {
                                    openURL(url)
                                }
                            }
                    }
                } else if viewModel.error != nil {
                    Text("Failed to load articles")
                } else {
                    Text("Loading...")
                }
            }
            .navigationTitle("NY Times")
            .task {
                await viewModel.fetchData()
            }
        }
    }

    private func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct ArticleRowView: View {
    var article: ResultModel

    var body: some View {
        HStack(spacing: 8) {
            LoadImageView(url: URL(string: article.media.first?.mediaMetadata.last?.url ?? "")!)
                .aspectRatio(contentMode: .fill)
                .frame(width: 100)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(article.byline)
                    .font(.subheadline)
                    .lineLimit(1)
                Text(article.publishedDate)
                    .font(.caption)
                    .lineLimit(1)
            }
        }
        .frame(height: 100)
    }
}
