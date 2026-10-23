// Configs.h

//Application
#define TTL_SECURE_KEY_NSUSERDEFAULTS @"e0f31146225f4d56758e549fcd98d227ec3a02fdTapTalkioLive"

//Prefs Key
#define TTL_PREFS_ACTIVE_USER @"Prefs.TapTalkLiveActiveUser"
#define TTL_PREFS_ACCESS_TOKEN @"Prefs.TapTalkLiveAccessToken"
#define TTL_PREFS_REFRESH_TOKEN @"Prefs.TapTalkLiveRefreshToken"
#define TTL_PREFS_REFRESH_TOKEN_EXPIRED_TIME @"Prefs.TapTalkLiveRefreshTokenExpiredTime"
#define TTL_PREFS_ACCESS_TOKEN_EXPIRED_TIME @"Prefs.TapTalkLiveAccessTokenExpiredTime"
#define TTL_PREFS_IS_CONTAIN_CASE_LIST @"Prefs.TapTalkLiveIsContainCaseList"
#define TTL_PREFS_OPEN_CASE_LIST_COUNT @"Prefs.TapTalkLiveOpenCaseListCount"
#define TTL_PREFS_TOPICS @"Prefs.TapTalkLiveTopics"
#define TTL_PREFS_MAX_OPEN_CASES @"Prefs.TapTalkLiveMaxOpenCases"
#define TTL_PREFS_CHANNEL_LIST @"Prefs.TapTalkLiveChannelList"
#define TTL_PREFS_FAQ @"Prefs.TapTalkLiveFAQ"

#define TTL_PREFS_TAPTALK_API_URL @"Prefs.TapTalkLiveTapTalkApiUrl"
#define TTL_PREFS_TAPTALK_APP_KEY_ID @"Prefs.TapTalkLiveTapTalkAppKeyId"
#define TTL_PREFS_TAPTALK_APP_KEY_SECRET @"Prefs.TapTalkLiveTapTalkAppKeySecret"

//Color
#define TTL_COLOR_WHITE @"FFFFFF"
#define TTL_COLOR_GREY_DC @"DCDCDC"

//Notification
#define TTL_NOTIFICATION_REACHABILITY_STATUS_CHANGED @"Notification.TapTalkLiveReachabilityStatusChanged"
#define TTL_NOTIFICATION_CREATE_CASE_SUCCEED @"Notification.TapTalkLiveCreateCaseSucceed"
#define TTL_NOTIFICATION_SCF_PATH_UPDATED @"Notification.TapTalkLiveScfPathUpdated"
#define TTL_NOTIFICATION_SCF_PATH_CONTENT_RESPONSE_FETCHED @"Notification.TapTalkLiveScfPathContentResponseFetched"
#define TTL_NOTIFICATION_ROOM_LIST_UNREAD_COUNT_UPDATED @"Notification.TapTalkLiveRoomListUnreadCountUpdated"

// Message Type
#define MESSAGE_TYPE_CLOSE_CASE 3001
#define MESSAGE_TYPE_REOPEN_CASE 3002
#define MESSAGE_TYPE_REVIEW 3003
#define MESSAGE_TYPE_REVIEW_SUBMITTED 3004
#define MESSAGE_TYPE_CASE_CREATED 3005
#define MESSAGE_TYPE_AGENT_CHANGED 3006
#define MESSAGE_TYPE_CASE_DETAILS_UPDATED 3007
#define MESSAGE_TYPE_BROADCAST_TEXT_MESSAGE 3011
#define MESSAGE_TYPE_BROADCAST_IMAGE_MESSAGE 3012
#define MESSAGE_TYPE_BROADCAST_VIDEO_MESSAGE 3013
#define MESSAGE_TYPE_BROADCAST_FILE_MESSAGE 3014
#define MESSAGE_TYPE_WABA_TEMPLATE_TEXT_MESSAGE 3021
#define MESSAGE_TYPE_WABA_TEMPLATE_IMAGE_MESSAGE 3022
#define MESSAGE_TYPE_WABA_TEMPLATE_VIDEO_MESSAGE 3023
#define MESSAGE_TYPE_WABA_TEMPLATE_FILE_MESSAGE 3024

// Channel
#pragma mark CHANNEL / MEDIUM
#define CHANNEL_LAUNCHER @"launcher"
#define CHANNEL_WHATSAPP @"whatsapp" // WhatsApp SME
#define CHANNEL_WHATSAPP_BA @"whatsappba"
#define CHANNEL_INSTAGRAM @"instagram"
#define CHANNEL_TELEGRAM @"telegram"
#define CHANNEL_LINE @"line"
#define CHANNEL_TWITTER @"twitter"
#define CHANNEL_FACEBOOK @"facebook"
#define CHANNEL_GOOGLE_BUSINESS @"google_business"
#define CHANNEL_EMAIL @"email"
#define CHANNEL_KATA_AI @"kataai"

// SCF / FAQ Path Type
#define FAQ_QNA @"qna"
#define FAQ_QNA_VIA_API @"qna_via_api"
#define FAQ_TALK_TO_AGENT @"talk_to_agent"

// Message Type String
#define MESSAGE_TYPE_STRING_TEXT @"text"
#define MESSAGE_TYPE_STRING_IMAGE @"image"
#define MESSAGE_TYPE_STRING_VIDEO @"video"
#define MESSAGE_TYPE_STRING_FILE @"file"
#define MESSAGE_TYPE_STRING_DOCUMENT @"document"

// Error Code
#define ERROR_CODE_TAPTALKLIVE_NOT_INITIALIZED 91000
#define ERROR_CODE_ACTIVE_USER_NOT_FOUND 91001
#define ERROR_CODE_TOPIC_ID_REQUIRED 91002
#define ERROR_CODE_MESSAGE_REQUIRED 91003
#define ERROR_CODE_CONTROLLER_REQUIRED 91004
#define ERROR_CODE_XC_ROOM_ID_REQUIRED 91005

// Error Message
#define ERROR_MESSAGE_TAPTALKLIVE_NOT_INITIALIZED @"TapTalkLive instance is not initialized, please initialize by calling initWithSecretKey"
#define ERROR_MESSAGE_ACTIVE_USER_NOT_FOUND @"Active user not found, please authenticate by calling authenticateUser"
#define ERROR_MESSAGE_TOPIC_ID_REQUIRED @"Topic ID is required"
#define ERROR_MESSAGE_MESSAGE_REQUIRED @"Message is required"
#define ERROR_MESSAGE_CONTROLLER_REQUIRED @"Controller is required"
#define ERROR_MESSAGE_XC_ROOM_ID_REQUIRED @"XC Room ID is required"
