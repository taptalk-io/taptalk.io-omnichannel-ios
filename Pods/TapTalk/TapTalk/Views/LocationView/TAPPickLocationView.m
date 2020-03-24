//
//  TAPPickLocationView.m
//  TapTalk
//
//  Created by Dominic Vedericho on 15/02/19.
//  Copyright © 2019 Moselo. All rights reserved.
//

#import "TAPPickLocationView.h"

@interface TAPPickLocationView ()

@property (strong, nonatomic) UIView *addressView;
@property (strong, nonatomic) UIView *mapContainerView;
@property (strong, nonatomic) UIImageView *addressIconImageView;
@property (strong, nonatomic) UIImageView *pinIconImageView;
@property (strong, nonatomic) UILabel *addressLabel;

@end

@implementation TAPPickLocationView
#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat additionalBottomSpacing = 0.0f;
        if (IS_IPHONE_X_FAMILY) {
            additionalBottomSpacing = [TAPUtil safeAreaBottomPadding];
        }
        
        _addressView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(frame) - (152.0f + additionalBottomSpacing), CGRectGetWidth(frame), 152.0f + additionalBottomSpacing)];
        self.addressView.backgroundColor = [UIColor whiteColor];
        self.addressView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
        self.addressView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.addressView.layer.shadowOpacity = 0.18f;
        [self addSubview:self.addressView];
        
        _addressIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 32.0f, 32.0f)];
        self.addressIconImageView.image = [UIImage imageNamed:@"TAPIconLocation" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        self.addressIconImageView.image = [self.addressIconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconLocationPickerAddressInactive]];
        [self.addressView addSubview:self.addressIconImageView];
        
        UIFont *placeholderLabelFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontLocationPickerAddressPlaceholder];
        UIColor *placeholderLabelColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorLocationPickerAddressPlaceholder];
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.addressIconImageView.frame) + 8.0f, 20.0f, CGRectGetWidth(self.addressView.frame) - (CGRectGetMaxX(self.addressIconImageView.frame) + 8.0f) - 16.0f, 64.0f)];
        self.addressLabel.font = placeholderLabelFont;
        self.addressLabel.textColor = placeholderLabelColor;
        self.addressLabel.numberOfLines = 0;
        [self.addressView addSubview:self.addressLabel];
        
        _sendLocationButton = [[TAPCustomButtonView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.addressLabel.frame) + 12.0f, CGRectGetWidth(self.frame), 44.0f)];
        [self.sendLocationButton setCustomButtonViewStyleType:TAPCustomButtonViewStyleTypeWithIcon];
        [self.sendLocationButton setCustomButtonViewType:TAPCustomButtonViewTypeInactive];
        [self.sendLocationButton setButtonWithTitle:NSLocalizedStringFromTableInBundle(@"Send Location", nil, [TAPUtil currentBundle], @"") andIcon:@"TAPIconSend" iconPosition:TAPCustomButtonViewIconPosititonLeft];
        [self.sendLocationButton setButtonIconTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorButtonIcon]];
        [self.addressView addSubview:self.sendLocationButton];
        
        _mapContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame) - CGRectGetHeight(self.addressView.frame))];
        [self addSubview:self.mapContainerView];
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.mapContainerView.frame), CGRectGetHeight(self.mapContainerView.frame))];
        [self.mapView setShowsUserLocation:YES];
        [self.mapView setShowsPointsOfInterest:YES];
        [self.mapView setShowsBuildings:YES];
        self.mapView.autoresizingMask = UIViewAutoresizingNone;
        [self.mapContainerView addSubview:self.mapView];
        
        _goToCurrentLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 16.0f - 56.0f, CGRectGetHeight(frame) - CGRectGetHeight(self.addressView.frame) - 16.0f - 56.0f, 56.0f, 56.0f)];
        self.goToCurrentLocationButton.backgroundColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconLocationPickerRecenterBackground];
        self.goToCurrentLocationButton.layer.cornerRadius = CGRectGetHeight(self.goToCurrentLocationButton.frame) / 2.0f;
        self.goToCurrentLocationButton.layer.shadowOffset = CGSizeMake(0.0f, 6.0f);
        self.goToCurrentLocationButton.layer.shadowColor = [UIColor blackColor].CGColor;
        self.goToCurrentLocationButton.layer.shadowRadius = 6.0f;
        self.goToCurrentLocationButton.layer.shadowOpacity = 0.24f;
        
        UIImage *getLocationImage = [UIImage imageNamed:@"TAPIconGetLocation" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        getLocationImage = [getLocationImage setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconLocationPickerRecenter]];

        [self.goToCurrentLocationButton setImage:getLocationImage forState:UIControlStateNormal];
        [self addSubview:self.goToCurrentLocationButton];
        
        _searchBarView = [[TAPLocationSearchBarView alloc] initWithFrame:CGRectMake(16.0f, 16.0f, CGRectGetWidth(frame) - 16.0f - 16.0f, 36.0f)];
        self.searchBarView.placeholder = NSLocalizedStringFromTableInBundle(@"Search Address", nil, [TAPUtil currentBundle], @"");
        self.searchBarView.leftViewImage = [UIImage imageNamed:@"TAPIconSearch" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        self.searchBarView.leftViewImage = [self.searchBarView.leftViewImage setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconSearchBarMagnifier]];

        [self.searchBarView setReturnKeyType:UIReturnKeySearch];
        [self addSubview:self.searchBarView];
        
        _pinIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.mapView.frame) - 36.0f) / 2.0f, (CGRectGetHeight(self.mapView.frame) / 2.0f) - 32.0f - 5.0f, 36.0f, 57.0f)]; //32.0 is height of icon without shadow and 5.0f is top shadow of the icon. meanwhile 47 is height of icon with shadow
        self.pinIconImageView.image = [UIImage imageNamed:@"TAPIconLocationSelect" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        self.pinIconImageView.image = [self.pinIconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconLocationPickerMarker]];
        
        [self addSubview:self.pinIconImageView];
        
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.searchBarView.frame), CGRectGetMaxY(self.searchBarView.frame) + 5.0f, CGRectGetWidth(self.searchBarView.frame), 0.0f)];
        self.searchTableView.showsVerticalScrollIndicator = NO;
        self.searchTableView.showsHorizontalScrollIndicator = NO;
        self.searchTableView.layer.borderColor = [TAPUtil getColor:TAP_COLOR_GREY_DC].CGColor;
        self.searchTableView.layer.borderWidth = 1.0f;
        self.searchTableView.layer.cornerRadius = 10.0f;
        [self.searchTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        _searchTableViewShadowView = [[UIView alloc] initWithFrame:self.searchTableView.frame]; //this is to show shadow of searchTableView
        self.searchTableViewShadowView.backgroundColor = [UIColor whiteColor];
        self.searchTableViewShadowView.layer.cornerRadius = 10.0f;
        self.searchTableViewShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.searchTableViewShadowView.layer.shadowOpacity = 0.1f;
        self.searchTableViewShadowView.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
        self.searchTableViewShadowView.layer.shadowRadius = 12.0f;
        
        [self addSubview:self.searchTableViewShadowView];
        [self addSubview:self.searchTableView];
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)setAsLoading:(BOOL)isLoading {
    
    UIColor *addressColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorLocationPickerAddress];
    UIColor *placeholderColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorLocationPickerAddressPlaceholder];
    
    if (isLoading) {
        NSString *addressString = NSLocalizedStringFromTableInBundle(@"Searching for address", nil, [TAPUtil currentBundle], @"");
        self.addressLabel.text = addressString;
        NSMutableAttributedString *addressAttributedString = [[NSMutableAttributedString alloc] initWithString:self.addressLabel.text];
        NSMutableParagraphStyle *addressLabelStyle = [[NSMutableParagraphStyle alloc] init];
        addressLabelStyle.maximumLineHeight = 16.0f;
        addressLabelStyle.minimumLineHeight = 16.0f;
        [addressAttributedString addAttribute:NSParagraphStyleAttributeName
                                        value:addressLabelStyle
                                        range:NSMakeRange(0, [self.addressLabel.text length])];
        self.addressLabel.attributedText = addressAttributedString;
        self.addressLabel.textColor = placeholderColor;
        CGSize addressLabelSize = [self.addressLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.addressLabel.frame), CGFLOAT_MAX)];
        self.addressLabel.frame = CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMinY(self.addressLabel.frame), CGRectGetWidth(self.addressLabel.frame), addressLabelSize.height);
        
        self.addressIconImageView.image = [UIImage imageNamed:@"TAPIconLocation" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        self.addressIconImageView.image = [self.addressIconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconLocationPickerAddressInactive]];
    }
    else {
        self.addressLabel.textColor = addressColor;
        self.addressIconImageView.image = [UIImage imageNamed:@"TAPIconLocation" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        self.addressIconImageView.image = [self.addressIconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconLocationPickerAddressActive]];
    }
}

- (void)setAddress:(NSString *)addressString {
    
    UIColor *addressLabelColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorLocationPickerAddress];
    self.addressLabel.textColor = addressLabelColor;
    self.addressIconImageView.image = [UIImage imageNamed:@"TAPIconLocation" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
    self.addressIconImageView.image = [self.addressIconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconLocationPickerAddressActive]];
    
    self.addressLabel.text = addressString;
    NSMutableAttributedString *addressAttributedString = [[NSMutableAttributedString alloc] initWithString:self.addressLabel.text];
    NSMutableParagraphStyle *addressLabelStyle = [[NSMutableParagraphStyle alloc] init];
    addressLabelStyle.maximumLineHeight = 16.0f;
    addressLabelStyle.minimumLineHeight = 16.0f;
    [addressAttributedString addAttribute:NSParagraphStyleAttributeName
                                    value:addressLabelStyle
                                    range:NSMakeRange(0, [self.addressLabel.text length])];
    self.addressLabel.attributedText = addressAttributedString;
    
    CGSize addressLabelSize = [self.addressLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.addressLabel.frame), CGFLOAT_MAX)];
    CGFloat addressLabelHeight = addressLabelSize.height;
    if (addressLabelHeight > 64.0f) {
        addressLabelHeight = 64.0f;
    }
    self.addressLabel.frame = CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMinY(self.addressLabel.frame), CGRectGetWidth(self.addressLabel.frame), addressLabelHeight);
}

@end
