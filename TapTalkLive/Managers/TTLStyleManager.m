//
//  TTLStyleManager.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 Taptalk.io. All rights reserved.
//

#import "TTLStyleManager.h"

@interface TTLStyleManager ()

@property (strong, nonatomic) NSMutableDictionary *defaultColorDictionary;
@property (strong, nonatomic) NSMutableDictionary *textColorDictionary;
@property (strong, nonatomic) NSMutableDictionary *componentColorDictionary;
@property (strong, nonatomic) NSMutableDictionary *defaultFontDictionary;
@property (strong, nonatomic) NSMutableDictionary *componentFontDictionary;

- (UIFont *)retrieveFontDataWithIdentifier:(TTLDefaultFont)defaultFontType;
- (UIFont *)retrieveComponentFontDataWithIdentifier:(TTLComponentFont)componentFontType;
- (UIColor *)retrieveColorDataWithIdentifier:(TTLDefaultColor)defaultColorType;
- (UIColor *)retrieveTextColorDataWithIdentifier:(TTLTextColor)textColorType;
- (UIColor *)retrieveComponentColorDataWithIdentifier:(TTLComponentColor)componentType;

@end

@implementation TTLStyleManager
#pragma mark - Lifecycle
+ (TTLStyleManager *)sharedManager {
    static TTLStyleManager *sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[TTLStyleManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _defaultColorDictionary = [[NSMutableDictionary alloc] init];
        _defaultFontDictionary = [[NSMutableDictionary alloc] init];
        _textColorDictionary = [[NSMutableDictionary alloc] init];
        _componentColorDictionary = [[NSMutableDictionary alloc] init];
        _componentFontDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)clearStyleManagerData {
    [self.defaultColorDictionary removeAllObjects];
    [self.defaultFontDictionary removeAllObjects];
    [self.textColorDictionary removeAllObjects];
    [self.componentColorDictionary removeAllObjects];
    [self.componentFontDictionary removeAllObjects];
}


- (void)setDefaultFont:(UIFont *)font forType:(TTLDefaultFont)defaultFontType {
    [self.defaultFontDictionary setObject:font forKey:[NSNumber numberWithInteger:defaultFontType]];
}

- (void)setComponentFont:(UIFont *)font forType:(TTLComponentFont)componentFontType {
    [self.componentFontDictionary setObject:font forKey:[NSNumber numberWithInteger:componentFontType]];
}

- (void)setDefaultColor:(UIColor *)color forType:(TTLDefaultColor)defaultColorType {
    [self.defaultColorDictionary setObject:color forKey:[NSNumber numberWithInteger:defaultColorType]];
}

- (void)setTextColor:(UIColor *)color forType:(TTLTextColor)textColorType {
    [self.textColorDictionary setObject:color forKey:[NSNumber numberWithInteger:textColorType]];
}

- (void)setComponentColor:(UIColor *)color forType:(TTLComponentColor)componentColorType {
    [self.componentColorDictionary setObject:color forKey:[NSNumber numberWithInteger:componentColorType]];
}

- (UIFont *)getDefaultFontForType:(TTLDefaultFont)defaultFontType {
    UIFont *font = [[TTLStyleManager sharedManager] retrieveFontDataWithIdentifier:defaultFontType];
    return font;
}

- (UIFont *)getComponentFontForType:(TTLComponentFont)componentFontType {
    UIFont *font = [[TTLStyleManager sharedManager] retrieveComponentFontDataWithIdentifier:componentFontType];
    return font;
}

- (UIColor *)getDefaultColorForType:(TTLDefaultColor)defaultColorType {
    UIColor *color = [[TTLStyleManager sharedManager] retrieveColorDataWithIdentifier:defaultColorType];
    return color;
}

- (UIColor *)getTextColorForType:(TTLTextColor)textColorType {
    UIColor *color = [[TTLStyleManager sharedManager] retrieveTextColorDataWithIdentifier:textColorType];
    return color;
}

- (UIColor *)getComponentColorForType:(TTLComponentColor)componentType {
    UIColor *color = [[TTLStyleManager sharedManager] retrieveComponentColorDataWithIdentifier:componentType];
    return color;
}

- (UIFont *)retrieveFontDataWithIdentifier:(TTLDefaultFont)defaultFontType {
    UIFont *obtainedFont = [self.defaultFontDictionary objectForKey:[NSNumber numberWithInteger:defaultFontType]];
    if (obtainedFont != nil) {
        return obtainedFont;
    }
    
    switch (defaultFontType) {
        case TTLDefaultFontItalic:
        {
            UIFont *font = [UIFont fontWithName:TTL_FONT_FAMILY_ITALIC size:[UIFont systemFontSize]];
            return font;
            break;
        }
        case TTLDefaultFontRegular:
        {
            UIFont *font = [UIFont fontWithName:TTL_FONT_FAMILY_REGULAR size:[UIFont systemFontSize]];
            return font;
            break;
        }
        case TTLDefaultFontMedium:
        {
            UIFont *font = [UIFont fontWithName:TTL_FONT_FAMILY_MEDIUM size:[UIFont systemFontSize]];
            return font;
            break;
        }
        case TTLDefaultFontBold:
        {
            UIFont *font = [UIFont fontWithName:TTL_FONT_FAMILY_BOLD size:[UIFont systemFontSize]];
            return font;
            break;
        }
        default:
        {
            //Set default font to prevent crash
            UIFont *font = [UIFont fontWithName:TTL_FONT_FAMILY_REGULAR size:[UIFont systemFontSize]];
            return font;
            break;
        }
    }
}

- (UIFont *)retrieveComponentFontDataWithIdentifier:(TTLComponentFont)componentFontType {
    UIFont *obtainedFont = [self.componentFontDictionary objectForKey:[NSNumber numberWithInteger:componentFontType]];
    if (obtainedFont != nil) {
        return obtainedFont;
    }
    
    switch (componentFontType) {
        case TTLComponentFontTitleLabel:
        {
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_TITLE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontNavigationBarTitleLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_NAVIGATION_BAR_TITLE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontNavigationBarButtonLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_NAVIGATION_BAR_BUTTON_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontFormLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontMedium];
            font = [font fontWithSize:TTL_FORM_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontFormDescriptionLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_FORM_DESCRIPTION_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontFormErrorInfoLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_FORM_ERROR_INFO_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontFormTextField:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_FORM_TEXTFIELD_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontFormTextFieldPlaceholder:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_FORM_TEXTFIELD_PLACEHOLDER_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontClickableLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_CLICKABLE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontClickableDestructiveLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_CLICKABLE_DESTRUCTIVE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontButtonLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_BUTTON_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontInfoLabelTitle:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_INFO_LABEL_TITLE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontInfoLabelSubtitle:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_INFO_LABEL_SUBTITLE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontInfoLabelSubtitleBold:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_INFO_LABEL_SUBTITLE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontInfoLabelBody:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_INFO_LABEL_BODY_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontInfoLabelBodyBold:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_INFO_LABEL_BODY_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontKeyboardAccessoryLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_KEYBOARD_ACCESSORY_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontPopupLoadingLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_POPUP_LOADING_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontSearchConnectionLostTitle:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontMedium];
            font = [font fontWithSize:TTL_SEARCH_CONNECTION_LOST_TITLE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontSearchConnectionLostDescription:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_SEARCH_CONNECTION_LOST_DESCRIPTION_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontUnreadBadgeLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_UNREAD_BADGE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontSearchBarText:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_SEARCHBAR_TEXT_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontSearchBarTextPlaceholder:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_SEARCHBAR_TEXT_PLACEHOLDER_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontSearchBarTextCancelButton:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_SEARCHBAR_TEXT_CANCEL_BUTTON_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontPopupDialogTitle:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_POPUP_DIALOG_TITLE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontPopupDialogBody:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_POPUP_DIALOG_BODY_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontPopupDialogButtonTextPrimary:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_POPUP_DIALOG_BUTTON_TEXT_PRIMARY_SUCCESS_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontPopupDialogButtonTextSecondary:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_POPUP_DIALOG_BUTTON_TEXT_SECONDARY_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontActionSheetDefaultLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_ACTION_SHEET_DEFAULT_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontActionSheetDestructiveLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_ACTION_SHEET_DESTRUCTIVE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontActionSheetCancelButtonLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_ACTION_SHEET_CANCEL_BUTTON_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontTableViewSectionHeaderLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_TABLEVIEW_SECTION_HEADER_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontContactListName:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_CONTACT_LIST_NAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontContactListNameHighlighted:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_CONTACT_LIST_NAME_HIGHLIGHTED_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontContactListUsername:
        {
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_CONTACT_LIST_USERNAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontMediaListInfoLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_MEDIA_LIST_INFO_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRoomListName:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_ROOM_LIST_NAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRoomListNameHighlighted:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_ROOM_LIST_NAME_HIGHLIGHTED_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRoomListMessage:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_ROOM_LIST_MESSAGE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRoomListMessageHighlighted:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_ROOM_LIST_MESSAGE_HIGHLIGHTED_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRoomListTime:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_ROOM_LIST_TIME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontGroupRoomListSenderName:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_GROUP_ROOM_LIST_SENDER_NAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRoomListUnreadBadgeLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_ROOM_LIST_UNREAD_BADGE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontNewChatMenuLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_NEW_CHAT_MENU_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontChatProfileRoomNameLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_CHAT_PROFILE_ROOM_NAME_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontChatProfileMenuLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_CHAT_PROFILE_MENU_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontChatProfileMenuDestructiveLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_CHAT_PROFILE_MENU_DESTRUCTIVE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontSearchNewContactResultName:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_SEARCH_NEW_CONTACT_RESULT_NAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontSearchNewContactResultUsername:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_SEARCH_NEW_CONTACT_RESULT_USERNAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontAlbumNameLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_ALBUM_NAME_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontAlbumCountLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_ALBUM_COUNT_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontGalleryPickerCancelButton:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_GALLERY_PICKER_CANCEL_BUTTON_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontGalleryPickerContinueButton:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_GALLERY_PICKER_CONTINUE_BUTTON_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontChatRoomNameLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_CHAT_ROOM_NAME_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontChatRoomStatusLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_CHAT_ROOM_STATUS_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontChatComposerTextField:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_CHAT_COMPOSER_TEXTFIELD_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontChatComposerTextFieldPlaceholder:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_CHAT_COMPOSER_TEXTFIELD_PLACEHOLDER_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontCustomKeyboardItemLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_CUSTOM_KEYBOARD_ITEM_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontQuoteLayoutTitleLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_QUOTE_LAYOUT_TITLE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontQuoteLayoutContentLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_QUOTE_LAYOUT_CONTENT_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRightBubbleMessageBody:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_RIGHT_BUBBLE_MESSAGE_BODY_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLeftBubbleMessageBody:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LEFT_BUBBLE_MESSAGE_BODY_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRightBubbleMessageBodyURL:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_RIGHT_BUBBLE_MESSAGE_BODY_URL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLeftBubbleMessageBodyURL:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LEFT_BUBBLE_MESSAGE_BODY_URL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRightBubbleMessageBodyURLHighlighted:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_RIGHT_BUBBLE_MESSAGE_BODY_URL_HIGHLIGHTED_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLeftBubbleMessageBodyURLHighlighted:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LEFT_BUBBLE_DELETED_MESSAGE_BODY_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRightBubbleDeletedMessageBody: {
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_RIGHT_BUBBLE_DELETED_MESSAGE_BODY_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLeftBubbleDeletedMessageBody: {
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LEFT_BUBBLE_MESSAGE_BODY_URL_HIGHLIGHTED_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRightBubbleQuoteTitle:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_RIGHT_BUBBLE_QUOTE_TITLE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLeftBubbleQuoteTitle:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_LEFT_BUBBLE_QUOTE_TITLE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRightBubbleQuoteContent:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_RIGHT_BUBBLE_QUOTE_CONTENT_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLeftBubbleQuoteContent:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LEFT_BUBBLE_QUOTE_CONTENT_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRightFileBubbleName:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_RIGHT_FILE_BUBBLE_NAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLeftFileBubbleName:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_LEFT_FILE_BUBBLE_NAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRightFileBubbleInfo:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_RIGHT_FILE_BUBBLE_INFO_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLeftFileBubbleInfo:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LEFT_FILE_BUBBLE_INFO_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLeftBubbleSenderName:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_LEFT_BUBBLE_SENDER_NAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontBubbleMessageStatus:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_BUBBLE_MESSAGE_STATUS_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontBubbleMediaInfo:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_BUBBLE_MEDIA_INFO_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontSystemMessageBody:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontMedium];
            font = [font fontWithSize:TTL_SYSTEM_MESSAGE_BODY_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontChatRoomUnreadBadge:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_CHAT_ROOM_UNREAD_BADGE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontUnreadMessageIdentifier:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_UNREAD_MESSAGE_IDENTIFIER_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontUnreadMessageButtonLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontMedium];
            font = [font fontWithSize:TTL_UNREAD_MESSAGE_BUTTON_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontDeletedChatRoomInfoTitleLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_DELETED_CHAT_ROOM_INFO_TITLE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontDeletedChatRoomInfoContentLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_DELETED_CHAT_ROOM_INFO_CONTENT_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLocationPickerTextField:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LOCATION_PICKER_TEXTFIELD_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLocationPickerTextFieldPlaceholder:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LOCATION_PICKER_TEXTFIELD_PLACEHOLDER_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLocationPickerClearButton:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_LOCATION_PICKER_TEXTFIELD_CLEAR_BUTTON_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLocationPickerSearchResult:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LOCATION_PICKER_SEARCH_RESULT_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLocationPickerAddress:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LOCATION_PICKER_ADDRESS_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLocationPickerAddressPlaceholder:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_LOCATION_PICKER_ADDRESS_PLACEHOLDER_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLocationPickerSendLocationButton:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_LOCATION_PICKER_SEND_LOCATION_BUTTON_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontMediaPreviewCancelButton:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_MEDIA_PREVIEW_CANCEL_BUTTON_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontMediaPreviewItemCount:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_MEDIA_PREVIEW_ITEM_COUNT_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontMediaPreviewCaption:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_MEDIA_PREVIEW_CAPTION_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontMediaPreviewCaptionPlaceholder:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_MEDIA_PREVIEW_CAPTION_PLACEHOLDER_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontMediaPreviewCaptionLetterCount:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_MEDIA_PREVIEW_CAPTION_LETTER_COUNT_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontMediaPreviewSendButtonLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_MEDIA_PREVIEW_SEND_BUTTON_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontMediaPreviewWarningTitle:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_MEDIA_PREVIEW_WARNING_TITLE_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontMediaPreviewWarningBody:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_MEDIA_PREVIEW_WARNING_BODY_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontImageDetailSenderName:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_IMAGE_DETAIL_SENDER_NAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontImageDetailMessageStatus:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_IMAGE_DETAIL_MESSAGE_STATUS_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontImageDetailCaption:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_IMAGE_DETAIL_CAPTION_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontCustomNotificationTitleLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_CUSTOM_NOTIFICATION_TITLE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontCustomNotificationContentLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_CUSTOM_NOTIFICATION_CONTENT_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontSelectedMemberListName:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_SELECTED_MEMBER_LIST_NAME_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontGroupMemberCount:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_GROUP_MEMBER_COUNT_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontCountryPickerLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:TTL_COUNTRY_PICKER_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLoginVerificationInfoLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontMedium];
            font = [font fontWithSize:TTL_LOGIN_VERIFICATION_INFO_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLoginVerificationPhoneNumberLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_LOGIN_VERIFICATION_PHONE_NUMBER_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLoginVerificationStatusCountdownLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_LOGIN_VERIFICATION_STATUS_COUNTDOWN_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLoginVerificationStatusLoadingLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_LOGIN_VERIFICATION_STATUS_LOADING_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontLoginVerificationStatusSuccessLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_LOGIN_VERIFICATION_STATUS_SUCCESS_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRoomAvatarSmallLabel:
        {
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_DEFAULT_ROOM_AVATAR_SMALL_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRoomAvatarMediumLabel:
        {
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_DEFAULT_ROOM_AVATAR_MEDIUM_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRoomAvatarLargeLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_DEFAULT_ROOM_AVATAR_LARGE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontRoomAvatarExtraLargeLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
            font = [font fontWithSize:TTL_DEFAULT_ROOM_AVATAR_EXTRA_LARGE_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        case TTLComponentFontTopicListLabel:
        {
            
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontMedium];
            font = [font fontWithSize:TTL_TOPIC_LIST_LABEL_FONTSIZE_STYLE];
            return font;
            break;
        }
        default: {
            UIFont *font = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
            font = [font fontWithSize:[UIFont systemFontSize]];
            return font;
            break;
        }
    }
}

- (UIColor *)retrieveColorDataWithIdentifier:(TTLDefaultColor)defaultColorType {
    UIColor *obtainedColor = [self.defaultColorDictionary objectForKey:[NSNumber numberWithInteger:defaultColorType]];
    if (obtainedColor != nil) {
        return obtainedColor;
    }
    
    switch (defaultColorType) {
        case TTLDefaultColorPrimaryExtraLight:
        {
            return [TTLUtil getColor:TTL_COLOR_PRIMARY_EXTRA_LIGHT];
            break;
        }
        case TTLDefaultColorPrimaryLight:
        {
            return [TTLUtil getColor:TTL_COLOR_PRIMARY_LIGHT];
            break;
        }
        case TTLDefaultColorPrimary:
        {
            return [TTLUtil getColor:TTL_COLOR_PRIMARY];
            break;
        }
        case TTLDefaultColorPrimaryDark:
        {
            return [TTLUtil getColor:TTL_COLOR_PRIMARY_DARK];
            break;
        }
        case TTLDefaultColorSuccess:
        {
            return [TTLUtil getColor:TTL_COLOR_SUCCESS];
            break;
        }
        case TTLDefaultColorError:
        {
            return [TTLUtil getColor:TTL_COLOR_ERROR];
            break;
        }
        case TTLDefaultColorTextLight:
        {
            return [TTLUtil getColor:TTL_COLOR_TEXT_LIGHT];
            break;
        }
        case TTLDefaultColorTextMedium:
        {
            return [TTLUtil getColor:TTL_COLOR_TEXT_MEDIUM];
            break;
        }
        case TTLDefaultColorTextDark:
        {
            return [TTLUtil getColor:TTL_COLOR_TEXT_DARK];
            break;
        }
        case TTLDefaultColorIconPrimary:
        {
            return [TTLUtil getColor:TTL_COLOR_ICON_PRIMARY];
            break;
        }
        case TTLDefaultColorIconWhite:
        {
            return [TTLUtil getColor:TTL_COLOR_ICON_WHITE];
            break;
        }
        case TTLDefaultColorIconGray:
        {
            return [TTLUtil getColor:TTL_COLOR_ICON_GRAY];
            break;
        }
        case TTLDefaultColorIconSuccess:
        {
            return [TTLUtil getColor:TTL_COLOR_ICON_SUCCESS];
            break;
        }
        case TTLDefaultColorIconDestructive:
        {
            return [TTLUtil getColor:TTL_COLOR_ICON_ERROR];
            break;
        }
            
        default:
        {
            //Set default color to black to prevent crash
            return [TTLUtil getColor:TTL_COLOR_TEXT_DARK];
            break;
        }
    }
}

- (UIColor *)retrieveTextColorDataWithIdentifier:(TTLTextColor)textColorType {
    UIColor *obtainedTextColor = [self.textColorDictionary objectForKey:[NSNumber numberWithInteger:textColorType]];
    if (obtainedTextColor != nil) {
        return obtainedTextColor;
    }
    
    switch (textColorType) {
        case TTLTextColorTitleLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorNavigationBarTitleLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorNavigationBarButtonLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorFormLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorFormDescriptionLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorFormErrorInfoLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorError];
            return color;
            break;
        }
        case TTLTextColorFormTextField: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorFormTextFieldPlaceholder: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorClickableLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorClickableDestructiveLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorError];
            return color;
            break;
        }
        case TTLTextColorButtonLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorInfoLabelTitle: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorInfoLabelSubtitle: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorInfoLabelSubtitleBold: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorInfoLabelBody: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorInfoLabelBodyBold: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorKeyboardAccessoryLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorPopupLoadingLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorSearchConnectionLostTitle: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorSearchConnectionLostDescription: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorUnreadBadgeLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorSearchBarText: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorSearchBarTextPlaceholder: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorSearchBarTextCancelButton: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorPopupDialogTitle: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorPopupDialogBody: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorPopupDialogButtonTextPrimary: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorPopupDialogButtonTextSecondary: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorActionSheetDefaultLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorActionSheetDestructiveLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorError];
            return color;
            break;
        }
        case TTLTextColorActionSheetCancelButtonLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorTableViewSectionHeaderLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorContactListName: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorContactListNameHighlighted: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorContactListUsername: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorMediaListInfoLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorRoomListName: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorRoomListNameHighlighted: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorRoomListMessage: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorRoomListMessageHighlighted: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorRoomListTime: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorGroupRoomListSenderName: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorRoomListUnreadBadgeLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorNewChatMenuLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorChatProfileRoomNameLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorChatProfileMenuLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorChatProfileMenuDestructiveLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorError];
            return color;
            break;
        }
        case TTLTextColorSearchNewContactResultName: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorSearchNewContactResultUsername: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorAlbumNameLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorAlbumCountLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorGalleryPickerCancelButton: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorGalleryPickerContinueButton: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorChatRoomNameLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorChatRoomStatusLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorChatComposerTextField: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorChatComposerTextFieldPlaceholder: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorCustomKeyboardItemLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorQuoteLayoutTitleLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorQuoteLayoutContentLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorRightBubbleMessageBody: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorLeftBubbleMessageBody: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorRightBubbleMessageBodyURL: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorLeftBubbleMessageBodyURL: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorRightBubbleMessageBodyURLHighlighted: {
            UIColor *color = [TTLUtil getColor:@"5AC8FA"];
            return color;
            break;
        }
        case TTLTextColorLeftBubbleMessageBodyURLHighlighted: {
            UIColor *color = [TTLUtil getColor:@"5AC8FA"];
            return color;
            break;
        }
        case TTLTextColorRightBubbleDeletedMessageBody: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorLeftBubbleDeletedMessageBody: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorRightBubbleQuoteTitle: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorLeftBubbleQuoteTitle: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorRightBubbleQuoteContent: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorLeftBubbleQuoteContent: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorRightFileBubbleName: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorLeftFileBubbleName: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorRightFileBubbleInfo: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorLeftFileBubbleInfo: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorLeftBubbleSenderName: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorBubbleMessageStatus: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorBubbleMediaInfo: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorSystemMessageBody: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorChatRoomUnreadBadge: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorUnreadMessageIdentifier: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorUnreadMessageButtonLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorDeletedChatRoomInfoTitleLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorDeletedChatRoomInfoContentLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorLocationPickerTextField: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorLocationPickerTextFieldPlaceholder: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorLocationPickerClearButton: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorLocationPickerSearchResult: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorLocationPickerAddress: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorLocationPickerAddressPlaceholder: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorLocationPickerSendLocationButton: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorMediaPreviewCancelButton: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorMediaPreviewItemCount: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorMediaPreviewCaption: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorMediaPreviewCaptionPlaceholder: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorMediaPreviewCaptionLetterCount: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorMediaPreviewSendButtonLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorMediaPreviewWarningTitle: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorMediaPreviewWarningBody: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorImageDetailSenderName: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorImageDetailMessageStatus: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorImageDetailCaption: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorCustomNotificationTitleLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorCustomNotificationContentLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorSelectedMemberListName: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLComponentFontGroupMemberCount: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorCountryPickerLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorLoginVerificationInfoLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorLoginVerificationPhoneNumberLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorLoginVerificationStatusCountdownLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        case TTLTextColorLoginVerificationStatusLoadingLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorLoginVerificationStatusSuccessLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorSuccess];
            return color;
            break;
        }
        case TTLTextColorLoginVerificationCodeInputLabel: {
            UIColor *color = [TTLUtil getColor:@"191919"];
            return color;
            break;
        }
        case TTLTextColorSearchClearHistoryLabel: {
            UIColor *color = [TTLUtil getColor:@"9B9B9B"];
            return color;
            break;
        }
        case TTLTextColorCreateGroupSubjectLoadingLabel: {
            UIColor *color = [TTLUtil getColor:@"9B9B9B"];
            return color;
            break;
        }
        case TTLTextColorCustomWebViewNavigationTitleLabel: {
            UIColor *color = [TTLUtil getColor:@"191919"];
            return color;
            break;
        }
        case TTLTextColorRoomAvatarSmallLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorRoomAvatarMediumLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorRoomAvatarLargeLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorRoomAvatarExtraLargeLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLTextColorTopicListLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLTextColorTopicListLabelSelected: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLTextColorRatingBodyLabel: {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        default: {
            //Set default color to black to prevent crash
            UIColor *color = [TTLUtil getColor:@"9B9B9B"];
            return color;
            break;
        }
    }
}

- (UIColor *)retrieveComponentColorDataWithIdentifier:(TTLComponentColor)componentType {
    UIColor *obtainedComponentColor = [self.componentColorDictionary objectForKey:[NSNumber numberWithInteger:componentType]];
    if (obtainedComponentColor != nil) {
        return obtainedComponentColor;
    }
    
    switch (componentType) {
        case TTLComponentColorDefaultNavigationBarBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_DEFAULT_NAVIGATION_BAR_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorDefaultBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_DEFAULT_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorTextFieldCursor:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorTextFieldBorderActive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;

        }
        case TTLComponentColorTextFieldBorderInactive:
        {
            UIColor *color = [TTLUtil getColor:TTL_TEXTFIELD_BORDER_INACTIVE_COLOR];
            return color;
            break;

        }
        case TTLComponentColorTextFieldBorderError:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorError];
            return color;
            break;

        }
        case TTLComponentColorButtonActiveBackgroundGradientLight:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimaryLight];
            return color;
            break;

        }
        case TTLComponentColorButtonActiveBackgroundGradientDark:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimaryDark];
            return color;
            break;
        }
        case TTLComponentColorButtonActiveBorder:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorButtonInactiveBackgroundGradientLight:
        {
            UIColor *color = [TTLUtil getColor:TTL_BUTTON_INACTIVE_BACKGROUND_GRADIENT_LIGHT_COLOR];
            return color;
            break;
        }
        case TTLComponentColorButtonInactiveBackgroundGradientDark:
        {
            UIColor *color = [TTLUtil getColor:TTL_BUTTON_INACTIVE_BACKGROUND_GRADIENT_DARK_COLOR];
            return color;
            break;
        }
        case TTLComponentColorButtonInactiveBorder:
        {
            UIColor *color = [TTLUtil getColor:TTL_BUTTON_INACTIVE_BORDER_COLOR];
            return color;
            break;
        }
        case TTLComponentColorButtonDestructiveBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorError];
            return color;
            break;
        }
        case TTLComponentColorSwitchActiveBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorSwitchInactiveBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_SWITCH_INACTIVE_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorPopupDialogPrimaryButtonSuccessBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorSuccess];
            return color;
            break;
        }
        case TTLComponentColorPopupDialogPrimaryButtonErrorBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorError];
            return color;
            break;
        }
        case TTLComponentColorPopupDialogSecondaryButtonBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_POPUP_DIALOG_SECONDARY_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorUnreadBadgeBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorUnreadBadgeInactiveBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_UNREAD_BADGE_INACTIVE_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorTableViewSectionIndex:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorSearchBarBorderActive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorSearchBarBorderInactive:
        {
            UIColor *color = [TTLUtil getColor:TTL_SEARCHBAR_BORDER_INACTIVE_COLOR];
            return color;
            break;
        }
        case TTLComponentColorRoomListUnreadBadgeBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorRoomListUnreadBadgeInactiveBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_UNREAD_BADGE_INACTIVE_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorChatRoomUnreadBadgeBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorChatRoomUnreadBadgeInactiveBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_UNREAD_BADGE_INACTIVE_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorQuoteLayoutDecorationBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimaryExtraLight];
            return color;
            break;
        }
        case TTLComponentColorLeftBubbleBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_LEFT_BUBBLE_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorRightBubbleBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorLeftBubbleQuoteBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_LEFT_BUBBLE_QUOTE_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorRightBubbleQuoteBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimaryDark];
            return color;
            break;
        }
        case TTLComponentColorLeftFileButtonBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorRightFileButtonBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimaryDark];
            return color;
            break;
        }
        case TTLComponentColorSystemMessageBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_SYSTEM_MESSAGE_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorSystemMessageBackgroundShadow:
        {
            UIColor *color = [TTLUtil getColor:TTL_SYSTEM_MESSAGE_BACKGROUND_SHADOW_COLOR];
            return color;
            break;
        }
        case TTLComponentColorFileProgressBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_FILE_PROGRESS_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorDeletedChatRoomInfoBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_DELETED_CHAT_ROOM_INFO_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorChatComposerBackground:
        {
            UIColor *color = [TTLUtil getColor:TTL_CHAT_COMPOSER_BACKGROUND_COLOR];
            return color;
            break;
        }
        case TTLComponentColorUnreadIdentifierBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorSelectedMediaPreviewThumbnailBorder:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorMediaPreviewWarningBackgroundColor:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorError];
            return color;
            break;
        }
        case TTLComponentColorSearchConnectionLostBackgroundColor:
        {
            UIColor *color = [TTLUtil getColor:TTL_SEARCH_CONNECTION_LOST_BACKGROUND_COLOR];
            return color;
            break;
        }
//ICON
//General
        case TTLComponentColorButtonIcon:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextLight];
            return color;
            break;
        }
        case TTLComponentColorButtonIconPrimary:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
            return color;
            break;
        }
        case TTLComponentColorButtonIconDestructive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconDestructive];
            return color;
            break;
        }
        case TTLComponentColorIconMessageSending:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconMessageFailed:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconMessageSent:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconMessageDelivered:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconMessageRead:
        {
            UIColor *color = [TTLUtil getColor:@"19C700"];
            return color;
            break;
        }
        case TTLComponentColorIconMessageDeleted:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconRemoveItem:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconRemoveItemBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconDestructive];
            return color;
            break;
        }
        case TTLComponentColorIconLoadingProgressPrimary:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconLoadingProgressWhite:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconChevronRightPrimary:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconChevronRightGray:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconChecklist:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconLoadingPopupSuccess:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconSearchConnectionLost:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLComponentColorIconCircleSelectionActive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconCircleSelectionInactive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
//Navigation Bar
        case TTLComponentColorIconNavigationBarBackButton:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconTransparentBackgroundBackButton:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconNavigationBarCloseButton:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconClearTextButton:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconSearchBarMagnifier:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
//Action Sheet
        case TTLComponentColorIconActionSheetDocument:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetCamera:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetGallery:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetLocation:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetComposeEmail:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetCopy:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetOpen:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetSMS:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetCall:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetReply:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetForward:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconActionSheetTrash:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconDestructive];
            return color;
            break;
        }
//Register
        case TTLComponentColorIconViewPasswordActive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconViewPasswordInactive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconChangePicture:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconSelectPictureCamera:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconSelectPictureGallery:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
//Chat Room
        case TTLComponentColorIconChatRoomCancelQuote:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconCancelUploadDownload:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconChatComposerSend:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconChatComposerSendInactive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconChatComposerBurgerMenu:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconChatComposerShowKeyboard:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconChatComposerSendBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconChatComposerSendBackgroundInactive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconDeletedLeftMessageBubble:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconDeletedRightMessageBubble:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconUserStatusActive:
        {
            UIColor *color = [TTLUtil getColor:@"19C700"];
            return color;
            break;
        }
        case TTLComponentColorIconLocationBubbleMarker:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconQuotedFileBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconDeletedChatRoom:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconChatRoomScrollToBottomBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconChatRoomScrollToBottom:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconChatRoomUnreadButton:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconChatRoomFloatingUnreadButton:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconChatComposerBurgerMenuBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconChatComposerShowKeyboardBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconChatComposerAttach:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconFile:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconFileUploadDownload:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconFileCancelUploadDownload:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconFileRetryUploadDownload:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconFilePlayMedia:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
    //Room List
        case TTLComponentColorIconStartNewChatButton:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconRoomListMuted:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
    //Room List Setup
        case TTLComponentColorIconRoomListSettingUp:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconRoomListSetUpSuccess:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconSuccess];
            return color;
            break;
        }
        case TTLComponentColorIconRoomListSetUpFailure:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconDestructive];
            return color;
            break;
        }
        case TTLComponentColorIconRoomListRetrySetUpButton:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
    //New Chat page
        case TTLComponentColorIconMenuNewContact:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconMenuScanQRCode:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconMenuNewGroup:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
    //Chat / Group Profile
        case TTLComponentColorIconChatProfileMenuNotificationActive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconChatProfileMenuNotificationInactive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconChatProfileMenuConversationColor:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconChatProfileMenuBlockUser:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconChatProfileMenuSearchChat:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconChatProfileMenuClearChat:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconDestructive];
            return color;
            break;
        }
        case TTLComponentColorIconGroupProfileMenuViewMembers:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconGroupMemberProfileMenuAddToContacts:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconGroupMemberProfileMenuSendMessage:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconGroupMemberProfileMenuPromoteAdmin:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconGroupMemberProfileMenuDemoteAdmin:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconGray];
            return color;
            break;
        }
        case TTLComponentColorIconGroupMemberProfileMenuRemoveMember:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconDestructive];
            return color;
            break;
        }
    //Media / Image Detail Preview
        case TTLComponentColorIconMediaPreviewAdd:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconMediaPreviewWarning:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconMediaPreviewThumbnailWarning:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconMediaPreviewThumbnailWarningBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconDestructive];
            return color;
            break;
        }
        case TTLComponentColorIconSaveImage:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconMediaListVideo:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
    //Scan Result
        case TTLComponentColorIconCloseScanResult:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconCloseScanResultBackground:
        {
            UIColor *color = [[TTLUtil getColor:@"04040F"] colorWithAlphaComponent:0.5f];
            return color;
            break;
        }
    //Location Picker
        case TTLComponentColorIconLocationPickerMarker:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconLocationPickerRecenter:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconLocationPickerRecenterBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconLocationPickerSendLocation:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite];
            return color;
            break;
        }
        case TTLComponentColorIconLocationPickerSendLocationBackground:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary];
            return color;
            break;
        }
        case TTLComponentColorIconLocationPickerAddressActive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextDark];
            return color;
            break;
        }
        case TTLComponentColorIconLocationPickerAddressInactive:
        {
            UIColor *color = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorTextMedium];
            return color;
            break;
        }
        default: {
            //Set default color to black to prevent crash
            UIColor *color = [TTLUtil getColor:@"9B9B9B"];
            return color;
            break;
        }
    }
}

- (UIColor *)getRandomDefaultAvatarBackgroundColorWithName:(NSString *)name {
    if (name == nil || [name isEqualToString:@""]) {
        UIColor *color = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_1];
        return color;
    }
    
    char *charString = [name UTF8String];
    NSInteger lastIndex = [name length] - 1;
    NSInteger firstCharInt = charString[0] - '0';
    NSInteger lastCharInt = charString[lastIndex] - '0';
    
    //DV Note - 8 is total number of random colors, needs to change it if added or deleted
    NSInteger obtainedIndex = (firstCharInt + lastCharInt) % 8;
    
    UIColor *resultColor = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_1];
    switch (obtainedIndex) {
        case 0:
        {
            resultColor = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_1];
            break;
        }
        case 1:
        {
            resultColor = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_2];
            break;
        }
        case 2:
        {
            resultColor = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_3];
            break;
        }
        case 3:
        {
            resultColor = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_4];
            break;
        }
        case 4:
        {
            resultColor = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_5];
            break;
        }
        case 5:
        {
            resultColor = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_6];
            break;
        }
        case 6:
        {
            resultColor = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_7];
            break;
        }
        case 7:
        {
            resultColor = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_8];
            break;
        }
        default: {
            resultColor = [TTLUtil getColor:TTL_AVATAR_BACKGROUND_COLOR_1];
            break;
        }
    }
    
    return resultColor;
}

- (NSString *)getInitialsWithName:(NSString *)name isGroup:(BOOL)isGroup {
    NSMutableString *displayString = [NSMutableString stringWithString:@""];
    NSMutableArray *words = [[name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
    if ([words count]) {
        NSString *firstWord = [words firstObject];
        if ([firstWord length]) {
            // Get character range to handle emoji (emojis consist of 2 characters in sequence)
            NSRange firstLetterRange = [firstWord rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)];
            [displayString appendString:[firstWord substringWithRange:firstLetterRange]];
        }
        
        if (isGroup) {
            return displayString;
        }
        
        if ([words count] >= 2) {
            NSString *lastWord = [words lastObject];
            
            while ([lastWord length] == 0 && [words count] >= 2) {
                [words removeLastObject];
                lastWord = [words lastObject];
            }
            
            if ([words count] > 1) {
                // Get character range to handle emoji (emojis consist of 2 characters in sequence)
                NSRange lastLetterRange = [lastWord rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)];
                [displayString appendString:[lastWord substringWithRange:lastLetterRange]];
            }
        }
        
        return displayString;
    }
    
    return displayString;
}

@end
