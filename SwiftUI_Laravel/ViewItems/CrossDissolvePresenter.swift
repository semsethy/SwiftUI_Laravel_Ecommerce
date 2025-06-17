//
//  CrossDissolvePresenter.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 11/4/25.
//


import SwiftUI

struct CrossDissolvePresenter<Content: View>: UIViewControllerRepresentable {
    let content: Content
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented && uiViewController.presentedViewController == nil {
            let hosting = UIHostingController(rootView: content)
            hosting.modalPresentationStyle = .fullScreen
            hosting.modalTransitionStyle = .crossDissolve
            uiViewController.present(hosting, animated: true)
        } else if !isPresented && uiViewController.presentedViewController != nil {
            uiViewController.dismiss(animated: true)
        }
    }
}
