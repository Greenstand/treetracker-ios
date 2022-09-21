//
//  TreetrackerSDK.swift
//  Treetracker-Core
//
//  Created by Alex Cornforth on 16/09/2021.
//

import Foundation

public class TreetrackerSDK: NSObject {

    // Config
    private let configuration: Configuration

    // Networking
    private lazy var awsService: AWSS3Client = {
        return AWSS3Client(
            configuration: self.configuration.awsConfiguration
        )
    }()

    private var imageUploadService: ImageUploadService {
        return AWSS3ImageUploadService(s3Client: self.awsService)
    }

    private var bundleUploadService: BundleUploadService {
        return AWSS3BundleUploadService(s3Client: self.awsService)
    }

    private var treeUploadService: TreeUploadService {
        return LocalTreeUploadService(
            coreDataManager: self.coreDataManager,
            bundleUploadService: self.bundleUploadService,
            imageUploadService: self.imageUploadService,
            documentManager: self.documentManager
        )
    }

    private var planterUploadService: LocalPlanterUploadService {
        return LocalPlanterUploadService(
            coreDataManager: self.coreDataManager,
            imageUploadService: self.imageUploadService,
            bundleUploadService: self.bundleUploadService,
            documentManager: self.documentManager
        )
    }

    private var locationDataUploadService: LocationDataUploadService {
        return LocalLocationDataUploadService(
            coreDataManager: self.coreDataManager,
            bundleUploadService: self.bundleUploadService
        )
    }

    public lazy var uploadManager: UploadManaging = {
        return UploadManager(
            treeUploadService: self.treeUploadService,
            planterUploadService: self.planterUploadService,
            locationDataUploadService: self.locationDataUploadService
        )
    }()

    // Persistence
    private lazy var coreDataManager: CoreDataManaging = {
        return CoreDataManager()
    }()

    private var documentManager: DocumentManaging {
        return DocumentManager()
    }

    // Public Services
    public var treeService: TreeService {
        return LocalTreeService(
            coreDataManager: self.coreDataManager,
            documentManager: self.documentManager
        )
    }

    public var treeMonitoringService: TreeMonitoringService {
        return LocalTreeMonitoringService(
            coreDataManager: self.coreDataManager
        )
    }

    public var locationDataService: LocationDataService {
        return LocalLocationDataService(
            coreDataManager: self.coreDataManager
        )
    }

    public var currentPlanterService: CurrentPlanterService {
        return LocalCurrentPlanterService(
            coreDataManager: self.coreDataManager
        )
    }

    public var loginService: LoginService {
        return LocalLoginService(
            coreDataManager: self.coreDataManager
        )
    }

    public var signUpService: SignUpService {
        return LocalSignUpService(
            coreDataManager: self.coreDataManager
        )
    }

    public var termsService: TermsService {
        return LocalTermsService(
            coreDataManager: self.coreDataManager,
            terms: self.configuration.terms
        )
    }

    public var selfieService: SelfieService {
        return LocalSelfieService(
            coreDataManager: self.coreDataManager,
            documentManager: self.documentManager
        )
    }
    public var locationService: LocationProvider {
        return LocationService()
    }

    public var locationDataCapturer: LocationDataCapturing {
        return LocationDataCapturer(
            locationDataService: self.locationDataService
        )
    }

    public var settingsService: SettingsService {
        return UserDefaultsSettingsService(configuration: configuration)
    }

    public var userDeletionService: UserDeletionService {
        return LocalUserDeletionService(coreDataManager: self.coreDataManager)
    }

    // Initializers
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

// MARK: AppDelegate Functions
public extension TreetrackerSDK {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.awsService.registerS3CLient()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.coreDataManager.saveContext()
    }
}

// MARK: SceneDelegate Functions
@available(iOS 13.0, *)
public extension TreetrackerSDK {

    func sceneDidEnterBackground(_ scene: UIScene) {
        self.coreDataManager.saveContext()
    }
}

public extension TreetrackerSDK {

    struct Configuration {

        public struct DefaultTreeImageQuality {

            let size: Double
            let compression: Double

            public init (size: Double, compression: Double) {
                self.size = size
                self.compression = compression
            }
        }

        let awsConfiguration: AWSConfiguration
        let terms: URL
        let defaultTreeImageQuality: DefaultTreeImageQuality

        public init(
            awsConfiguration: AWSConfiguration,
            terms: URL,
            defaultTreeImageQuality: DefaultTreeImageQuality
        ) {
            self.awsConfiguration = awsConfiguration
            self.terms = terms
            self.defaultTreeImageQuality = defaultTreeImageQuality
        }
    }
}
