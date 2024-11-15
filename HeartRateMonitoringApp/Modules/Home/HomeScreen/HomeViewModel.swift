//
//  HomeViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 13/05/2024.
//

import Foundation
import Combine

enum HomePublisherCases {
    case didLoginSuccessfully(String)
    case loginFailed
    case teacherLoginFailed
    case teacherLoginSuccessful(Teacher)
}

class HomeViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<HomePublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    var username: String?
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bind()
    }
    
    func bind() {
        bindNetworkResponse()
    }
    
    func attemptLogin(username: String, password: String) {
        self.username = username
        networkManager.performRequest(apiPath: .login(UserLogin(username: username, password: password)))
    }
    
    func attemptTeacherLogin(name: String, password: String) {
        networkManager.performRequest(apiPath: .loginTeacher(Teacher(name: name,
                                                                     password: password)))
    }
    
    func getCountryImage() -> String {
        switch getCurrentLanguage() {
        case "en":
            return languageSelectorViewIcons.englishIcon
        case "pt-PT":
            return languageSelectorViewIcons.portugueseIcon
        default:
            return "globeIcon"
        }
    }
    
    func getLanguageId() -> String {
        switch getCurrentLanguage() {
        case "en":
            return "EN"
        case "pt-PT":
            return "PT"
        default:
            return "EN"
        }
    }
    
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else {
                self?.publisher.send(.loginFailed)
                return
            }
            switch response {
            case .didLogin:
                guard let username = self.username else {
                    self.publisher.send(.loginFailed)
                    return
                }
                publisher.send(.didLoginSuccessfully(username))
            case .loadTeacherData(let teacher):
                guard let teacher = teacher else {
                    publisher.send(.teacherLoginFailed)
                    return
                }
                publisher.send(.teacherLoginSuccessful(teacher))
            default:
                publisher.send(.loginFailed)
            }
        }.store(in: &subscriptions)
    }
}
