//
//  AppDelegate.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import MobilePayAPI
import ClipCardAPI
import Client
import Entities
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        FirebaseApp.configure()
        setupMobilePay()
        setupNavigationBar()

        startSession()
        window?.makeKeyAndVisible()
        return true
    }

    func startSession() {
        window?.rootViewController = LoginViewController(viewModel: LoginViewModel())
    }

    func setupMobilePay() {
        #if DEBUG
        MobilePayManager.sharedInstance().setup(withMerchantId: "APPDK0000000000", merchantUrlScheme: "Analog", country: .denmark)
        #else
        MobilePayManager.sharedInstance().setup(withMerchantId: "APPDK1882644001", merchantUrlScheme: "Analog", country: .denmark)
        #endif
    }

    func setupNavigationBar() {
        UINavigationBar.appearance().barTintColor = Color.espresso
        UINavigationBar.appearance().tintColor = Color.milk
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.milk]
        UINavigationBar.appearance().isTranslucent = false
    }

    func completePurchase(transactionId: String, orderId: String) {
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        let parameters = ["transactionId": transactionId, "orderId": orderId]
        MobilePay.completePurchase().response(using: api, method: .post, parameters: parameters, headers: [:], response: { response in
            switch response {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mobilepay_transaction_success"), object: nil)
            case .error(let error):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mobilepay_transaction_error"), object: error)
            }
        })
    }

    func handleMobilePayPaymentWithUrl(url: URL) {
        MobilePayManager.sharedInstance().handleMobilePayPayment(with: url, success: { response in
            let transactionId = response?.transactionId ?? ""
            let orderId = response?.orderId ?? ""
            DispatchQueue.global(qos: .background).async {
                self.completePurchase(transactionId: transactionId, orderId: orderId)
            }
        }, error: { error in
            print("MobilePay purchase failed: \(error.localizedDescription)")
        }, cancel: { cancel in
            print("MobilePay purchase cancelled by user. \(cancel?.orderId ?? "")")
        })
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        handleMobilePayPaymentWithUrl(url: url)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

