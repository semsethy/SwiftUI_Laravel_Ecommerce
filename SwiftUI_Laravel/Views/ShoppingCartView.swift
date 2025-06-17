import SwiftUI
import PassKit

struct ShoppingCartScreen: View {
    var body: some View {
        NavigationView {
            ShoppingCartView()
        }
    }
}
struct ShoppingCartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var paymentSuccess = false
    @State private var showPaymentAlert = false
    var body: some View {
        VStack {
            if cartViewModel.cartItems.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "cart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)

                    Text("Your shopping cart is empty")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .transition(.opacity)
            } else {
                ScrollView {
                    ForEach(cartViewModel.cartItems) { cart in
                        CartView(cartItem: cart,
                             onDelete: {
                                refreshCart()
                            },
                             onQuantityChanged: {
                                refreshCart()
                            }
                        )
                    }
                    .padding(.top, 10)
                }
                HStack {
                    Text("Total: ")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(Color(white: 0.2))
                    Spacer()
                    Text(String(format: "$%.2f", cartViewModel.totalPrice))
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .bold()
                }
                .padding(.horizontal, 18)
                Button(action: {
//                initiateApplePay()
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
                .alert(isPresented: $showPaymentAlert) {
                    Alert(
                        title: Text(paymentSuccess ? "Payment Success" : "Payment Failed"),
                        message: Text(paymentSuccess ? "Your payment was successful!" : "There was an issue with your payment."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .onAppear {
            cartViewModel.fetchCart()
            cartViewModel.fetchCartItemCount()
        }
        .navigationTitle("Shopping Carts")
    }
    private func refreshCart() {
        cartViewModel.fetchCart()
        cartViewModel.fetchCartItemCount()
    }
    
    func initiateApplePay() {
        if PKPaymentAuthorizationViewController.canMakePayments() {
            let paymentRequest = createPaymentRequest()
            if let paymentAuthorizationVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                paymentAuthorizationVC.delegate = PaymentAuthorizationDelegate(onPaymentSuccess: {
                    paymentSuccess = true
                    showPaymentAlert = true
                }, onPaymentFailure: {
                    paymentSuccess = false
                    showPaymentAlert = true
                })
                if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                    rootVC.present(paymentAuthorizationVC, animated: true, completion: nil)
                }
            }
        } else {
            print("Apple Pay is not available on this device.")
        }
    }
    func createPaymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "com.yourapp.merchantid"
        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        let totalAmount = cartViewModel.totalPrice
        let paymentSummaryItem = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: totalAmount))
        paymentRequest.paymentSummaryItems = [paymentSummaryItem]
        return paymentRequest
    }
}

class PaymentAuthorizationDelegate: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    var onPaymentSuccess: () -> Void
    var onPaymentFailure: () -> Void
    init(onPaymentSuccess: @escaping () -> Void, onPaymentFailure: @escaping () -> Void) {
        self.onPaymentSuccess = onPaymentSuccess
        self.onPaymentFailure = onPaymentFailure
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Handle the payment response
        // Send the payment data to your backend server for processing (e.g., to charge the payment)
        
        // Simulating payment success or failure here
        let success = true 
        
        if success {
            onPaymentSuccess()
        } else {
            onPaymentFailure()
        }
        
        handler(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
