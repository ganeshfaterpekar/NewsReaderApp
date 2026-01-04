// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct ThumbnailDescriptionView: View {
    let imageUrl: URL?
    let title: String
    let subtitle: String
    let description: String
    
    let isSaved: Bool
    let OnToggleSave: () -> Void
    
    public init(imageUrl: URL?, title: String, subtitle: String, description: String, isSaved: Bool = false ,OnToggleSave: @escaping () -> Void) {
        self.imageUrl = imageUrl
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.OnToggleSave = OnToggleSave
        self.isSaved = isSaved
    }
    

    public var body: some View {
        HStack(alignment: .top, spacing: 12)  {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width:80, height:80)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width:80, height:80)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .frame(width: 80,height: 80)
                            .foregroundStyle(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(8)
                
                Button {
                    OnToggleSave()
                } label : {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }.buttonStyle(.plain)
                 .padding(6)
                 .contentShape(Circle())
                 .offset(x:8,y:20)
            }
            VStack(alignment: .leading, spacing: 6)  {
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }.padding(.vertical, 8)
    }
}
