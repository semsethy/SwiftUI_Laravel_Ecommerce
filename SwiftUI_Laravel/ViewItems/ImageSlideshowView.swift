import SwiftUI

struct ImageSlideshowView: View {
    let slideshows: [Slideshows]
    let baseImageURL = "http://127.0.0.1:8000/storage/"
    
    @State private var currentIndex = 0
    @State private var isDragging = false

    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            if slideshows.isEmpty {
                ProgressView("Loading slides...")
            } else {
                GeometryReader { geometry in
                    ZStack(alignment: .bottomTrailing) {
                        TabView(selection: $currentIndex) {
                            ForEach(Array(slideshows.enumerated()), id: \.element.id) { index, item in
                                CachedAsyncImage(url: baseImageURL + item.image)
                                    .scaledToFill()
                                    .frame(width: geometry.size.width)
                                    .clipped()
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .onReceive(timer) { _ in
                            guard !isDragging else { return }
                            withAnimation {
                                currentIndex = (currentIndex + 1) % slideshows.count
                            }
                        }

                        // Overlay View
                        if slideshows.indices.contains(currentIndex) {
                            OverlayView(
                                title: slideshows[currentIndex].title,
                                subTitle: slideshows[currentIndex].category?.title ?? ""
                            )
                        }

                        // Slideshow indicators
                        HStack(spacing: 8) {
                            ForEach(0..<slideshows.count, id: \.self) { index in
                                Rectangle()
                                    .fill(currentIndex == index ? Color.cyan : Color.gray.opacity(0.5))
                                    .frame(width: 20, height: 2)
                                    .scaleEffect(currentIndex == index ? 1.3 : 1.0)
                                    .animation(.easeInOut(duration: 0.3), value: currentIndex)
                            }
                        }
                        .padding(10)
                    }
                }
            }
        }
        .frame(height: 180)
        .cornerRadius(12)
    }

    // MARK: - Overlay View

    @ViewBuilder
    func OverlayView(title: String, subTitle: String) -> some View {
        LinearGradient(
            colors: [.clear, .clear, .black.opacity(0.3), .black.opacity(0.4), .black.opacity(0.5), .black.opacity(0.6)],
            startPoint: .top, endPoint: .bottom
        )
        .frame(height: 80)
        .overlay(
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .lineLimit(1)
                    .accessibilityLabel("Slide title: \(title)")

                Text(subTitle)
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
                    .accessibilityLabel("Category: \(subTitle)")
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8),
            alignment: .bottomLeading
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }
}
