//
//  HIUIPropertyPicker.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HIPropertyPickerSelectedBlock) (NSString * value ,NSUInteger index);

@interface HIUIPropertyPicker : UIView

@property(strong, nonatomic) UIToolbar       *toolbar;
@property(strong, nonatomic) UIPickerView    *picker;
@property(strong, nonatomic) UIButton        *sureButton;
@property(strong, nonatomic) UIButton        *cancelButton;

@property(nonatomic, strong) NSArray         *propertyArray;
@property(nonatomic, copy) HIPropertyPickerSelectedBlock selectedAction;
@property(nonatomic, copy) HIPropertyPickerSelectedBlock canceledAction;

-(id)initWithPropertArray:(NSArray *)propertyArray;

-(void) show;
-(void) hide;
-(int) getCurIndex;

@end
