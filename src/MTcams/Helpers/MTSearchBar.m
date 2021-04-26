//
//  MTSearchBar.m
//  MTcams
//
//  Created by Milovan Tomasevic on 09/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MTSearchBar.h"

@implementation MTSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
 // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        /*
         Default SearchBar appearance
         */
        self.frame = CGRectMake(self.origin.x, self.origin.y, self.size.width, self.size.height);
        //background
        self.backgroundColor = [UIColor whiteColor];
        //style and color
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.searchBarStyle = UISearchBarStyleProminent;
        self.barTintColor = [UIColor clearColor];
        self.tintColor = [UIColor orangeColor];
        self.placeholder = NSLocalizedString(@"search",nil);
    }
    return self;
}

/*
 INTERFACE
 @property(nonatomic) BOOL searchMode;
 @property(nonatomic, strong) NSMutableArray *OptionsList;
 
 
 DID_LOAD
 searchResults = _OptionsList;
 _searchMode = NO;
 
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _searchMode = YES;
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _searchMode = YES;
    [self filterContentForSearchText:_searchBar.text scope:nil];
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        searchResults = _userOptionsList;
        [_usersTableView reloadData];
        _searchMode = NO;
    } else {
        _searchMode = YES;
        [self filterContentForSearchText:_searchBar.text scope:nil];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.view endEditing:YES];
}

#pragma mark - Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    searchResults = [_userOptionsList filteredArrayUsingPredicate:resultPredicate];
    [_usersTableView reloadData];
}
*/

@end

