//
//  AboutApp.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 28.06.2023.
//

import SwiftUI
import StoreKit
import UIKit
import WebKit
//import HidableTabView

struct AboutApp: View {
    let appId = "6450751867"
    @State private var appVersion: String = ""
    @State private var buildNumber: String = ""
    @EnvironmentObject var tabBarController: TabBarController
    
    var body: some View {
            VStack{
                Spacer()
                Image("recall")
                    .resizable()
                    .frame(width: 180, height: 180, alignment: .center)
                    .cornerRadius(40)
                
                Text("cRecallLingo")
                    .font(.title)
                
                Text("aAppVersion".localized() + appVersion + "aBuild".localized() + buildNumber + ")")
                    .font(.footnote)
                    .padding(.bottom, 20)
                
                
                Form{
                    Section{
                        
                        HStack{
                           
                                Label("aShareFriends", systemImage: "square.and.arrow.up")
                                    .foregroundColor(.myYellow)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .opacity(0.5)
                        }
                        .onTapGesture {
                            shareApp()
                        }
                        
                        HStack{
                                Label("aRateApp", systemImage: "star")
                                .foregroundColor(.myYellow)
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .opacity(0.5)
                        }
                        .onTapGesture {
                            rateApp()
                        }
                        
                        HStack{
                            Label("aShowAppStore", systemImage: "arrow.up.right.square")
                                .foregroundColor(.myYellow)
                                .background(
                                    Link("", destination: .init(string: "https://apps.apple.com/app/id\(appId)")!)
                                )

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .opacity(0.5)
                        }
                        
                        HStack{
                            Label("aPrivacyPolicy", systemImage: "hand.raised")
                                .foregroundColor(.myYellow)
                                .background(NavigationLink("", destination: DocumentView(type: .privacyPolicy)))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .opacity(0.5)
                        }
                        
                        HStack{
                            Label("aTermsUse", systemImage: "doc.text")
                                .foregroundColor(.myYellow)
                                .background(NavigationLink("", destination: DocumentView(type: .termsOfUse)))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.caption)
                                .opacity(0.5)
                        }
                        
                        
                    }
                    .listRowBackground(Color.myPurple)
                }
                .tint(Color.myYellow)
                .background(Color.myPurpleDark)
                .clearListBackground()
                
                Spacer()
            }
            .navigationTitle("aAboutApp")
            .background(Color.myPurpleDark)
            .onAppear {
                fetchAppVersion()
                  
//                        UITabBar.hideTabBar(animated: false)
                tabBarController.isVisible = false
                    
            }
        }
    
    func showInAppStore() {
           guard let url = URL(string: "https://apps.apple.com/app/id\(appId)") else {
               return
           }

           UIApplication.shared.open(url, options: [:], completionHandler: nil)
       }
    
    func shareApp() {
        let shareText = "Раджу спробувати додаток \"Recall Lingo\" - англійсько-український офлайн-перекладач з чат-інтерфейсом, особистим словником та сповіщеннями для кращого запам'ятовування слів. Він дуже зручний та допоможе покращити свої знання англійської мови. Посилання:" + " https://itunes.apple.com/app/id\(appId) + Мій друг вже користується ним і рекомендує всім, хто хоче навчатись краще!"
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        window.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }


    func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
    }

    func fetchAppVersion() {
        let kVersion = "CFBundleShortVersionString"
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary[kVersion] as! String
        appVersion = version
        
        let kBuild = "CFBundleVersion"
        let build = dictionary[kBuild] as! String
        buildNumber = build
    }
}

//struct AboutApp_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutApp()
//            
//    }
//}

struct DocumentView: UIViewControllerRepresentable {
    let type: DocumentType
    
    var urlString: String{
        type.rawValue
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let webView = WKWebView()
        webView.backgroundColor = UIColor.black
        webView.scrollView.backgroundColor = UIColor.black
        webView.backgroundColor = .red
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        let viewController = UIViewController()
            viewController.view = webView
        viewController.view.backgroundColor = .black
            return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

enum DocumentType: String {
    case privacyPolicy = "https://recalllingo.wordpress.com/privacy-policy/"
    case termsOfUse = "https://recalllingo.wordpress.com/terms-and-conditions/"
}

