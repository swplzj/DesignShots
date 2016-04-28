//
//  HIUITextView.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HIUITextView;

typedef void (^HITextViewDidBeginEditing)(HIUITextView * textView);
typedef void (^HITextViewChanged)(HIUITextView * textView);
typedef void (^HITextViewDidEndEditing)(HIUITextView * textView);

@interface HIUITextView : UITextView

@property(nonatomic,assign) float placeholderLabelOffsetY;
@property(nonatomic,retain) NSString * placeholder;
@property(nonatomic,copy) HITextViewDidBeginEditing beginEditing;
@property(nonatomic,copy) HITextViewChanged changed;
@property(nonatomic,copy) HITextViewDidEndEditing endEditing;

@end
