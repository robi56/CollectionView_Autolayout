//
//  ViewController.h
//  CollectionViewAutoLayout
//
//  Created by Mac-8 on 4/11/15.
//  Copyright (c) 2015 IPvision Canada Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImformationType){
 InformationTypeImage,
 InformationTypeBook
   

};

@interface ViewController : UIViewController

@property (nonatomic,strong) IBOutlet UICollectionView *picCollectionView;
@property (nonatomic,strong) IBOutlet UISearchBar *picSearchBar;
@property (nonatomic,strong) IBOutlet UISearchBar *picSearchBar1;
@property (nonatomic,strong) IBOutlet UISearchBar *picSearchBar1;

@end

