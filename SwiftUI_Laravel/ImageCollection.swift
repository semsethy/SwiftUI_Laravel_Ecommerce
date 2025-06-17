import SwiftUI

struct ImageCollection: View {

    var imageURLs: [String]
    let baseImageURL = "http://127.0.0.1:8000/storage/"

    var body: some View {
        VStack(spacing: 15) {
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let cardWidth = totalWidth * 0.5
                let spacing: CGFloat = 5
                let horizontalPadding = (totalWidth - cardWidth) / 2

                ScrollView(.horizontal) {
                    HStack(spacing: spacing) {
                        ForEach(imageURLs.indices, id: \.self) { index in
                            GeometryReader { proxy in
                                if let url = URL(string: baseImageURL + imageURLs[index]) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: cardWidth, height: geometry.size.height - 50)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: cardWidth, height: geometry.size.height - 50)
                                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                                .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                        case .failure:
                                            Image(systemName: "xmark.octagon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cardWidth, height: geometry.size.height - 50)
                                                .foregroundColor(.red)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                            }
                            .frame(width: cardWidth, height: geometry.size.height - 50)
                            .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                view
                                    .scaleEffect(phase.isIdentity ? 1 : 0.4)
                            }
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .scrollTargetLayout()
                    .frame(height: geometry.size.height - 30, alignment: .top)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            }
            .frame(height: 200)
        }
    }
}


//#Preview {
//    ImageCollection()
//}




//import SwiftUI
//
//struct ImageCollection: View {
//    
//    var imageURLs: [String]
//    
//    var body: some View {
//        VStack(spacing: 15) {
//            GeometryReader { geometry in
//                let totalWidth = geometry.size.width
//                let cardWidth = totalWidth * 0.5
//                let spacing: CGFloat = 5
//                let horizontalPadding = (totalWidth - cardWidth) / 2
//
//                ScrollView(.horizontal) {
//                    HStack(spacing: spacing) {
//                        ForEach(imageURLs, id: \.self) { imageURL in
//                            GeometryReader { proxy in
//                                let size = proxy.size
//                                if let url = URL(string: imageURL) {
//                                    AsyncImage(url: url) { phase in
//                                        switch phase {
//                                        case .empty:
//                                            ProgressView()
//                                                .frame(width: cardWidth, height: geometry.size.height - 50)
//                                        case .success(let image):
//                                            image
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fill)
//                                                .frame(width: cardWidth, height: geometry.size.height - 50)
//                                                .clipShape(RoundedRectangle(cornerRadius: 14))
//                                                .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
//                                        case .failure:
//                                            Image(systemName: "exclamationmark.triangle.fill")
//                                                .resizable()
//                                                .frame(width: cardWidth, height: geometry.size.height - 50)
//                                                .foregroundColor(.red)
//                                                .clipShape(RoundedRectangle(cornerRadius: 14))
//                                        @unknown default:
//                                            EmptyView()
//                                        }
//                                    }
//                                }
//                            }
//                            .frame(width: cardWidth, height: geometry.size.height - 50)
//                            .scrollTransition(.interactive, axis: .horizontal) { view, phase in
//                                view
//                                    .scaleEffect(phase.isIdentity ? 1 : 0.4)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, horizontalPadding)
//                    .scrollTargetLayout()
//                    .frame(height: geometry.size.height - 30, alignment: .top)
//                }
//                .scrollTargetBehavior(.viewAligned)
//                .scrollIndicators(.hidden)
//            }
//            .frame(height: 200)
//        }
//    }
//}
//
////#Preview {
////    ImageCollection()
////}
