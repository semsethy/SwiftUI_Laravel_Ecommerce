import SwiftUI

// Custom shape to allow corner radius on specific corners
struct RoundedCorners: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ProductGrid: View {
    @State private var isHearted = false
    let item: Product
    private let baseURL = "http://127.0.0.1:8000/"
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("-30%")
                    .font(.caption)
                    .padding(5)
                    .foregroundColor(Color.red)
                    .bold()
                    .frame(width: 50, height: 50)
                    .background(Color(white: 1))
                    .clipShape(Circle())
                Spacer()
                Button{
                    isHearted.toggle()
                }label:{
                    Image(systemName: isHearted ? "heart.fill" : "heart")
                        .resizable()
                        .foregroundColor(Color(white: 0.3))
                        .font(.system(size: 5))
                        .frame(width: 20, height: 20)
                        .padding(15)
                        .background(Color(white: 1))
                        .clipShape(Circle())
                }
            }
            .padding([.leading, .trailing, .top], 10)
            .padding(.bottom,-10)
            
            NavigationLink(destination: ProductDetailView()){
                let imageURLString = baseURL + "storage/" + item.mainImageURL
                let size = 140
//                // Check if the URL is valid
                if let url = URL(string: imageURLString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(Double(size)/0.98), height: CGFloat(size))
                            .clipShape(RoundedCorners(corners: [.topLeft, .topRight], radius: 15))
                            .clipped()
                            .padding(.bottom,-12)
                            .padding(.top,-12)
                            .padding([.leading,.trailing],15)
                    } placeholder: {
                        Image("applewatch")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .clipShape(RoundedCorners(corners: [.topLeft, .topRight], radius: 15))
                            .clipped()
                            .padding(.bottom,-12)
                            .padding(.top,-12)
                            .padding([.leading,.trailing],15)
                    }
                } else {
                    Image("applewatch")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipShape(RoundedCorners(corners: [.topLeft, .topRight], radius: 15))
                        .clipped()
                        .padding(.bottom,-12)
                        .padding(.top,-12)
                        .padding([.leading,.trailing],15)
                }
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.productName)
                    .font(.subheadline)
                    .foregroundColor(Color(white: 0.2))
                HStack(spacing: 5) {
                    Text(item.price)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    
                    // Strikethrough price for $1200
                    Text("$1200")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .strikethrough(true, color: .gray) // Apply strikethrough to $1200 only
                }
                HStack{
                    Text(item.category.title)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "cart")
                            .foregroundColor(Color(white: 0.3))
                            .padding(5)
                            .background(Color(white: 0.9))
                            .cornerRadius(6)
                    }
                }
            }
            .padding(8)
            .background(Color.white)
            .clipShape(RoundedCorners(corners: [.bottomLeft, .bottomRight], radius: 15))
            .padding([.leading, .trailing, .bottom], 10)
        }
        .background(Color(white: 0.9))
        .cornerRadius(20)
        .frame(width: 170, height: 120)
        
        
    }
}

//struct ProductGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductGrid(item: )
//    }
//}
