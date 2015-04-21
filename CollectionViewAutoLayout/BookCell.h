//
//  BookCell.h
//  CollectionViewAutoLayout
//
//  Created by Mac-8 on 4/11/15.
//  Copyright (c) 2015 IPvision Canada Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface BookCell : UICollectionViewCell

@property (nonatomic,strong) IBOutlet AsyncImageView *bookImage;
@property (nonatomic,strong) IBOutlet UILabel *bookTitle;
@property (nonatomic,retain) IBOutlet UITextView *bookDescription;
@property (nonatomic,strong) IBOutlet UITextView *dummyDescription;
@property (nonatomic,strong) IBOutlet UITextView *dummydummyDescription;
@end
