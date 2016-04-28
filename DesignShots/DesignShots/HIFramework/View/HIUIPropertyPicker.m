//
//  HIUIPropertyPicker.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIPropertyPicker.h"
#import "HIPrecompile.h"

@interface HIUIPropertyPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL _added;
    
    UIButton * _cancelTopButton;
}

@end

@implementation HIUIPropertyPicker

-(void) dealloc
{
    self.selectedAction = nil;
    self.canceledAction = nil;
}

- (id)initWithPropertArray:(NSArray *)propertyArray
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self = [super initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height + 20)];
    if (self) {
        [self initSelf:CGRectMake(0, 0, screenSize.width, screenSize.height + 20)];
        self.propertyArray = propertyArray;
    }
    return self;
}

-(id) init
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self = [super initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height+20)];
    if (self) {
        [self initSelf:CGRectMake(0, 0, screenSize.width, screenSize.height+20)];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf:frame];
    }
    return self;
}

-(void) initSelf:(CGRect)frame
{
    _cancelTopButton = [HIUIButton buttonWithType:UIButtonTypeCustom];
    _cancelTopButton.frame = CGRectMake(0, 0, 320, frame.size.height);
    [_cancelTopButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelTopButton];
    
    self.picker = [[UIPickerView alloc] init];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor whiteColor];
    self.picker.showsSelectionIndicator = YES;
    [self addSubview:self.picker];
    
    self.picker.frame = CGRectMake(0, self.frame.size.height - _picker.frame.size.height, self.frame.size.width, _picker.frame.size.height);
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
    _toolbar.backgroundColor = [UIColor colorWithRed:248./255. green:248./255. blue:248./255. alpha:1];
    [self addSubview:_toolbar];
    
    
    self.cancelButton = [[HIUIButton alloc] init];
    self.cancelButton.frame = CGRectMake(0, 0, 61, 42);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];

    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar addSubview:self.cancelButton];
    
    self.sureButton = [[HIUIButton alloc] init];
    self.sureButton.frame = CGRectMake(frame.size.width-61, 0, 61, 42);
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar addSubview:self.sureButton];
}

-(void) setPropertyArray:(NSArray *)propertyArray
{
    if (propertyArray != _propertyArray) {
        _propertyArray = propertyArray;
    }
    
    [self.picker reloadAllComponents];
}

- (void) show
{
    if (_added) {
        return;
    }
    
    _added = YES;
    
    UIView * keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.alpha = 0;
    
    self.frame = CGRectMake(0, 0, keyWindow.frame.size.width, keyWindow.frame.size.height);
    self.picker.frame = CGRectMake(0, self.frame.size.height - self.picker.frame.size.height, self.frame.size.width, self.picker.frame.size.height);
    self.toolbar.frame = CGRectMake(0, keyWindow.frame.size.height - self.picker.frame.size.height-self.toolbar.frame.size.height, self.frame.size.width, self.toolbar.frame.size.height);
    _cancelTopButton.frame = CGRectMake(0, 0, keyWindow.frame.size.width, self.toolbar.frame.origin.y);
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    }];
}

-(void) hide
{
    if (!_added) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        _added = NO;
        [self removeFromSuperview];
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.propertyArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.propertyArray[row];
}

-(void) cancelAction
{
    if (self.canceledAction){
        self.canceledAction(nil,0);
    }
    
    [self hide];
}

-(void) sureAction
{
    if (self.selectedAction) {
        NSUInteger selectRow = [self.picker selectedRowInComponent:0];
        self.selectedAction(self.propertyArray[selectRow], selectRow);
    }
    
    [self hide];
}

-(int) getCurIndex
{
     NSUInteger selectRow = [self.picker selectedRowInComponent:0];
    return (int)selectRow;
}
@end
