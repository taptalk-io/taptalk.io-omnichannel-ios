//
//  TTLStyleManager.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTLDefaultColor) {
    TTLDefaultColorPrimaryExtraLight,
    TTLDefaultColorPrimaryLight,
    TTLDefaultColorPrimary,
    TTLDefaultColorPrimaryDark,
    TTLDefaultColorSuccess,
    TTLDefaultColorError,
    TTLDefaultColorTextLight,
    TTLDefaultColorTextMedium,
    TTLDefaultColorTextDark,
    TTLDefaultColorIconPrimary,
    TTLDefaultColorIconWhite,
    TTLDefaultColorIconGray,
    TTLDefaultColorIconSuccess,
    TTLDefaultColorIconDestructive,
    // TTLDefaultColor enum needs to be same as TAPDefaultColor (TAPStyleManager)
};

typedef NS_ENUM(NSInteger, TTLDefaultFont) {
    TTLDefaultFontRegular,
    TTLDefaultFontMedium,
    TTLDefaultFontBold,
    TTLDefaultFontItalic
    // TTLDefaultFont enum needs to be same as TAPDefaultFont (TAPStyleManager)
};

typedef NS_ENUM(NSInteger, TTLComponentColor) {
    TTLComponentColorDefaultNavigationBarBackground,
    TTLComponentColorDefaultBackground,
    TTLComponentColorTextFieldCursor,
    TTLComponentColorTextFieldBorderActive,
    TTLComponentColorTextFieldBorderInactive,
    TTLComponentColorTextFieldBorderError,
    TTLComponentColorButtonActiveBackgroundGradientLight,
    TTLComponentColorButtonActiveBackgroundGradientDark,
    TTLComponentColorButtonActiveBorder,
    TTLComponentColorButtonInactiveBackgroundGradientLight,
    TTLComponentColorButtonInactiveBackgroundGradientDark,
    TTLComponentColorButtonInactiveBorder,
    TTLComponentColorButtonDestructiveBackground,
    TTLComponentColorSwitchActiveBackground,
    TTLComponentColorSwitchInactiveBackground,
    TTLComponentColorPopupDialogPrimaryButtonSuccessBackground,
    TTLComponentColorPopupDialogPrimaryButtonErrorBackground,
    TTLComponentColorPopupDialogSecondaryButtonBackground,
    TTLComponentColorUnreadBadgeBackground,
    TTLComponentColorUnreadBadgeInactiveBackground,
    TTLComponentColorTableViewSectionIndex,
    TTLComponentColorSearchBarBorderActive,
    TTLComponentColorSearchBarBorderInactive,
    TTLComponentColorChatRoomBackground,
    TTLComponentColorRoomListBackground,
    TTLComponentColorRoomListUnreadBadgeBackground,
    TTLComponentColorRoomListUnreadBadgeInactiveBackground,
    TTLComponentColorChatRoomUnreadBadgeBackground,
    TTLComponentColorChatRoomUnreadBadgeInactiveBackground,
    TTLComponentColorQuoteLayoutDecorationBackground,
    TTLComponentColorLeftBubbleBackground,
    TTLComponentColorRightBubbleBackground,
    TTLComponentColorLeftBubbleQuoteBackground,
    TTLComponentColorRightBubbleQuoteBackground,
    TTLComponentColorLeftFileButtonBackground,
    TTLComponentColorRightFileButtonBackground,
    TTLComponentColorSystemMessageBackground,
    TTLComponentColorSystemMessageBackgroundShadow,
    TTLComponentColorFileProgressBackground,
    TTLComponentColorDeletedChatRoomInfoBackground,
    TTLComponentColorChatComposerBackground,
    TTLComponentColorUnreadIdentifierBackground,
    TTLComponentColorSelectedMediaPreviewThumbnailBorder,
    TTLComponentColorMediaPreviewWarningBackgroundColor,
    TTLComponentColorSearchConnectionLostBackgroundColor,
    TTLComponentColorButtonIcon,
    TTLComponentColorButtonIconPrimary,
    TTLComponentColorButtonIconDestructive,
    TTLComponentColorIconMessageSending,
    TTLComponentColorIconMessageFailed,
    TTLComponentColorIconMessageSent,
    TTLComponentColorIconMessageDelivered,
    TTLComponentColorIconMessageRead,
    TTLComponentColorIconMessageDeleted,
    TTLComponentColorIconRemoveItem,
    TTLComponentColorIconRemoveItemBackground,
    TTLComponentColorIconLoadingProgressPrimary,
    TTLComponentColorIconLoadingProgressWhite,
    TTLComponentColorIconChevronRightPrimary,
    TTLComponentColorIconChevronRightGray,
    TTLComponentColorIconChecklist,
    TTLComponentColorIconLoadingPopupSuccess,
    TTLComponentColorIconSearchConnectionLost,
    TTLComponentColorIconCircleSelectionActive,
    TTLComponentColorIconCircleSelectionInactive,
    TTLComponentColorIconNavigationBarBackButton, //Navigation Bar
    TTLComponentColorIconTransparentBackgroundBackButton, //Navigation Bar
    TTLComponentColorIconNavigationBarCloseButton, //Navigation Bar
    TTLComponentColorIconClearTextButton, //Navigation Bar
    TTLComponentColorIconSearchBarMagnifier, //Navigation Bar
    TTLComponentColorIconActionSheetDocument, //Action Sheet
    TTLComponentColorIconActionSheetCamera, //Action Sheet
    TTLComponentColorIconActionSheetGallery, //Action Sheet
    TTLComponentColorIconActionSheetLocation, //Action Sheet
    TTLComponentColorIconActionSheetComposeEmail, //Action Sheet
    TTLComponentColorIconActionSheetCopy, //Action Sheet
    TTLComponentColorIconActionSheetOpen, //Action Sheet
    TTLComponentColorIconActionSheetSMS, //Action Sheet
    TTLComponentColorIconActionSheetCall, //Action Sheet
    TTLComponentColorIconActionSheetReply, //Action Sheet
    TTLComponentColorIconActionSheetForward, //Action Sheet
    TTLComponentColorIconActionSheetTrash, //Action Sheet
    TTLComponentColorIconViewPasswordActive, // Register
    TTLComponentColorIconViewPasswordInactive, // Register
    TTLComponentColorIconChangePicture, // Register
    TTLComponentColorIconSelectPictureCamera, // Register
    TTLComponentColorIconSelectPictureGallery, // Register
    TTLComponentColorIconChatRoomCancelQuote, //Chat Room
    TTLComponentColorIconCancelUploadDownload, //Chat Room
    TTLComponentColorIconChatComposerSend, //Chat Room
    TTLComponentColorIconChatComposerSendInactive, //Chat Room
    TTLComponentColorIconChatComposerBurgerMenu, //Chat Room
    TTLComponentColorIconChatComposerShowKeyboard, //Chat Room
    TTLComponentColorIconChatComposerSendBackground, //Chat Room
    TTLComponentColorIconChatComposerSendBackgroundInactive, //Chat Room
    TTLComponentColorIconDeletedLeftMessageBubble, //Chat Room
    TTLComponentColorIconDeletedRightMessageBubble, //Chat Room
    TTLComponentColorIconRoomListMuted, //Room List
    TTLComponentColorIconStartNewChatButton, //RoomList
    TTLComponentColorIconRoomListSettingUp, //Room List Setup
    TTLComponentColorIconRoomListSetUpSuccess, //Room List Setup
    TTLComponentColorIconRoomListSetUpFailure, //Room List Setup
    TTLComponentColorIconRoomListRetrySetUpButton, //Room List Setup
    TTLComponentColorIconMenuNewContact, //New Chat Page
    TTLComponentColorIconMenuScanQRCode, //New Chat Page
    TTLComponentColorIconMenuNewGroup, //New Chat Page
    TTLComponentColorIconChatProfileMenuNotificationActive, //Chat / Group Profile Page
    TTLComponentColorIconChatProfileMenuNotificationInactive, //Chat / Group Profile Page
    TTLComponentColorIconChatProfileMenuConversationColor, //Chat / Group Profile Page
    TTLComponentColorIconChatProfileMenuBlockUser, //Chat / Group Profile Page
    TTLComponentColorIconChatProfileMenuSearchChat, //Chat / Group Profile Page
    TTLComponentColorIconChatProfileMenuClearChat, //Chat / Group Profile Page
    TTLComponentColorIconGroupProfileMenuViewMembers, //Chat / Group Profile Page
    TTLComponentColorIconGroupMemberProfileMenuAddToContacts, //Chat / Group Profile Page
    TTLComponentColorIconGroupMemberProfileMenuSendMessage, //Chat / Group Profile Page
    TTLComponentColorIconGroupMemberProfileMenuPromoteAdmin, //Chat / Group Profile Page
    TTLComponentColorIconGroupMemberProfileMenuDemoteAdmin, //Chat / Group Profile Page
    TTLComponentColorIconGroupMemberProfileMenuRemoveMember, //Chat / Group Profile Page
    TTLComponentColorIconMediaPreviewAdd, //Media / Image Detail Preview
    TTLComponentColorIconMediaPreviewWarning, //Media / Image Detail Preview
    TTLComponentColorIconMediaPreviewThumbnailWarning,//Media / Image Detail Preview
    TTLComponentColorIconMediaPreviewThumbnailWarningBackground,//Media / Image Detail Preview
    TTLComponentColorIconSaveImage,//Media / Image Detail Preview
    TTLComponentColorIconMediaListVideo,//Media / Image Detail Preview
    TTLComponentColorIconCloseScanResult, //Scan Result
    TTLComponentColorIconCloseScanResultBackground,//Scan Result
    TTLComponentColorIconLocationPickerMarker, //Location Picker
    TTLComponentColorIconLocationPickerRecenter, //Location Picker
    TTLComponentColorIconLocationPickerRecenterBackground, //Location Picker
    TTLComponentColorIconLocationPickerSendLocation, //Location Picker
    TTLComponentColorIconLocationPickerSendLocationBackground, //Location Picker
    TTLComponentColorIconLocationPickerAddressActive, //Location Picker
    TTLComponentColorIconLocationPickerAddressInactive,//Location Picker
    TTLComponentColorIconUserStatusActive, //Chat Room Page
    TTLComponentColorIconLocationBubbleMarker, //Chat Room Page
    TTLComponentColorIconQuotedFileBackground, //Chat Room Page
    TTLComponentColorIconDeletedChatRoom, //Chat Room Page
    TTLComponentColorIconChatRoomScrollToBottomBackground, //Chat Room Page
    TTLComponentColorIconChatRoomScrollToBottom, //Chat Room Page
    TTLComponentColorIconChatRoomUnreadButton, //Chat Room Page
    TTLComponentColorIconChatRoomFloatingUnreadButton, //Chat Room Page
    TTLComponentColorIconChatComposerBurgerMenuBackground, //Chat Room Page
    TTLComponentColorIconChatComposerShowKeyboardBackground, //Chat Room Page
    TTLComponentColorIconChatComposerAttach, //Chat Room Page
    TTLComponentColorIconFile, //Chat Room Page
    TTLComponentColorIconFileUploadDownload, //Chat Room Page
    TTLComponentColorIconFileCancelUploadDownload, //Chat Room Page
    TTLComponentColorIconFileRetryUploadDownload, //Chat Room Page
    TTLComponentColorIconFilePlayMedia, //Chat Room Page
    TTLComponentColorIconReviewBubbleCellDoneReviewCheck, //Review Bubble Cell
};

typedef NS_ENUM(NSInteger, TTLTextColor) {
    TTLTextColorTitleLabel,
    TTLTextColorNavigationBarTitleLabel,
    TTLTextColorNavigationBarButtonLabel,
    TTLTextColorFormLabel,
    TTLTextColorFormDescriptionLabel,
    TTLTextColorFormErrorInfoLabel,
    TTLTextColorFormTextField,
    TTLTextColorFormTextFieldPlaceholder,
    TTLTextColorClickableLabel,
    TTLTextColorClickableDestructiveLabel,
    TTLTextColorButtonLabel,
    TTLTextColorInfoLabelTitle,
    TTLTextColorInfoLabelSubtitle,
    TTLTextColorInfoLabelSubtitleBold,
    TTLTextColorInfoLabelBody,
    TTLTextColorInfoLabelBodyBold,
    TTLTextColorKeyboardAccessoryLabel,
    TTLTextColorPopupLoadingLabel,
    TTLTextColorSearchConnectionLostTitle,
    TTLTextColorSearchConnectionLostDescription,
    TTLTextColorUnreadBadgeLabel,
    TTLTextColorSearchBarText,
    TTLTextColorSearchBarTextPlaceholder,
    TTLTextColorSearchBarTextCancelButton,
    TTLTextColorPopupDialogTitle,
    TTLTextColorPopupDialogBody,
    TTLTextColorPopupDialogButtonTextPrimary,
    TTLTextColorPopupDialogButtonTextSecondary,
    TTLTextColorActionSheetDefaultLabel,
    TTLTextColorActionSheetDestructiveLabel,
    TTLTextColorActionSheetCancelButtonLabel,
    TTLTextColorTableViewSectionHeaderLabel,
    TTLTextColorContactListName,
    TTLTextColorContactListNameHighlighted,
    TTLTextColorContactListUsername,
    TTLTextColorMediaListInfoLabel,
    TTLTextColorRoomListName,
    TTLTextColorRoomListNameHighlighted,
    TTLTextColorRoomListMessage,
    TTLTextColorRoomListMessageHighlighted,
    TTLTextColorRoomListTime,
    TTLTextColorGroupRoomListSenderName,
    TTLTextColorRoomListUnreadBadgeLabel,
    TTLTextColorNewChatMenuLabel,
    TTLTextColorChatProfileRoomNameLabel,
    TTLTextColorChatProfileMenuLabel,
    TTLTextColorChatProfileMenuDestructiveLabel,
    TTLTextColorSearchNewContactResultName,
    TTLTextColorSearchNewContactResultUsername,
    TTLTextColorAlbumNameLabel,
    TTLTextColorAlbumCountLabel,
    TTLTextColorGalleryPickerCancelButton,
    TTLTextColorGalleryPickerContinueButton,
    TTLTextColorChatRoomNameLabel,
    TTLTextColorChatRoomStatusLabel,
    TTLTextColorChatComposerTextField,
    TTLTextColorChatComposerTextFieldPlaceholder,
    TTLTextColorCustomKeyboardItemLabel,
    TTLTextColorQuoteLayoutTitleLabel,
    TTLTextColorQuoteLayoutContentLabel,
    TTLTextColorRightBubbleMessageBody,
    TTLTextColorLeftBubbleMessageBody,
    TTLTextColorRightBubbleMessageBodyURL,
    TTLTextColorLeftBubbleMessageBodyURL,
    TTLTextColorRightBubbleMessageBodyURLHighlighted,
    TTLTextColorLeftBubbleMessageBodyURLHighlighted,
    TTLTextColorRightBubbleDeletedMessageBody,
    TTLTextColorLeftBubbleDeletedMessageBody,
    TTLTextColorRightBubbleQuoteTitle,
    TTLTextColorLeftBubbleQuoteTitle,
    TTLTextColorRightBubbleQuoteContent,
    TTLTextColorLeftBubbleQuoteContent,
    TTLTextColorRightFileBubbleName,
    TTLTextColorLeftFileBubbleName,
    TTLTextColorRightFileBubbleInfo,
    TTLTextColorLeftFileBubbleInfo,
    TTLTextColorLeftBubbleSenderName,
    TTLTextColorBubbleMessageStatus,
    TTLTextColorBubbleMediaInfo,
    TTLTextColorSystemMessageBody,
    TTLTextColorChatRoomUnreadBadge,
    TTLTextColorUnreadMessageIdentifier,
    TTLTextColorUnreadMessageButtonLabel,
    TTLTextColorDeletedChatRoomInfoTitleLabel,
    TTLTextColorDeletedChatRoomInfoContentLabel,
    TTLTextColorLocationPickerTextField,
    TTLTextColorLocationPickerTextFieldPlaceholder,
    TTLTextColorLocationPickerClearButton,
    TTLTextColorLocationPickerSearchResult,
    TTLTextColorLocationPickerAddress,
    TTLTextColorLocationPickerAddressPlaceholder,
    TTLTextColorLocationPickerSendLocationButton,
    TTLTextColorMediaPreviewCancelButton,
    TTLTextColorMediaPreviewItemCount,
    TTLTextColorMediaPreviewCaption,
    TTLTextColorMediaPreviewCaptionPlaceholder,
    TTLTextColorMediaPreviewCaptionLetterCount,
    TTLTextColorMediaPreviewSendButtonLabel,
    TTLTextColorMediaPreviewWarningTitle,
    TTLTextColorMediaPreviewWarningBody,
    TTLTextColorImageDetailSenderName,
    TTLTextColorImageDetailMessageStatus,
    TTLTextColorImageDetailCaption,
    TTLTextColorCustomNotificationTitleLabel,
    TTLTextColorCustomNotificationContentLabel,
    TTLTextColorSelectedMemberListName,
    TTLTextColorGroupMemberCount,
    TTLTextColorCountryPickerLabel,
    TTLTextColorLoginVerificationInfoLabel,
    TTLTextColorLoginVerificationPhoneNumberLabel,
    TTLTextColorLoginVerificationStatusCountdownLabel,
    TTLTextColorLoginVerificationStatusLoadingLabel,
    TTLTextColorLoginVerificationStatusSuccessLabel,
    TTLTextColorLoginVerificationCodeInputLabel,
    TTLTextColorSearchClearHistoryLabel,
    TTLTextColorCreateGroupSubjectLoadingLabel,
    TTLTextColorCustomWebViewNavigationTitleLabel,
    TTLTextColorRoomAvatarSmallLabel,
    TTLTextColorRoomAvatarMediumLabel,
    TTLTextColorRoomAvatarLargeLabel,
    TTLTextColorRoomAvatarExtraLargeLabel,
    TTLTextColorTopicListLabel,
    TTLTextColorTopicListLabelSelected,
    TTLTextColorRatingBodyLabel,
    TTLTextColorReviewBubbleDoneReviewButtonTitleLabel,
    TTLTextColorCreateFormTitle,
    TTLTextColorCreateFormDescription,
};

typedef NS_ENUM(NSInteger, TTLComponentFont) {
    TTLComponentFontTitleLabel,
    TTLComponentFontNavigationBarTitleLabel,
    TTLComponentFontNavigationBarButtonLabel,
    TTLComponentFontFormLabel,
    TTLComponentFontFormDescriptionLabel,
    TTLComponentFontFormErrorInfoLabel,
    TTLComponentFontFormTextField,
    TTLComponentFontFormTextFieldPlaceholder,
    TTLComponentFontClickableLabel,
    TTLComponentFontClickableDestructiveLabel,
    TTLComponentFontButtonLabel,
    TTLComponentFontInfoLabelTitle,
    TTLComponentFontInfoLabelSubtitle,
    TTLComponentFontInfoLabelSubtitleBold,
    TTLComponentFontInfoLabelBody,
    TTLComponentFontInfoLabelBodyBold,
    TTLComponentFontKeyboardAccessoryLabel,
    TTLComponentFontPopupLoadingLabel,
    TTLComponentFontSearchConnectionLostTitle,
    TTLComponentFontSearchConnectionLostDescription,
    TTLComponentFontUnreadBadgeLabel,
    TTLComponentFontSearchBarText,
    TTLComponentFontSearchBarTextPlaceholder,
    TTLComponentFontSearchBarTextCancelButton,
    TTLComponentFontPopupDialogTitle,
    TTLComponentFontPopupDialogBody,
    TTLComponentFontPopupDialogButtonTextPrimary,
    TTLComponentFontPopupDialogButtonTextSecondary,
    TTLComponentFontActionSheetDefaultLabel,
    TTLComponentFontActionSheetDestructiveLabel,
    TTLComponentFontActionSheetCancelButtonLabel,
    TTLComponentFontTableViewSectionHeaderLabel,
    TTLComponentFontContactListName,
    TTLComponentFontContactListNameHighlighted,
    TTLComponentFontContactListUsername,
    TTLComponentFontMediaListInfoLabel,
    TTLComponentFontRoomListName,
    TTLComponentFontRoomListNameHighlighted,
    TTLComponentFontRoomListMessage,
    TTLComponentFontRoomListMessageHighlighted,
    TTLComponentFontRoomListTime,
    TTLComponentFontGroupRoomListSenderName,
    TTLComponentFontRoomListUnreadBadgeLabel,
    TTLComponentFontNewChatMenuLabel,
    TTLComponentFontChatProfileRoomNameLabel,
    TTLComponentFontChatProfileMenuLabel,
    TTLComponentFontChatProfileMenuDestructiveLabel,
    TTLComponentFontSearchNewContactResultName,
    TTLComponentFontSearchNewContactResultUsername,
    TTLComponentFontAlbumNameLabel,
    TTLComponentFontAlbumCountLabel,
    TTLComponentFontGalleryPickerCancelButton,
    TTLComponentFontGalleryPickerContinueButton,
    TTLComponentFontChatRoomNameLabel,
    TTLComponentFontChatRoomStatusLabel,
    TTLComponentFontChatComposerTextField,
    TTLComponentFontChatComposerTextFieldPlaceholder,
    TTLComponentFontCustomKeyboardItemLabel,
    TTLComponentFontQuoteLayoutTitleLabel,
    TTLComponentFontQuoteLayoutContentLabel,
    TTLComponentFontRightBubbleMessageBody,
    TTLComponentFontLeftBubbleMessageBody,
    TTLComponentFontRightBubbleMessageBodyURL,
    TTLComponentFontLeftBubbleMessageBodyURL,
    TTLComponentFontRightBubbleMessageBodyURLHighlighted,
    TTLComponentFontLeftBubbleMessageBodyURLHighlighted,
    TTLComponentFontRightBubbleDeletedMessageBody,
    TTLComponentFontLeftBubbleDeletedMessageBody,
    TTLComponentFontRightBubbleQuoteTitle,
    TTLComponentFontLeftBubbleQuoteTitle,
    TTLComponentFontRightBubbleQuoteContent,
    TTLComponentFontLeftBubbleQuoteContent,
    TTLComponentFontRightFileBubbleName,
    TTLComponentFontLeftFileBubbleName,
    TTLComponentFontRightFileBubbleInfo,
    TTLComponentFontLeftFileBubbleInfo,
    TTLComponentFontLeftBubbleSenderName,
    TTLComponentFontBubbleMessageStatus,
    TTLComponentFontBubbleMediaInfo,
    TTLComponentFontSystemMessageBody,
    TTLComponentFontChatRoomUnreadBadge,
    TTLComponentFontUnreadMessageIdentifier,
    TTLComponentFontUnreadMessageButtonLabel,
    TTLComponentFontDeletedChatRoomInfoTitleLabel,
    TTLComponentFontDeletedChatRoomInfoContentLabel,
    TTLComponentFontLocationPickerTextField,
    TTLComponentFontLocationPickerTextFieldPlaceholder,
    TTLComponentFontLocationPickerClearButton,
    TTLComponentFontLocationPickerSearchResult,
    TTLComponentFontLocationPickerAddress,
    TTLComponentFontLocationPickerAddressPlaceholder,
    TTLComponentFontLocationPickerSendLocationButton,
    TTLComponentFontMediaPreviewCancelButton,
    TTLComponentFontMediaPreviewItemCount,
    TTLComponentFontMediaPreviewCaption,
    TTLComponentFontMediaPreviewCaptionPlaceholder,
    TTLComponentFontMediaPreviewCaptionLetterCount,
    TTLComponentFontMediaPreviewSendButtonLabel,
    TTLComponentFontMediaPreviewWarningTitle,
    TTLComponentFontMediaPreviewWarningBody,
    TTLComponentFontImageDetailSenderName,
    TTLComponentFontImageDetailMessageStatus,
    TTLComponentFontImageDetailCaption,
    TTLComponentFontCustomNotificationTitleLabel,
    TTLComponentFontCustomNotificationContentLabel,
    TTLComponentFontSelectedMemberListName,
    TTLComponentFontGroupMemberCount,
    TTLComponentFontCountryPickerLabel,
    TTLComponentFontLoginVerificationInfoLabel,
    TTLComponentFontLoginVerificationPhoneNumberLabel,
    TTLComponentFontLoginVerificationStatusCountdownLabel,
    TTLComponentFontLoginVerificationStatusLoadingLabel,
    TTLComponentFontLoginVerificationStatusSuccessLabel,
    TTLComponentFontRoomAvatarSmallLabel,
    TTLComponentFontRoomAvatarMediumLabel,
    TTLComponentFontRoomAvatarLargeLabel,
    TTLComponentFontRoomAvatarExtraLargeLabel,
    TTLComponentFontTopicListLabel,
};

@interface TTLStyleManager : NSObject

+ (TTLStyleManager *)sharedManager;
- (void)clearStyleManagerData;

- (void)setDefaultFont:(UIFont *)font forType:(TTLDefaultFont)defaultFontType;
- (void)setComponentFont:(UIFont *)font forType:(TTLComponentFont)componentFontType;
- (void)setDefaultColor:(UIColor *)color forType:(TTLDefaultColor)defaultColorType;
- (void)setTextColor:(UIColor *)color forType:(TTLTextColor)textColorType;
- (void)setComponentColor:(UIColor *)color forType:(TTLComponentColor)componentColorType;

- (UIFont *)getDefaultFontForType:(TTLDefaultFont)defaultFontType;
- (UIFont *)getComponentFontForType:(TTLComponentFont)componentFontType;
- (UIColor *)getDefaultColorForType:(TTLDefaultColor)defaultColorType;
- (UIColor *)getTextColorForType:(TTLTextColor)textColorType;
- (UIColor *)getComponentColorForType:(TTLComponentColor)componentType;

- (UIColor *)getRandomDefaultAvatarBackgroundColorWithName:(NSString *)name;
- (NSString *)getInitialsWithName:(NSString *)name isGroup:(BOOL)isGroup;

@end

NS_ASSUME_NONNULL_END
