import UIKit

final class OnboardingPageViewController: UIPageViewController {
    private lazy var controllers: [OnboardingViewController] = {
        let firstOnboardingVC = OnboardingViewController()
        firstOnboardingVC.setupFirstSecondScreens(image: Resourses.Images.Onboarding.firstScreen,
                                                  page: 0,
                                                  titleText: LocalizableConstants.Onboarding.firstTitle,
                                                  descriptionText: LocalizableConstants.Onboarding.firstDescription)
        let secondOnboardingVC = OnboardingViewController()
        secondOnboardingVC.setupFirstSecondScreens(image: Resourses.Images.Onboarding.secondScreen,
                                                   page: 1,
                                                   titleText: LocalizableConstants.Onboarding.secondTitle,
                                                   descriptionText: LocalizableConstants.Onboarding.secondDescription)
        let thirdOnboardingVC = OnboardingViewController()
        thirdOnboardingVC.setupThirdScreen(page: 2)
        return [firstOnboardingVC, secondOnboardingVC, thirdOnboardingVC]
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        dataSource = self
        delegate = self
        if let first = controllers.first { setViewControllers([first],
                                                             direction: .forward,
                                                             animated: true,
                                                             completion: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingViewController,
              let viewControllerIndex = controllers.firstIndex(of: vc) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        return controllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingViewController,
              let viewControllerIndex = controllers.firstIndex(of: vc) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < controllers.count else { return nil }
        
        return controllers[nextIndex]
    }
    
    
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
}
