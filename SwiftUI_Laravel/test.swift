import SwiftUI

struct test: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var finalOffset: CGFloat = 0
    @State private var isDragging: Bool = false

    // Define tripCards as an array of identifiable objects
    struct SlideShow: Identifiable {
        let id = UUID()
        let imageName: String
        let title: String
        let subTitle: String
    }

    let slideshows = [
        SlideShow(imageName: "C29D681A-2F3B-44E1-84CE-3DFF6B43C866_1_105_c", title: "Paris", subTitle: "Me"),
        SlideShow(imageName: "C5A497B8-CC14-413E-894F-57739B953F28_1_105_c", title: "Singapore", subTitle: "Me"),
        SlideShow(imageName: "C4F6BDEB-0CC6-4AF9-8AB7-8A443EDC98E0_1_105_c", title: "New York", subTitle: "Me"),
        SlideShow(imageName: "C29D681A-2F3B-44E1-84CE-3DFF6B43C866_1_105_c", title: "Paris", subTitle: "Me"),
        SlideShow(imageName: "C5A497B8-CC14-413E-894F-57739B953F28_1_105_c", title: "Singapore", subTitle: "Me"),
        SlideShow(imageName: "C4F6BDEB-0CC6-4AF9-8AB7-8A443EDC98E0_1_105_c", title: "New York", subTitle: "Me")
    ]

    // Timer to change the image every few seconds
    let slideInterval: TimeInterval = 3.0  // Change slide every 3 seconds

    var body: some View {
        VStack(spacing: 15) {
            GeometryReader { geometry in
                let size = geometry.size
                
                // Wrap ScrollView in ScrollViewReader to allow programmatic scrolling
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
                                        .offset(x: dragOffset + finalOffset) // This allows the image to follow the drag
                                        .gesture(
                                            DragGesture()
                                                .onChanged { value in
                                                    isDragging = true
                                                    dragOffset = value.translation.width
                                                }
                                                .onEnded { value in
                                                    // When the drag ends, determine the direction of the swipe
                                                    if value.translation.width < -50 {  // Swipe left
                                                        nextSlide()
                                                    } else if value.translation.width > 50 {  // Swipe right
                                                        previousSlide()
                                                    }
                                                    finalOffset += dragOffset // Keep the final offset after the drag
                                                    dragOffset = 0  // Reset dragOffset for the next drag
                                                    isDragging = false
                                                }
                                        )
                                }
                                .frame(width: size.width - 60, height: size.height - 60)
                                .id(index) // Set unique ID for each item to scroll to
                            }
                        }
                        .padding(.horizontal, 30)
                        .scrollTargetLayout()
                        .frame(height: size.height - 30, alignment: .top)
                    }
                    .onChange(of: currentIndex) { newIndex in
                        // Scroll to the current index when it changes
                        withAnimation(.easeInOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(newIndex, anchor: .center)
                        }
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                    .scrollTargetLayout()
                }
            }
            .frame(height: 250)
            .padding(.horizontal, -15)
            .padding(.top, 10)
            .padding(.bottom, -55)

            // Slideshow indicator
            HStack(spacing: 8) {
                ForEach(0..<slideshows.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? Color.cyan : Color.gray.opacity(0.5))
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentIndex == index ? 1.3 : 1.0) // Scale the active dot
                }
            }
            .padding(.top, 1)
            
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
                Text(card.title).font(.title2).foregroundColor(.white).fontWeight(.black)
                Text(card.subTitle).font(.callout).foregroundColor(.white.opacity(0.8))
            })
            .padding(20)
        }
    }
}

#Preview {
    test()
}
