import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var injector: InjectorProtocol!
    var builder: AppBuilderProtocol!
    var coordinator: AppCoordinatorProtocol!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        injector = Injector()
        builder = AppBuilder(injector: injector)
        coordinator = builder?.coordinator
        guard let coordinator else { return false }
        return coordinator.start()
    }

}
