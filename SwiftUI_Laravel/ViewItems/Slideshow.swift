import SwiftUI

struct Slideshow: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @StateObject private var viewModel = SlideshowViewModel()

    let slideInterval: TimeInterval = 5
    let baseImageURL = "http://127.0.0.1:8000/storage/"

    var body: some View {
        VStack(alignment: .trailing, spacing: 15) {
            if viewModel.isLoaded {
                ProgressView("Loading...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                GeometryReader { geometry in
                    let size = geometry.size
                    
                    ScrollViewReader { scrollViewProxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(viewModel.slideshows.indices, id: \.self) { index in
                                    GeometryReader { proxy in
                                        let cardSize = proxy.size
                                        ZStack {
                                            AsyncImage(url: URL(string: baseImageURL + viewModel.slideshows[index].image)) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                Color.gray.opacity(0.3)
                                            }
                                            .frame(width: cardSize.width, height: cardSize.height)
                                            .clipped()
                                            .overlay(
                                                OverlayView(
                                                    title: viewModel.slideshows[index].title,
                                                    subTitle: viewModel.slideshows[index].category?.title ?? ""
                                                )
                                            )
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                        .opacity(currentIndex == index ? 1 : 0.5)
                                    }
                                    .frame(width: size.width - 60, height: size.height - 60)
                                    .id(index)
                                }
                            }
                            .padding(.horizontal, 30)
                            .frame(height: size.height - 30)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation.width
                                    }
                                    .onEnded { _ in
                                        if dragOffset < -50 {
                                            nextSlide()
                                        } else if dragOffset > 50 {
                                            previousSlide()
                                        }
                                        dragOffset = 0
                                    }
                            )
                        }
                        .onChange(of: currentIndex) { newIndex in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(newIndex, anchor: .center)
                            }
                        }
                    }
                }
                .frame(height: 230)
                .padding(.horizontal, -25)
                .padding(.top, 10)
                .padding(.bottom, -55)

                HStack(spacing: 8) {
                    ForEach(0..<viewModel.slideshows.count, id: \.self) { index in
                        Rectangle()
                            .fill(currentIndex == index ? Color.cyan : Color.gray.opacity(1))
                            .frame(width: 20, height: 2)
                            .scaleEffect(currentIndex == index ? 1.3 : 1.0)
                    }
                }
                .padding(.top, -20)
                .padding(.trailing, 20)
            }
        }
        .padding(15)
        .onAppear {
            viewModel.fetchSlideshows()
            startAutoSlide()
        }
    }

    func startAutoSlide() {
        Timer.scheduledTimer(withTimeInterval: slideInterval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                if !viewModel.slideshows.isEmpty {
                    currentIndex = (currentIndex + 1) % viewModel.slideshows.count
                }
            }
        }
    }

    func nextSlide() {
        if !viewModel.slideshows.isEmpty {
            currentIndex = (currentIndex + 1) % viewModel.slideshows.count
        }
    }

    func previousSlide() {
        if !viewModel.slideshows.isEmpty {
            currentIndex = (currentIndex - 1 + viewModel.slideshows.count) % viewModel.slideshows.count
        }
    }

    @ViewBuilder
    func OverlayView(title: String, subTitle: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [.clear, .clear, .black.opacity(0.1), .black.opacity(0.5), .black],
                startPoint: .top, endPoint: .bottom
            )
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .lineLimit(1)
                Text(subTitle)
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
            .padding(20)
        }
    }
}

#Preview {
    Slideshow()
}
