# GetYourGuideTask
GetYourGuideTask is an iOS application built as take-home assessment at GetYourGuide. Built Using [MVVM](https://en.wikipedia.org/wiki/Model–view–viewmodel) and [Clean Architecture concepts](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

### Run Requirements

* Xcode 10
* Swift 4.2

### Installation

Dependencies in this project are provided via Cocoapods. Please install all dependecies with

`
pod install
`

### High Level Layers

* **Domain Layer** = Entities + Use Cases + Repositories Interfaces
* **Data Repositories Layer** = Repositories Implementations + API (Network) + Persistence DB
* **Presentation Layer (MVVM)** = ViewModels + Views

## Architecture concepts used here
* Clean Architecture https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
* Advanced iOS App Architecture https://www.raywenderlich.com/8477-introducing-advanced-ios-app-architecture
* [MVVM](https://en.wikipedia.org/wiki/Model–view–viewmodel)
* Data Binding using [Observable](ExampleMVVM/Presentation/Utils/Observable.swift) without 3rd party libraries 
* [Dependency Injection](ExampleMVVM/Application/DIContainer/AppDIContainer.swift)
* [Flow Coordinator](https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps)
* I implemented new approach for initialize input/output interfaces for ViewModel to be more abstracted and decoupled you can check ReviewsListViewModel.swift [ViewModel Inputs/Outputs: a modern approach to MVVM architecture](https://engineering.mercari.com/en/blog/entry/2019-06-12-120000/)
* Here I just set image directly to UIImageView in UITableViewCell which trigger a network call and this maybe considered as a breach of MVVM & clean architecture rules and can be improved by decouple this code from here into seperated repository that handling heavy-lifting image downloading logic and just return imageData to be assigned directly to UIImageView.
```
func fill(with viewModel: ReviewsListItemViewModel) {
        authorImage.kf.indicatorType = .activity
        authorImage.makeRounded()
        authorImage.kf.indicator?.startAnimatingView()
        authorImage.kf.setImage(with: viewModel.authorImageUrl,
                                placeholder: UIImage(systemName: "person.crop.circle"),
                                options: nil, progressBlock: nil) { [weak self] _ in
            guard let self = self else { return }
            self.authorImage.kf.indicator?.stopAnimatingView()
        }
    }
```

## Includes

* Unit Tests for Use Cases(Domain Layer), ViewModels(Presentation Layer), NetworkService(Infrastructure Layer)
* Size Classes and UIStackView in Detail view
* Pagination

## Optimisations/Additions

  Optimisations  | Why I didn't prioritise it.
  ------------- | ----------------------------
  Support offline mode by caching Reviews pages return from API using Core Data.  | Excellent optimization but lower priority relative to other requirements.
  Using RxSwift as binding machanism  |  While RxSwift is perfect compatibility with MVVM I prefered to use simple combination of Closure and didSet to avoid third-party dependencies especially for the scale of this assessement whoever I am used to implement MVVM with RxSwift.
  [Modularity](https://tech.olx.com/modular-architecture-in-ios-c1a1e3bff8e9)  |  Modularity is high priority especially for large scale projects but it's hard to be implemented from the beginning when the big picture isn't fully completed, for more details about modular architecture watch this https://www.youtube.com/watch?v=QzM3lsFewN4
  Add Sorting feature |  Optional requirement and no time to implement.
  Add custom transition animations   | Lower priority relative to other requirements.
  Improve UI design   | Lower priority relative to other requirements.

## Tools

* [Kingfisher](https://github.com/onevcat/Kingfisher) powerful, pure-Swift library for downloading and caching images from the web.
* [SwiftLint](https://github.com/realm/SwiftLint) tool to enforce Swift style and conventions.
* [Cosmos](https://github.com/evgenyneu/Cosmos) tool for shows a star rating and takes rating input from the user.
