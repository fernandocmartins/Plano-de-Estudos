import UIKit

struct NotificationIdentifier {
    static let confirm = "Confirm"
    static let cancel = "Cancel"
    static let category = "Lembrete"
    static let confirmed = "Confirmed"
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        center.delegate = self
        center.getNotificationSettings { setting in
            switch setting.authorizationStatus {
            case .notDetermined:
                self.center.requestAuthorization(options: [.sound, .alert, .badge, .carPlay]) { authorized, error in
                    print("O usuario autorizou?", authorized)
                }
            case .authorized:
                print("user aceitou! só alegria! Vendeu a alma!")
            default:
                print("provavelmente o user nao aceitou, vou bolar uma estrategia!")
            }
        }
        
        let confirmAction = UNNotificationAction(identifier: NotificationIdentifier.confirm,
                                                 title: "Já estudei!",
                                                 options: [.foreground])
        
        let cancelAction = UNNotificationAction(identifier: NotificationIdentifier.cancel,
                                                title: "Cancelar",
                                                options: [])
        
        let category = UNNotificationCategory(identifier: NotificationIdentifier.category,
                                              actions: [confirmAction, cancelAction],
                                              intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                
//        let title = response.notification.request.content.title

        switch response.actionIdentifier {
        case NotificationIdentifier.confirm:
            print("apertou botao confirmar")
            let id = response.notification.request.identifier
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationIdentifier.confirmed),
                                            object: nil,
                                            userInfo: ["id": id])
            
        case NotificationIdentifier.cancel:
            print("apertou botao cancelar")
        case UNNotificationDefaultActionIdentifier:
            print("apertou na notificacao")
        case UNNotificationDismissActionIdentifier:
            print("dismissou a noitificacao")
        default:
            print("alguma outra coisa foi feita")
        }
        
        completionHandler()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner])
    }
}
