import SwiftUI

struct ProductDetailView: View {

    var body: some View {
        VStack {
            ScrollView{
                ForEach(1 ... 10, id: \.self){_ in
                    CartView()
                }
            }
            HStack{
                Text("Total: ")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color(white:0.2))
                Spacer()
                Text("$300.00")
                    .font(.system(size: 18))
                    .foregroundColor(.red)
                    .bold()
            }.padding(.horizontal, 20)
            Button(action: {
                // Handle logout action
            }) {
                Text("Checkout Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle(Text("Shopping Carts"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProductDetailView()
}
