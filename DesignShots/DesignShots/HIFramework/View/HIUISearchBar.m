//
//  HIUISearchBar.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUISearchBar.h"
#import "HIPrecompile.h"

@interface HIUISearchBar () <UISearchBarDelegate>


@end

@implementation HIUISearchBar

-(void) dealloc
{
    self.shouldBeginEditingBlock = nil;
    self.textDidBeginEditingBlock = nil;
    self.textDidEndEditingBlock = nil;
    self.textDidChangedBlock = nil;
    self.searchButtonClickedBlock = nil;
    self.bookmarkButtonClickedBlock = nil;
    self.cancelButtonClickedBlock = nil;
    self.resultsListButtonClickedBlock = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (IOS7_OR_LATER) {
            
        }else{
            
            for (UIView *subview in  self.subviews) {
                if ([subview isKindOfClass: NSClassFromString ( @"UISearchBarBackground" )]) {
                    [subview removeFromSuperview];
                    break ;
                }
            }
        }
        
        self.delegate = self;
    }
    
    return self;
}

-(void) removeFromSuperview
{
    [super removeFromSuperview];
}

- (void)searchBarTextDidBeginEditing:(HIUISearchBar *)searchBar
{
    if (self.textDidBeginEditingBlock) {
        self.textDidBeginEditingBlock(searchBar);
    }
}


- (BOOL)searchBarShouldBeginEditing:(HIUISearchBar *)searchBar
{
    if (self.shouldBeginEditingBlock) {
        return self.shouldBeginEditingBlock(searchBar);
    }
    
    return YES;
}


/*
 - (BOOL)searchBarShouldEndEditing:(HIUISearchBar *)searchBar
 {
 return YES;
 }
 */

- (void)searchBarTextDidEndEditing:(HIUISearchBar *)searchBar
{
    if (self.textDidEndEditingBlock) {
        self.textDidEndEditingBlock(searchBar);
    }
}

- (void)searchBar:(HIUISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.textDidChangedBlock) {
        self.textDidChangedBlock(searchBar,searchText);
    }
}

/*
 - (BOOL)searchBar:(HIUISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
 {
 return YES;
 }
 */

- (void)searchBarSearchButtonClicked:(HIUISearchBar *)searchBar
{
    if (self.searchButtonClickedBlock) {
        self.searchButtonClickedBlock(searchBar);
    }
}

- (void)searchBarBookmarkButtonClicked:(HIUISearchBar *)searchBar
{
    if (self.bookmarkButtonClickedBlock) {
        self.bookmarkButtonClickedBlock(searchBar);
    }
}

- (void)searchBarCancelButtonClicked:(HIUISearchBar *) searchBar
{
    if (self.cancelButtonClickedBlock) {
        self.cancelButtonClickedBlock(searchBar);
    }
}

- (void)searchBarResultsListButtonClicked:(HIUISearchBar *)searchBar
{
    if (self.resultsListButtonClickedBlock) {
        self.resultsListButtonClickedBlock(searchBar);
    }
}


@end
