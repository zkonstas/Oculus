//
//  SuggestionsTableViewCell.h
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/24/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SuggestionsTableViewCellDelegate <NSObject>

@end

@interface SuggestionsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *suggestionsLabel;
@property (strong, nonatomic)NSIndexPath *indexpath;
@end
