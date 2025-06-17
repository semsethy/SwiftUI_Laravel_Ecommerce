//import SwiftUI
//
//struct Test: View {
//    struct SlideShow: Identifiable {
//        let id = UUID()
//        let imageName: String
//        let title: String
//        let subTitle: String
//    }
//
//    let slideshows = [
//        SlideShow(imageName: "C29D681A-2F3B-44E1-84CE-3DFF6B43C866_1_105_c", title: "Paris", subTitle: "Me"),
//        SlideShow(imageName: "C5A497B8-CC14-413E-894F-57739B953F28_1_105_c", title: "Singapore", subTitle: "Me"),
//        SlideShow(imageName: "C4F6BDEB-0CC6-4AF9-8AB7-8A443EDC98E0_1_105_c", title: "New York", subTitle: "Me"),
//        SlideShow(imageName: "C29D681A-2F3B-44E1-84CE-3DFF6B43C866_1_105_c", title: "Paris", subTitle: "Me"),
//        SlideShow(imageName: "C5A497B8-CC14-413E-894F-57739B953F28_1_105_c", title: "Singapore", subTitle: "Me"),
//        SlideShow(imageName: "C4F6BDEB-0CC6-4AF9-8AB7-8A443EDC98E0_1_105_c", title: "New York", subTitle: "Me")
//    ]
//
//    var body: some View {
//        VStack(spacing: 15) {
//            GeometryReader { geometry in
//                let totalWidth = geometry.size.width
//                let cardWidth = totalWidth * 0.5 // 70% of screen width
//                let spacing: CGFloat = 5
//                let horizontalPadding = (totalWidth - cardWidth) / 2
//
//                ScrollView(.horizontal) {
//                    HStack(spacing: spacing) {
//                        ForEach(slideshows.indices, id: \.self) { index in
//                            GeometryReader { proxy in
//                                let size = proxy.size
//                                Image(slideshows[index].imageName)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: cardWidth, height: geometry.size.height - 50)
////                                    .overlay(content: {
////                                        OverlayView(slideshows[index])
////                                    })
//                                    .clipShape(RoundedRectangle(cornerRadius: 14))
//                                    .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
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
//            .frame(height: 250)
//        }
//    }
//
//    @ViewBuilder
//    func OverlayView(_ card: SlideShow) -> some View {
//        ZStack(alignment: .bottomLeading) {
//            LinearGradient(colors: [
//                .clear,
//                .clear,
//                .clear,
//                .black.opacity(0.1),
//                .black.opacity(0.5),
//                .black
//            ], startPoint: .top, endPoint: .bottom)
//            VStack(alignment: .leading, spacing: 4) {
//                Text(card.title)
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .fontWeight(.black)
//                Text(card.subTitle)
//                    .font(.callout)
//                    .foregroundColor(.white.opacity(0.8))
//            }
//            .padding(20)
//        }
//    }
//}
//
//#Preview {
//    Test()
//}



import SwiftUI
//
//struct ImageCollection: View {
//    
//    var imageURLs: [String]
//    
//    struct SlideShow: Identifiable {
//        let id = UUID()
//        let imageName: String
//        let title: String
//        let subTitle: String
//    }
//
//    let slideshows = [
//        SlideShow(imageName: "C29D681A-2F3B-44E1-84CE-3DFF6B43C866_1_105_c", title: "Paris", subTitle: "Me"),
//        SlideShow(imageName: "C5A497B8-CC14-413E-894F-57739B953F28_1_105_c", title: "Singapore", subTitle: "Me"),
//        SlideShow(imageName: "C4F6BDEB-0CC6-4AF9-8AB7-8A443EDC98E0_1_105_c", title: "New York", subTitle: "Me"),
//        SlideShow(imageName: "C29D681A-2F3B-44E1-84CE-3DFF6B43C866_1_105_c", title: "Paris", subTitle: "Me"),
//        SlideShow(imageName: "C5A497B8-CC14-413E-894F-57739B953F28_1_105_c", title: "Singapore", subTitle: "Me"),
//        SlideShow(imageName: "C4F6BDEB-0CC6-4AF9-8AB7-8A443EDC98E0_1_105_c", title: "New York", subTitle: "Me")
//    ]
//
//    var body: some View {
//        VStack(spacing: 15) {
//            GeometryReader { geometry in
//                let totalWidth = geometry.size.width
//                let cardWidth = totalWidth * 0.5 // 70% of screen width
//                let spacing: CGFloat = 5
//                let horizontalPadding = (totalWidth - cardWidth) / 2
//
//                ScrollView(.horizontal) {
//                    HStack(spacing: spacing) {
//                        ForEach(slideshows.indices, id: \.self) { index in
//                            GeometryReader { proxy in
//                                let size = proxy.size
//                                Image(slideshows[index].imageName)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: cardWidth, height: geometry.size.height - 50)
////                                    .overlay(content: {
////                                        OverlayView(slideshows[index])
////                                    })
//                                    .clipShape(RoundedRectangle(cornerRadius: 14))
//                                    .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
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
//
//    @ViewBuilder
//    func OverlayView(_ card: SlideShow) -> some View {
//        ZStack(alignment: .bottomLeading) {
//            LinearGradient(colors: [
//                .clear,
//                .clear,
//                .clear,
//                .black.opacity(0.1),
//                .black.opacity(0.5),
//                .black
//            ], startPoint: .top, endPoint: .bottom)
//            VStack(alignment: .leading, spacing: 4) {
//                Text(card.title)
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .fontWeight(.black)
//                Text(card.subTitle)
//                    .font(.callout)
//                    .foregroundColor(.white.opacity(0.8))
//            }
//            .padding(20)
//        }
//    }
//}
//
////#Preview {
////    ImageCollection()
////}
