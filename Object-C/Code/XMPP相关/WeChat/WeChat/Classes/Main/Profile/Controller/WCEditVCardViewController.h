//
//  WCEditVCardViewController.h
//  WeChat
//
//  Created by  夏发启 on 16/8/14.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCEditVCardViewController;

@protocol WCEditVCardViewControllerDelegate <NSObject>

- (void)editVCardViewController:(WCEditVCardViewController *)editVC didFinishSave:(id)sender;

@end

@interface WCEditVCardViewController : UITableViewController

@property (nonatomic,strong)UITableViewCell *cell;
@property (nonatomic,weak)id <WCEditVCardViewControllerDelegate>delegate;

@end
