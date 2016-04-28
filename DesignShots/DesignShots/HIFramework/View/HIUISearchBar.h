//
//  HIUISearchBar.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HIUISearchBar;

typedef BOOL (^HISearchBarShouldBeginEditingBlock)( HIUISearchBar * searchBar );
typedef void (^HISearchBarTextDidBeginEditingBlock)( HIUISearchBar * searchBar );
typedef void (^HISearchBarTextDidEndEditingBlock)( HIUISearchBar * searchBar );
typedef void (^HISearchBarTextDidChangedBlock)( HIUISearchBar * searchBar, NSString * searchText );
typedef void (^HISearchBarSearchButtonClickedBlock)( HIUISearchBar * searchBar );
typedef void (^HISearchBarBookmarkButtonClickedBlock)( HIUISearchBar * searchBar );
typedef void (^HISearchBarCancelButtonClickedBlock)( HIUISearchBar * searchBar );
typedef void (^HISearchBarResultsListButtonClickedBlock)( HIUISearchBar * searchBar );

@interface HIUISearchBar : UISearchBar

@property (nonatomic,copy) HISearchBarShouldBeginEditingBlock shouldBeginEditingBlock;
@property (nonatomic,copy) HISearchBarTextDidBeginEditingBlock textDidBeginEditingBlock;
@property (nonatomic,copy) HISearchBarTextDidEndEditingBlock textDidEndEditingBlock;
@property (nonatomic,copy) HISearchBarTextDidChangedBlock textDidChangedBlock;
@property (nonatomic,copy) HISearchBarSearchButtonClickedBlock searchButtonClickedBlock;
@property (nonatomic,copy) HISearchBarBookmarkButtonClickedBlock bookmarkButtonClickedBlock;
@property (nonatomic,copy) HISearchBarCancelButtonClickedBlock cancelButtonClickedBlock;
@property (nonatomic,copy) HISearchBarResultsListButtonClickedBlock resultsListButtonClickedBlock;

@end
