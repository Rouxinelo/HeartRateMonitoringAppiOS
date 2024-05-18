//
//  Strings.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/03/2024.
//

import Foundation

public struct HomeScreenStrings {
    static let titleString: String = "home_screen_title"
    static let loginString: String = "home_screen_login"
    static let registerString: String = "home_screen_register"
    static let guestString: String = "home_screen_guest"
    static let languageString: String = "home_screen_language"
    static let guestAlertTitle: String = "home_screen_alertTitle"
    static let guestAlertDescription: String = "home_screen_alertDescription"
    static let guestAlertContinue: String = "home_screen_continue"
    static let guestAlertCancel: String = "home_screen_cancel"
    static let loginLoadingTitle: String = "home_screen_loadingTitle"
    static let loginLoadingDescription: String = "home_screen_loadingDescription"
    static let loginFailedTitle: String = "home_screen_loginFailedTitle"
    static let loginFailedDescription: String = "home_screen_loginFailedDescription"
    static let registeredToastMessage: String = "home_screen_toastMessage"
}

public struct MainMenuStrings {
    static let sectionsTitle: String = "main_menu_sectionTitle"
    static let classesSectionTitle: String = "main_menu_classesTitle"
    static let classesSectionDescription: String = "main_menu_classesDescription"
    static let calendarSectionTitle: String = "main_menu_calendarTitle"
    static let calendarSectionDescription: String = "main_menu_calendarDescription"
    static let userInfoSectionTitle: String = "main_menu_userInfoTitle"
    static let userInfoSectionDescription: String = "main_menu_userInfoDescription"
    static let logoutSectionsTitle: String = "main_menu_logoutTitle"
    static let leaveSectionsTitle: String = "main_menu_logoutTitle"
    static let logoutSectionCancel: String = "main_menu_logoutAlertCancel"
    static let logoutSectionOk: String = "main_menu_logoutAlertOk"
    static let logoutSectionDescription: String = "main_menu_logoutSectionDescription"
    static let loadingViewTitle: String = "main_menu_ladingAlertTitle"
    static let loadingViewDescription: String = "main_menu_loadingDescription"
    static let welcomeStringGuest: String = "main_menu_welcomeGuest"
    static let welcomeStringUser: String = "main_menu_welcomeUser"
    static let logoutAlertTitle: String = "main_menu_logoutAlertTitle"
    static let logoutAlertDescription: String = ""
    static let userDataLoadingTitle: String = "main_menu_userDataLoadingTitle"
    static let userDataLoadingDescription: String = "main_menu_userDataLoadingDescription"
    static let networkErrorToast: String = "main_menu_networkToastMessage"
}

public struct LoginViewStrings {
    static let loginString: String = "login_view_title"
    static let usernameString: String = "login_view_username"
    static let passwordString: String = "login_view_password"
}

public struct LanguageSelectorViewStrings {
    static let titleString: String = "language_selector_title"
    static let portugueseString: String = "pt-PT"
    static let englishString: String = "en"
    static let confirmString: String = "language_selector_confirm"
}

public struct RegisterUserStrings {
    static let titleString: String = "register_user_title"
    static let usernameString: String = "register_user_username"
    static let usernameDescription: String = "register_user_usernameDescription"
    static let firstNameString: String = "register_user_firstName"
    static let firstNameDescription: String = "register_user_firstNameDescription"
    static let lastNameString: String = "register_user_lastName"
    static let lastNameDescription: String = "register_user_lastNameDescription"
    static let emailString: String = "register_user_email"
    static let emailDescription: String = "register_user_emailDescription"
    static let passwordString: String = "register_user_password"
    static let passwordDescription: String = "register_user_passwordDescription"
    static let dateTitleString: String = "register_user_dobTitle"
    static let dayString: String = "register_user_day"
    static let monthString: String = "register_user_month"
    static let yearString: String = "register_user_year"
    static let genderString: String = "register_user_gender"
    static let genderDescription: String = "register_user_genderDescription"
    static let registerButton: String = "register_user_registerButton"
    static let loadingViewTitle: String = "register_user_loadingTitle"
    static let loadingViewDescription: String = "register_user_loadingDescription"
    static let alertTitleString: String = "register_user_alertTitle"
    static let emailRegisteredString: String = "register_user_emailAlertDescription"
    static let userRegisteredString: String = "register_user_userAlertDescription"
    static let alertOkString: String = "register_user_okAlert"
}

public struct CalendarStrings {
    static let titleString: String = "calendar_title"
    static let textFieldPlaceholder: String = "calendar_textPlaceholder"
    static let sessionsCount: String = "calendar_foundSessions"
    static let toastMessage: String = "calendar_toastMessage"
    static let alertTitle: String = "calendar_alertTitle"
    static let alertLeftButton: String = "calendar_alertLeftButton"
    static let alertDescription: String = "calendar_alertDescription"
}

public struct SessionDetailStrings {
    static let titleString: String = "session_detail_title"
    static let sessionDescriptionString: String = "session_detail_description"
    static let noDescriptionString: String = "session_detail_descriptionUnavailable"
    static let signInButtonGuest: String = "session_detail_buttonGuest"
    static let signInButtonFull: String = "session_detail_buttonFull"
    static let signInButton: String = "session_detail_button"
    static let loadingTitle: String = "session_detail_loadingTitle"
    static let loadingDescription: String = "session_detail_loadingDescription"
    static let toastMessage: String = "session_detail_toastMessage"
}

public struct UserDetailTypeStrings {
    static let titleString: String = "user_detail_title"
    static let nameString: String = "user_detail_name"
    static let emailString: String = "user_detail_email"
    static let genderString: String = "user_detail_gender"
    static let ageString: String = "user_detail_age"
}

public struct UserSessionsStrings {
    static let titleString: String = "user_sessions_title"
    static let readyToJoinTitleString: String = "user_sessions_readyTitle"
    static let readyToJoinDescriptionString: String = "user_sessions_readyDescription"
    static let signedSessionsTitleString: String = "user_sessions_signedTitle"
    static let signedSessionsDescriptionString: String = "user_sessions_signedDescription"
    static let previousSessionsTitleString: String = "user_sessions_previousTitle"
    static let previousSessionsDescriptionString: String = "user_sessions_previousDescription"
    static let signedModalString: String = "user_sessions_signedModal"
    static let joinableModalString: String = "user_sessions_joinableModal"
    static let previousModalString: String = "user_sessions_previousModal"
    static let signedToastString: String = "user_sessions_signedToast"
}

public struct UserSessionsModalStrings {
    static let leftButtonString: String = "user_sessions_modal_leftButton"
    static let rightButtonString: String = "user_sessions_modal_rightButton"
    static let foundSingleSessionString: String = "user_sessions_modal_single"
    static let foundMultipleSessionString: String = "user_sessions_modal_multiple"
}

public struct PreviousSessionStrings {
    static let titleString: String = "previous_sessions_title"
    static let closeButtonString: String = "previous_sessions_close"
    static let heartRateDataString: String = "previous_sessions_hrData"
    static let countSectionTitleString: String = "previous_sessions_countTitle"
    static let countSectionDescriptionString: String = "previous_sessions_countDescription"
    static let averageSectionTitleString: String = "previous_sessions_averageTitle"
    static let bpmString: String = "previous_sessions_bpm"
    static let maxSectionTitleString: String = "previous_sessions_maxTitle"
    static let minSectionTitleString: String = "previous_sessions_minTitle"
    static let actionString: String = "previous_sessions_actions"
    static let saveString: String = "previous_sessions_save"
    static let shareString: String = "previous_sessions_share"
    static let toastErrorString: String = "previous_sessions_toastError"
    static let toastSuccessString: String = "previous_sessions_toastSuccess"
}

public struct SessionShareabaleStrings {
    static let titleString: String = "session_shareable_title"
}

public struct JoinSessionStrings {
    static let titleString: String = "join_session_title"
    static let detailsString: String = "join_session_details"
    static let noDescriptionString: String = "join_session_noDescription"
    static let joinButtonString: String = "join_session_joinButton"
    static let connectSensorString: String = "join_session_connectSensor"
    static let modalTitleString: String = "join_session_modalTitle"
}

public struct SessionStrings {
    static let timeString: String = "session_time"
    static let heartRateInfoString: String = "session_hrInfo"
    static let closeString: String = "session_close"
    static let currentHeartRateString: String = "session_currentHeartRate"
    static let bpmString: String = "session_bpm"
    static let minString: String = "session_min"
    static let maxString: String = "session_max"
    static let averageString: String = "session_average"
    static let closeAlertTitleString: String = "session_alertTitle"
    static let closeAlertDescriptionString: String = "session_alertDescription"
    static let closeAlertLeftButtonString: String = "session_alertLeftButton"
    static let closeAlertRightButtonString: String = "session_alertRightButton"
}

public struct SessionSummaryStrings {
    static let titleString: String = "session_summary_title"
    static let closeString: String = "session_summary_close"
    static let detailsString: String = "session_summary_details"
    static let sessionTimeString: String = "session_summary_time"
    static let heartRateDataString: String = "session_summary_heartRateData"
    static let countTitleString: String = "session_summary_countTitle"
    static let countDescriptionString: String = "session_summary_countDescription"
    static let averageString: String = "session_summary_average"
    static let maxString: String = "session_summary_max"
    static let minString: String = "session_summary_min"
    static let bpmString: String = "session_summary_bpm"
    static let alertTitleString: String = "session_summary_alertTitle"
    static let alertDescriptionString: String = "session_summary_alertDescription"
    static let alertLeftButtonString: String = "session_summary_alertLeftButton"
    static let alertRightButtonString: String = "session_summary_alertRightButton"
}

public struct ScreenIds {
    static let registerScreenID: String = "registerScreen"
}
