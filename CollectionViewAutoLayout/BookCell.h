
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
@property (nonatomic, retain) IBOutlet UILabel *bookTitle;
@property (nonatomic,retain) IBOutlet UILabel *bookTitle;
@property (nonatomic,retain) IBOutlet UITextView *bookDescription;
@property(nonatomic,retain) IBOutlet UITextView *dummydummydymmyDescription;
@property(nonatomic,retain) IBOutlet UITextView *dummytothepowerDescription;


@end
