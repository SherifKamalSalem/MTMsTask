# GetYourGuideTask
GetYourGuideTask is an iOS application built as take-home assessment at GetYourGuide. Built Using [MVVM (Model-View-ViewModel] (https://en.wikipedia.org/wiki/Model–view–viewmodel) and Clean Architecture concepts

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

## Includes

* Unit Tests for Use Cases(Domain Layer), ViewModels(Presentation Layer), NetworkService(Infrastructure Layer)
* UI test with XCUITests
* Size Classes and UIStackView in Detail view
* Pagination

## Tools

* [Kingfisher](https://github.com/onevcat/Kingfisher)
* [SwiftLint](https://github.com/realm/SwiftLint)
