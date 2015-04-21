//
//  ImageCell.h
//  CollectionViewAutoLayout
//
//  Created by Mac-8 on 4/11/15.
//  Copyright (c) 2015 IPvision Canada Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface ImageCell : UICollectionViewCell

@property (nonatomic,strong) IBOutlet UIView *container;
@property(nonatomic,strong) IBOutlet AsyncImageView *picture;
@property(nonatomic,strong) IBOutlet UILabel *imageLabel;
@end
