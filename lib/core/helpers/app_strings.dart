import 'package:easy_localization/easy_localization.dart';

abstract class AppStrings {
  AppStrings._();

  static String get pageViewItem1Title => 'page_view_item1_title'.tr();
  static String get pageViewItem2Title => 'page_view_item2_title'.tr();
  static String get pageViewItem1Description =>
      'page_view_item1_description_dashboard'.tr();
  static String get pageViewItem2Description =>
      'page_view_item2_description_dashboard'.tr();
  static String get skip => 'skip'.tr();
  static String get startNow => 'start_now'.tr();
  static String get login => 'login'.tr();
  static String get register => 'register'.tr();
  static String get email => 'email'.tr();
  static String get password => 'password'.tr();
  static String get forgotPassword => 'forgot_password'.tr();
  static String get dontHaveAccount => "don't_have_account".tr();
  static String get createAnAccount => 'create_an_account'.tr();
  static String get or => 'or'.tr();
  static String get signInWithGoogle => 'sign_in_with_google'.tr();
  static String get signInWithApple => 'sign_in_with_apple'.tr();
  static String get signInWithFacebook => 'sign_in_with_facebook'.tr();
  static String get newAccount => 'new_account'.tr();
  static String get fullName => 'full_name'.tr();
  static String get termsAndConditionsP1 => 'terms_and_conditions_p1'.tr();
  static String get termsAndConditionsP2 => 'terms_and_conditions_p2'.tr();
  static String get createNewAccount => 'create_new_account'.tr();
  static String get alreadyHaveAnAccount => 'already_have_an_account'.tr();
  static String get emailCannotBeEmpty => 'email_cannot_be_empty'.tr();
  static String get enterAValidEmailAddress =>
      'enter_a_valid_email_address'.tr();
  static String get passwordCannotBeEmpty => 'password_cannot_be_empty'.tr();
  static String get passwordMustContainOnlyLettersAndNumbers =>
      'password_must_contain_only_letters_and_numbers'.tr();
  static String get passwordMustBeAtLeast6CharactersLong =>
      'password_must_be_at_least6_characters_long'.tr();
  static String get passwordMustContainAtLeastOneNumber =>
      'password_must_contain_at_least_one_number'.tr();
  static String get nameCannotBeEmpty => 'name_cannot_be_empty'.tr();
  static String get emailCreated => 'email_created'.tr();
  static String get youShouldAcceptTermsAndConditions =>
      'you_should_accept_terms_and_conditions'.tr();
  static String get emailSentToVerify => 'email_sent_to_verify'.tr();
  static String get ok => 'ok'.tr();
  static String get welcome => 'welcome'.tr();
  static String get pleaseVerifyYourEmail => 'please_verify_your_email'.tr();
  static String get userCanceledSignIn => 'user_canceled_sign_in'.tr();
  static String get sendEmailResetLink => 'send_email_reset_link'.tr();
  static String get passwordReset => 'password_reset'.tr();
  static String get sendPasswordResetLink => 'send_password_reset_link'.tr();
  static String get tryAgainLater => 'try_again_later'.tr();
  static String get emailSent => 'email_sent'.tr();
  static String get emailSentToReset => 'email_sent_to_reset'.tr();
  static String get invalidEmail => 'invalid_email'.tr();
  static String get wrongPasswordProvidedForThatUser =>
      'wrong_password_provided_for_that_user'.tr();
  static String get noUserFoundForThatEmail =>
      'no_user_found_for_that_email'.tr();
  static String get userDisabled => 'user_disabled'.tr();
  static String get tooManyRequests => 'too_many_requests'.tr();
  static String get operationNotAllowed => 'operation_not_allowed'.tr();
  static String get invalidEmailOrPassword => 'invalid_email_or_password'.tr();
  static String get networkErrorMessage => 'network_error_message'.tr();
  static String get thePasswordProvidedIsTooWeak =>
      'the_password_provided_is_too_weak'.tr();
  static String get theAccountAlreadyExistsForThatEmail =>
      'the_account_already_exists_for_that_email'.tr();
  static String get internalError => 'internal_error'.tr();
  static String get appNotAuthorized => 'app_not_authorized'.tr();
  static String get userTokenExpired => 'user_token_expired'.tr();
  static String get requiresRecentLogin => 'requires_recent_login'.tr();
  static String get userMismatch => 'user_mismatch'.tr();
  static String get quotaExceeded => 'quota_exceeded'.tr();
  static String get errorOccurredPleaseTryAgain =>
      'error_occurred_please_try_again'.tr();
  static String get permissionDenied => 'permission-denied'.tr();
  static String get goodMorning => 'good_morning'.tr();
  static String get searchFor => 'search_for'.tr();
  static String get eidOffers => 'eid_offers'.tr();
  static String get discount => 'discount'.tr();
  static String get shopNow => 'shop_now'.tr();
  static String get bestSeller => 'best_seller'.tr();
  static String get more => 'more'.tr();
  static String get pounds => 'pounds'.tr();
  static String get kilo => 'kilo'.tr();
  static String get perKilo => 'per_kilo'.tr();
  static String get home => 'home'.tr();
  static String get products => 'products'.tr();
  static String get shoppingCart => 'shopping_cart'.tr();
  static String get myAccount => 'my_account'.tr();
  static String get search => 'search'.tr();
  static String get noResults => 'no_results'.tr();
  static String get searchResults => 'search_results'.tr();
  static String get language => 'language'.tr();
  static String get appLanguage => 'app_language'.tr();
  static String get signOut => 'sign_out'.tr();
  static String get ourProducts => 'our_products'.tr();
  static String get cartAppBar => 'cart_app_bar'.tr();
  static String get youHave => 'you_have'.tr();
  static String get productsInTheShoppingCart =>
      'products_in_the_shopping_cart'.tr();
  static String get checkout => 'checkout'.tr();
  static String get userNotLoggedIn => 'user_not_logged_in'.tr();
  static String get selectLanguage => 'select_language'.tr();
  static String get languageChangedSuccessfully =>
      'language_changed_successfully'.tr();
  static String get cancel => 'cancel'.tr();
  static String get confirmLanguageChange => 'confirm_language_change'.tr();
  static String get appWillRestart => 'app_will_restart'.tr();
  static String get favorites => 'favorites'.tr();
  static String get general => 'general'.tr();
  static String get itemAddedToCart => 'item_added_to_cart'.tr();
  static String get itemRemovedFromCart => 'item_removed_from_cart'.tr();
  static String get loading => 'loading'.tr();
  static String get logOutConfirmation => 'log_out_confirmation'.tr();
  static String get loggedOutSuccessfully => 'logged_out_successfully'.tr();
  static String get sortBy => 'sort_by'.tr();
  static String get priceLowestToHighest => 'price_lowest_to_highest'.tr();
  static String get priceHighestToLowest => 'price_highest_to_lowest'.tr();
  static String get alphabetical => 'alphabetical'.tr();
  static String get apply => 'apply'.tr();
  static String get reset => 'reset'.tr();
  static String get addToCart => 'add_to_cart'.tr();
  static String get validity => 'validity'.tr();
  static String get days => 'days'.tr();
  static String get organic => 'organic'.tr();
  static String get calories => 'calories'.tr();
  static String get gram => 'gram'.tr();
  static String get reviews => 'reviews'.tr();
  static String get review => 'review'.tr();
  static String get shipping => 'shipping'.tr();
  static String get address => 'address'.tr();
  static String get payment => 'payment'.tr();
  static String get confirmAndContinue => 'confirm_and_continue'.tr();
  static String get confirmOrder => 'confirm_order'.tr();
  static String get next => 'next'.tr();
  static String get cashOnDelivery => 'cash_on_delivery'.tr();
  static String get deliveryFromPlace => 'delivery_from_place'.tr();
  static String get onlinePayment => 'online_payment'.tr();
  static String get payByCreditCard => 'pay_by_credit_card'.tr();
  static String get freeShipping => 'free_shipping'.tr();
  static String get free => 'free'.tr();
  static String get phoneNumber => 'phone_number'.tr();
  static String get streetNameCannotBeEmpty =>
      'street_name_cannot_be_empty'.tr();
  static String get city => 'city'.tr();
  static String get saveAddress => 'save_address'.tr();
  static String get floorNumber => 'floor_number'.tr();
  static String get apartmentNumber => 'apartment_number'.tr();
  static String get phoneNumberCannotBeEmpty =>
      'phone_number_cannot_be_empty'.tr();
  static String get enterAValidPhoneNumber => 'enter_a_valid_phone_number'.tr();
  static String get cityCannotBeEmpty => 'city_cannot_be_empty'.tr();
  static String get floorNumberCannotBeEmpty =>
      'floor_number_cannot_be_empty'.tr();
  static String get apartmentNumberCannotBeEmpty =>
      'apartment_number_cannot_be_empty'.tr();
  static String get buildingNumberCannotBeEmpty =>
      'building_number_cannot_be_empty'.tr();
  static String get payByPaypal => 'pay_by_paypal'.tr();
  static String get chooseThePaymentMethodThatSuitsYouBest =>
      'choose_the_payment_method_that_suits_you_best'.tr();
  static String get orderSummary => 'order_summary'.tr();
  static String get delivery => 'delivery'.tr();
  static String get subtotal => 'subtotal'.tr();
  static String get total => 'total'.tr();
  static String get pleaseConfirmYourOrder => 'please_confirm_your_order'.tr();
  static String get paymentMethod => 'payment_method'.tr();
  static String get deliveryAddress => 'delivery_address'.tr();
  static String get edit => 'edit'.tr();
  static String get itMustBeANumber => 'it_must_be_a_number'.tr();
  static String get streetName => 'street_name'.tr();
  static String get buildingNumber => 'building_number'.tr();
  static String get building => 'building'.tr();
  static String get floor => 'floor'.tr();
  static String get apartment => 'apartment'.tr();
  static String get pleaseSelectAPaymentMethod =>
      'please_select_a_payment_method'.tr();
  static String get orderPlacedSuccessfully => 'order_placed_successfully'.tr();
  static String get orderCancelled => 'order_cancelled'.tr();
  static String get contactUsForAnyQuestionsOnYourOrder =>
      'contact_us_for_any_questions_on_your_order'.tr();
  static String get trackOrder => 'track_order'.tr();
  static String get itWasDoneSuccessfully => 'It_was_done_successfully!'.tr();
  static String get orderNumber => 'order_number'.tr();
  static String get system => 'system'.tr();
  static String get light => 'light'.tr();
  static String get dark => 'dark'.tr();
  static String get optional => 'optional'.tr();
  static String get noInternetConnection => 'noInternetConnection'.tr();
  static String get unexpectedError => 'unexpectedError'.tr();
  static String get unauthorizedError => 'unauthorized_error'.tr();
  static String get notFoundError => 'notFoundError'.tr();
  static String get serverError => 'server_error'.tr();
  static String get somethingWentWrong => 'something_went_wrong'.tr();
  static String get userNotFound => 'userNotFound'.tr();
  static String get wrongPassword => 'wrong_password'.tr();
  static String get invalidCredential => 'invalidCredential'.tr();
  static String get emailAlreadyInUse => 'emailAlreadyInUse'.tr();
  static String get accountExistsWithDifferentCredential =>
      'account_exists_with_different_credential'.tr();
  static String get invalidEmail2 => 'invalid_email'.tr();
  static String get tooManyRequests2 => 'too_many_requests'.tr();
  static String get permissionDenied2 => 'permission_denied'.tr();
  static String get userDisabled2 => 'user_disabled'.tr();
  static String get operationNotAllowed2 => 'operation_not_allowed'.tr();
  static String get cacheError => 'cache_error'.tr();
  static String get googleSignInCancelled => 'googleSignInCancelled'.tr();
  static String get emailCannotBeEmpty2 => 'email_cannot_be_empty'.tr();
  static String get enterAValidEmailAddress2 =>
      'enter_a_valid_email_address'.tr();
  static String get requiredField => 'requiredField'.tr();
  static String get passwordCannotBeEmpty2 => 'password_cannot_be_empty'.tr();
  static String get passwordMustBeAtLeast8CharactersLong =>
      'password_must_be_at_least8_characters_long'.tr();
  static String get passwordMustContainUppercase =>
      'password_must_contain_uppercase'.tr();
  static String get passwordMustContainLowercase =>
      'password_must_contain_lowercase'.tr();
  static String get passwordMustContainNumber =>
      'password_must_contain_number'.tr();
  static String get passwordMustContainSpecialCharacter =>
      'password_must_contain_special_character'.tr();
  static String get confirmPasswordMustMatchThePassword =>
      'passwords_do_not_match'.tr();
  static String get nameCannotBeEmpty2 => 'name_cannot_be_empty'.tr();
  static String get profilePictureIsRequired => 'profilePictureIsRequired'.tr();
  static String get idCardImageIsRequired => 'idCardImageIsRequired'.tr();
  static String get usernameCannotBeEmpty => 'usernameCannotBeEmpty'.tr();
  static String get streetNameCannotBeEmpty2 =>
      'street_name_cannot_be_empty'.tr();
  static String get cityCannotBeEmpty2 => 'city_cannot_be_empty'.tr();
  static String get buildingNumberCannotBeEmpty2 =>
      'building_number_cannot_be_empty'.tr();
  static String get itMustBeANumber2 => 'it_must_be_a_number'.tr();
  static String get pleaseEnterDescription => 'pleaseEnterDescription'.tr();
  static String get pleaseSelectLocation => 'pleaseSelectLocation'.tr();
  static String get pleaseSelectDate => 'pleaseSelectDate'.tr();
  static String get pleaseSelectTime => 'pleaseSelectTime'.tr();
  static String get yearsOfExperienceCannotBeEmpty =>
      'years_of_experience_cannot_be_empty'.tr();
  static String get phoneNumberCannotBeEmpty2 =>
      'phone_number_cannot_be_empty'.tr();
  static String get enterAValidPhoneNumber2 =>
      'enter_a_valid_phone_number'.tr();
  static String get codeCannotBeEmpty => 'codeCannotBeEmpty'.tr();
  static String get codeShouldBeAtLeast6Digits =>
      'code_should_be_at_least6_digits'.tr();
  static String get nationalIdCannotBeEmpty => 'nationalIdCannotBeEmpty'.tr();
  static String get nationalIdMustBe14Digits => 'nationalIdMustBe14Digits'.tr();
  static String get onboardingSkip => 'skip'.tr();
  static String get getStarted => 'get_started'.tr();
  static String get onboardingTitle1 => 'onboarding_title_1'.tr();
  static String get onboardingDescription1 => 'onboarding_description_1'.tr();
  static String get onboardingTitle2 => 'onboarding_title_2'.tr();
  static String get onboardingDescription2 => 'onboarding_description_2'.tr();
  static String get onboardingTitle3 => 'onboarding_title_3'.tr();
  static String get onboardingDescription3 => 'onboarding_description_3'.tr();
  static String get appTagline => 'app_tagline'.tr();
  static String get forgotPassword2 => 'forgot_password'.tr();
  static String get dontHaveAccount2 => 'don\'t_have_account'.tr();
  static String get createAnAccount2 => 'create_an_account'.tr();
  static String get signInWithGoogle2 => 'sign_in_with_google'.tr();
  static String get newAccount2 => 'new_account'.tr();
  static String get fullName2 => 'full_name'.tr();
  static String get alreadyHaveAnAccount2 => 'already_have_an_account'.tr();
  static String get passwordReset2 => 'password_reset'.tr();
  static String get sendEmailResetLink2 => 'send_email_reset_link'.tr();
  static String get sendPasswordResetLink2 => 'send_password_reset_link'.tr();
  static String get send => 'send'.tr();
  static String get sendPasswordResetConfirmation =>
      'send_password_reset_confirmation'.tr();
  static String get emailSent2 => 'email_sent'.tr();
  static String get emailSentToReset2 => 'email_sent_to_reset'.tr();
  static String get emailCreated2 => 'email_created'.tr();
  static String get emailSentToVerify2 => 'email_sent_to_verify'.tr();
  static String get youShouldAcceptTermsAndConditions2 =>
      'you_should_accept_terms_and_conditions'.tr();
  static String get termsAndConditionsP12 => 'terms_and_conditions_p1'.tr();
  static String get termsAndConditionsP22 => 'terms_and_conditions_p2'.tr();
  static String get noUserFoundForThatEmail2 =>
      'no_user_found_for_that_email'.tr();
  static String get pleaseVerifyYourEmail2 => 'please_verify_your_email'.tr();
  static String get invoices => 'invoices'.tr();
  static String get clients => 'clients'.tr();
  static String get settings => 'settings'.tr();
  static String get generalSettings => 'general_settings'.tr();
  static String get localSettings => 'local_settings'.tr();
  static String get profileInformation => 'profile_information'.tr();
  static String get securitySettings => 'security_settings'.tr();
  static String get theme => 'theme'.tr();
  static String get arabic => 'arabic'.tr();
  static String get english => 'english'.tr();
  static String get currency => 'currency'.tr();
  static String get signOut2 => 'sign_out'.tr();
  static String get signOutConfirmation => 'sign_out_confirmation'.tr();
  static String get passwordResetSent => 'password_reset_sent'.tr();
  static String get currencyUpdated => 'currency_updated'.tr();
  static String get usd => 'usd'.tr();
  static String get egp => 'egp'.tr();
  static String get eur => 'eur'.tr();
  static String get sar => 'sar'.tr();
  static String get aed => 'aed'.tr();
  static String get businessNameUpdated => 'business_name_updated'.tr();
  static String get businessName => 'business_name'.tr();
  static String get memberSince => 'member_since'.tr();
  static String get accountStatus => 'account_status'.tr();
  static String get verified => 'verified'.tr();
  static String get unverified => 'unverified'.tr();
  static String get saveChanges => 'save_changes'.tr();
  static String get accountDetails => 'account_details'.tr();
  static String get addClient => 'add_client'.tr();
  static String get editClient => 'edit_client'.tr();
  static String get deleteClient => 'delete_client'.tr();
  static String get deleteClientConfirmation =>
      'delete_client_confirmation'.tr();
  static String get searchClients => 'search_clients'.tr();
  static String get noClientsFound => 'no_clients_found'.tr();
  static String get clientName => 'client_name'.tr();
  static String get clientEmail => 'client_email'.tr();
  static String get clientPhone => 'client_phone'.tr();
  static String get clientAddress => 'client_address'.tr();
  static String get clientInformation => 'client_information'.tr();
  static String get clientAddedSuccessfully => 'client_added_successfully'.tr();
  static String get clientUpdatedSuccessfully =>
      'client_updated_successfully'.tr();
  static String get clientDeletedSuccessfully =>
      'client_deleted_successfully'.tr();
  static String get phone => 'phone'.tr();
  static String get createInvoice => 'create_invoice'.tr();
  static String get invoiceNumber => 'invoice_number'.tr();
  static String get selectClient => 'select_client'.tr();
  static String get pleaseSelectClient => 'please_select_client'.tr();
  static String get issueDate => 'issue_date'.tr();
  static String get dueDate => 'due_date'.tr();
  static String get paidDate => 'paid_date'.tr();
  static String get invoiceItems => 'invoice_items'.tr();
  static String get addItem => 'add_item'.tr();
  static String get itemName => 'item_name'.tr();
  static String get itemDescriptionHint => 'item_description_hint'.tr();
  static String get quantity => 'quantity'.tr();
  static String get unitPrice => 'unit_price'.tr();
  static String get taxRate => 'tax_rate'.tr();
  static String get taxAmount => 'tax_amount'.tr();
  static String get grandTotal => 'grand_total'.tr();
  static String get notes => 'notes'.tr();
  static String get notesHint => 'notes_hint'.tr();
  static String get saveAsDraft => 'save_as_draft'.tr();
  static String get invoiceCreatedSuccessfully =>
      'invoice_created_successfully'.tr();
  static String get pleaseAddAtLeastOneItem =>
      'please_add_at_least_one_item'.tr();
  static String get statusDraft => 'status_draft'.tr();
  static String get statusSent => 'status_sent'.tr();
  static String get statusOpened => 'status_opened'.tr();
  static String get statusPaid => 'status_paid'.tr();
  static String get statusOverdue => 'status_overdue'.tr();
  static String get statusCancelled => 'status_cancelled'.tr();
  static String get all => 'all'.tr();
  static String get noClientsYet => 'no_clients_yet'.tr();
  static String get noClientsAvailable => 'no_clients_available'.tr();
  static String get noInvoicesYet => 'no_invoices_yet'.tr();
  static String get noInvoicesFound => 'no_invoices_found'.tr();
  static String get deleteInvoiceConfirmation =>
      'delete_invoice_confirmation'.tr();
  static String get invoiceDeletedSuccessfully =>
      'invoice_deleted_successfully'.tr();
  static String get selectDate => 'select_date'.tr();
  static String get updateStatus => 'update_status'.tr();
  static String get editInvoice => 'edit_invoice'.tr();
  static String get invoiceDetails => 'invoice_details'.tr();
  static String get invoiceUpdatedSuccessfully =>
      'invoice_updated_successfully'.tr();
  static String get deleteInvoice => 'delete_invoice'.tr();
  static String get dashboard => 'dashboard'.tr();
  static String get monthlyEarnings => 'monthly_earnings'.tr();
  static String get totalOverdue => 'total_overdue'.tr();
  static String get pendingAmount => 'pending_amount'.tr();
  static String get activeClients => 'active_clients'.tr();
  static String get revenueOverview => 'revenue_overview'.tr();
  static String get invoiceBreakdown => 'invoice_breakdown'.tr();
  static String get recentInvoices => 'recent_invoices'.tr();
  static String get viewAll => 'view_all'.tr();
  static String get totalRevenue => 'total_revenue'.tr();
  static String get noAnalyticsData => 'no_analytics_data'.tr();
  static String get sendInvoice => 'send_invoice'.tr();
  static String get invoiceSentSuccessfully => 'invoice_sent_successfully'.tr();
  static String get confirmPaymentTitle => 'confirm_payment_title'.tr();
  static String get confirmPaymentSubtitle => 'confirm_payment_subtitle'.tr();
  static String get confirmPaymentButton => 'confirm_payment_button'.tr();
  static String get markAsPaid => 'mark_as_paid'.tr();
  static String get cannotEditPaidOrCancelled =>
      'cannot_edit_paid_or_cancelled'.tr();
  static String get confirmSendInvoiceSubtitle =>
      'confirm_send_invoice_subtitle'.tr();
  static String get cancelInvoice => 'cancel_invoice'.tr();
  static String get confirmCancelInvoiceSubtitle =>
      'confirm_cancel_invoice_subtitle'.tr();
  static String get welcomeToDashboard => 'welcome_to_dashboard'.tr();
  static String get users => 'users'.tr();
  static String get orders => 'orders'.tr();
  static String get analytics => 'analytics'.tr();
  static String get yes => 'yes'.tr();
  static String get no => 'no'.tr();
  static String get usersSubtitle => 'users_subtitle'.tr();
  static String get productsSubtitle => 'products_subtitle'.tr();
  static String get ordersSubtitle => 'orders_subtitle'.tr();
  static String get analyticsSubtitle => 'analytics_subtitle'.tr();
  static String get settingsSubtitle => 'settings_subtitle'.tr();
  static String get quickActions => 'quick_actions'.tr();
  static String get storeControlPanel => 'store_control_panel'.tr();
  static String get controlPanelSubtitle => 'control_panel_subtitle'.tr();
  static String get admin => 'admin'.tr();
  static String get addProduct => 'add_product'.tr();
  static String get editProduct => 'edit_product'.tr();
  static String get productAdded => 'product_added'.tr();
  static String get productUpdated => 'product_updated'.tr();
  static String get productRemoved => 'product_removed'.tr();
  static String get deleteProduct => 'delete_product'.tr();
  static String get deleteProductConfirmation =>
      'delete_product_confirmation'.tr();
  static String get productName => 'product_name'.tr();
  static String get price => 'price'.tr();
  static String get productDescription => 'product_description'.tr();
  static String get daysUntilExpiration => 'days_until_expiration'.tr();
  static String get productCode => 'product_code'.tr();
  static String get numberOfCalories => 'number_of_calories'.tr();
  static String get weightInGrams => 'weight_in_grams'.tr();
  static String get featured => 'featured'.tr();
  static String get pleaseSelectImage => 'please_select_image'.tr();
  static String get noProductsYet => 'no_products_yet'.tr();
  static String get addFirstProduct => 'add_first_product'.tr();
  static String get add => 'add'.tr();
  static String get productImage => 'product_image'.tr();
  static String get orderNumberPrefix => 'order_number_prefix'.tr();
  static String get unknownUser => 'unknown_user'.tr();
  static String get items => 'items'.tr();
  static String get shippingAddress => 'shipping_address'.tr();
  static String get phoneLabel => 'phone_label'.tr();
  static String get codeLabel => 'code_label'.tr();
  static String get updateOrderStatus => 'update_order_status'.tr();
  static String get printInvoice => 'print_invoice'.tr();
  static String get noOrdersYet => 'no_orders_yet'.tr();
  static String get noOrdersYetSubtitle => 'no_orders_yet_subtitle'.tr();
  static String get orderStatusUpdatedSuccessfully =>
      'order_status_updated_successfully'.tr();
  static String get viewDetails => 'view_details'.tr();
  static String get hideDetails => 'hide_details'.tr();
  static String get creditCard => 'credit_card'.tr();
  static String get paypal => 'paypal'.tr();
  static String get deliveryFees => 'delivery_fees'.tr();
  static String get generalConfiguration => 'general_configuration'.tr();
  static String get freeShippingThreshold => 'free_shipping_threshold'.tr();
  static String get freeShippingThresholdHint =>
      'free_shipping_threshold_hint'.tr();
  static String get freeShippingThresholdHelp =>
      'free_shipping_threshold_help'.tr();
  static String get success => 'success'.tr();
  static String get settingsUpdatedSuccessfully =>
      'settings_updated_successfully'.tr();
  static String get chooseImageSource => 'choose_image_source'.tr();
  static String get camera => 'camera'.tr();
  static String get gallery => 'gallery'.tr();
  static String get searchUsers => 'search_users'.tr();
  static String get totalUsers => 'total_users'.tr();
  static String get verifiedUsers => 'verified_users'.tr();
  static String get activeCarts => 'active_carts'.tr();
  static String get noUsersFound => 'no_users_found'.tr();
  static String get noUsersSubtitle => 'no_users_subtitle'.tr();
  static String get userDetails => 'user_details'.tr();
  static String get notVerified => 'not_verified'.tr();
  static String get lastActive => 'last_active'.tr();
  static String get callUser => 'call_user'.tr();
  static String get whatsAppUser => 'whatsapp_user'.tr();
  static String get sendNotification => 'send_notification'.tr();
  static String get cartItems => 'cart_items'.tr();
  static String get notifications => 'notifications'.tr();
  static String get emptyCart => 'empty_cart'.tr();
  static String get emptyFavorites => 'empty_favorites'.tr();
  static String get emptyNotifications => 'empty_notifications'.tr();
  static String get notificationTitleAr => 'notification_title_ar'.tr();
  static String get notificationTitleEn => 'notification_title_en'.tr();
  static String get notificationBodyAr => 'notification_body_ar'.tr();
  static String get notificationBodyEn => 'notification_body_en'.tr();
  static String get notificationSentSuccessfully =>
      'notification_sent_successfully'.tr();
  static String get allUsers => 'all_users'.tr();
  static String get itemsCount => 'items_count'.tr();
  static String get searchByName => 'search_by_name'.tr();
  static String get searchByEmail => 'search_by_email'.tr();
  static String get searchByPhone => 'search_by_phone'.tr();
  static String get typeToSearchUsers => 'type_to_search_users'.tr();
  static String get noSearchResultsFound => 'no_search_results_found'.tr();

  static String get notifyUsersAboutShippingUpdate =>
      'notify_users_about_shipping_update'.tr();
  static String get notifyUsersAboutShippingUpdateSubtitle =>
      'notify_users_about_shipping_update_subtitle'.tr();
  static String get notificationPreview => 'notification_preview'.tr();
  static String get shippingUpdateTitleAr => 'shipping_update_title_ar'.tr();
  static String get shippingUpdateTitleEn => 'shipping_update_title_en'.tr();

  static String shippingUpdateBodyAr({
    required double cost,
    required double threshold,
  }) => threshold > 0
      ? 'أصبحت مصاريف الشحن الآن ${cost.toInt()} جنيه، وشحن مجاني لجميع الطلبات فوق ${threshold.toInt()} جنيه!'
      : 'أصبحت مصاريف الشحن الآن ${cost.toInt()} جنيه لجميع الطلبات!';

  static String shippingUpdateBodyEn({
    required double cost,
    required double threshold,
  }) => threshold > 0
      ? 'Shipping is now ${cost.toInt()} EGP, with free shipping on orders over ${threshold.toInt()} EGP!'
      : 'Shipping is now ${cost.toInt()} EGP for all orders!';

  // Analytics UI
  static String get last7Days => 'last_7_days'.tr();
  static String get last30Days => 'last_30_days'.tr();
  static String get thisMonth => 'this_month'.tr();
  static String get customRange => 'custom_range'.tr();
  static String get selectDateRange => 'select_date_range'.tr();
  static String get totalOrders => 'total_orders'.tr();
  static String get averageOrderValue => 'average_order_value'.tr();
  static String get activeCustomers => 'active_customers'.tr();
  static String get verifiedRatio => 'verified_ratio'.tr();
  static String get revenueTimeline => 'revenue_timeline'.tr();
  static String get orderStatusDistribution => 'order_status_distribution'.tr();
  static String get paymentMethodsBreakdown => 'payment_methods_breakdown'.tr();
  static String get topSellingProducts => 'top_selling_products'.tr();
  static String get soldUnits => 'sold_units'.tr();
  static String get noRevenueData => 'no_revenue_data'.tr();
  static String get ordersCountLabel => 'orders_count_label'.tr();
  static String get retry => 'retry'.tr();
  static String get dailyAvg => 'daily_avg'.tr();
  static String get salesShare => 'sales_share'.tr();
  static String get refresh => 'refresh'.tr();
  static String get startDate => 'start_date'.tr();
  static String get endDate => 'end_date'.tr();
  static String get statusPending => 'status_pending'.tr();
  static String get statusProcessing => 'status_processing'.tr();
  static String get statusShipped => 'status_shipped'.tr();
  static String get statusDelivered => 'status_delivered'.tr();
}
