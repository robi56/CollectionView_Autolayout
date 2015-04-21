
//  BookCell.h
//  CollectionViewAutoLayout
//
//  Created by Mac-8 on 4/11/15.
//  Copyright (c) 2015 IPvision Canada Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface BookCell : UICollectionViewCell


@property (nonatomic,retain) IBOutlet AsyncImageView *bookImage;
@property (nonatomic, retain) IBOutlet UILabel *bookTitle;
@property (nonatomic,retain) IBOutlet UILabel *bookTitle;
@property (nonatomic,strong) IBOutlet UITextView *bookDescription;
@end
