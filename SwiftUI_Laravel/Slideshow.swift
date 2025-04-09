import SwiftUI

struct Slideshow: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0

    // Define tripCards as an array of identifiable objects
    struct SlideShow: Identifiable {
        let id = UUID()
        let imageName: String
        let title: String
        let subTitle: String
    }

    let slideshows = [
        SlideShow(imageName: "pexels-photo-30265373", title: "Spider Mouse", subTitle: "Apple Inc."),
        SlideShow(imageName: "pexels-photo-20694722", title: "Mechanical Keyboard", subTitle: "Electronic"),
        SlideShow(imageName: "pexels-photo-5334179", title: "Mac Keyboard", subTitle: "Apple Inc."),
        SlideShow(imageName: "pexels-photo-4006158", title: "MacBook - M1", subTitle: "Apple Inc."),
        SlideShow(imageName: "pexels-photo-7690080", title: "MacBook - M2", subTitle: "Apple Inc."),
        SlideShow(imageName: "pexels-photo-4006151", title: "MacBook - Air", subTitle: "Apple Inc.")
    ]

    // Timer to change the image every few seconds
    let slideInterval: TimeInterval = 5

    var body: some View {
        VStack(alignment:.trailing,spacing: 15) {
            GeometryReader { geometry in
                let size = geometry.size
                
                // Wrap the ScrollView in a ScrollViewReader to allow programmatic scrolling
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(slideshows.indices, id: \.self) { index in
                                GeometryReader { proxy in
                                    let cardSize = proxy.size
                                    Image(slideshows[index].imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .overlay(content: {
                                            OverlayView(slideshows[index])
                                        })
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                        .opacity(currentIndex == index ? 1 : 0.5) // Fade effect for non-active images
                                }
                                .frame(width: size.width - 60, height: size.height - 60)
                                .id(index) // Set unique ID for each item to scroll to
                            }
                        }
                        .padding(.horizontal, 30)
                        .frame(height: size.height - 30, alignment: .top)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation.width
                                }
                                .onEnded { value in
                                    if dragOffset < -50 {  // Swipe left
                                        nextSlide()
                                    } else if dragOffset > 50 {  // Swipe right
                                        previousSlide()
                                    }
                                    dragOffset = 0
                                }
                        )
                    }
                    .onChange(of: currentIndex) { newIndex in
                        // Scroll to the current index when it changes
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

            // Slideshow indicator
            HStack(spacing: 8) {
                ForEach(0..<slideshows.count, id: \.self) { index in
                    Rectangle()
                        .fill(currentIndex == index ? Color.cyan : Color.gray.opacity(1))
                        .frame(width: 20, height: 2)
                        .scaleEffect(currentIndex == index ? 1.3 : 1.0) // Scale the active dot
                }
            }
            .padding(.top, -35)
            .padding(.trailing,20)
            
        }
        .padding(15)
        .onAppear {
            startAutoSlide()
        }
    }
    
    // Function to start the auto-sliding behavior
    func startAutoSlide() {
        Timer.scheduledTimer(withTimeInterval: slideInterval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % slideshows.count
            }
        }
    }
    
    // Function to go to the next slide
    func nextSlide() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentIndex = (currentIndex + 1) % slideshows.count
        }
    }
    
    // Function to go to the previous slide
    func previousSlide() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentIndex = (currentIndex - 1 + slideshows.count) % slideshows.count
        }
    }

    @ViewBuilder
    func OverlayView(_ card: SlideShow) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 4, content: {
                Text(card.title).font(.title2).foregroundColor(.white).fontWeight(.black).lineLimit(1)
                Text(card.subTitle).font(.callout).foregroundColor(.white.opacity(0.8)).lineLimit(1)
            })
            .padding(20)
        }
    }
}

#Preview {
    Slideshow()
}
