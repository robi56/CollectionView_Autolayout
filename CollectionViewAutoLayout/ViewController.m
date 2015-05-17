//
//  ViewController.m
//  CollectionViewAutoLayout
//
//  Created by Mac-8 on 4/11/15.
//  Copyright (c) 2015 IPvision Canada Inc. All rights reserved.
//

#import "ViewController.h"
#import "ImageCell.h"
#import "BookCell.h"
#import "AsyncImageView.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UIWebViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *imageRemoteLocationArray;
@property (nonatomic,strong) UIWebView *webViewForImageExtraction;
@property (nonatomic,strong) NSString *imageSearchPreHeader;
@property (nonatomic,strong) NSString *imageSearchPostHeader;
@property (nonatomic,strong) NSMutableArray *bookArray;
@property (nonatomic) int searchInformationType;
@property (nonatomic) BOOL isImageSearchEnabled;
@property (nonatomic,strong) NSIndexPath* currentScrollIndex;
@property (nonatomic,strong) NSIndexPath* currentScrollIndex1;
@property (nonatomic,strong) NSString *stringForCheck;
@end

@implementation ViewController
@synthesize imageSearchPostHeader,imageSearchPreHeader,searchInformationType,picSearchBar ;
- (void)viewDidLoad {
    [super viewDidLoad];
    imageSearchPreHeader=@"https://www.google.com/search?q=";
    imageSearchPostHeader=@"&sa=X&biw=1920&bih=337&tbm=isch&ijn=3&ei=qlS3VLv4H-Ov7AbenICIBA&start=0&num=1000";
    self.webViewForImageExtraction=[[UIWebView alloc]init];
    self.webViewForImageExtraction.delegate=self;
    searchInformationType=InformationTypeImage;
    picSearchBar.placeholder=@"Search Image";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark- CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.isImageSearchEnabled) {
        return  self.imageRemoteLocationArray.count;
    }
    else {
        return  self.bookArray.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.isImageSearchEnabled) {
        ImageCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCellId" forIndexPath:indexPath];
        
        cell.backgroundColor=[UIColor orangeColor];
        
        [ cell.picture setImageURL:[NSURL URLWithString:[self.imageRemoteLocationArray objectAtIndex:indexPath.item]]];
        cell.imageLabel.text= [NSString stringWithFormat:@"%@ %ld",@"Google Image",(long)indexPath.row];
        return cell;
    }
    
    else {
        
        BookCell *bookCell =[collectionView dequeueReusableCellWithReuseIdentifier:@"BookCellId" forIndexPath:indexPath];
        
        NSDictionary *book =[self.bookArray objectAtIndex:indexPath.item];
        [ bookCell.bookImage setImageURL:[NSURL URLWithString:[book valueForKey:@"artworkUrl60"]]];
        bookCell.bookTitle.text=[book valueForKey:@"trackName"];
        
        NSAttributedString *descriptionValue= [[NSAttributedString alloc] initWithData:[[book valueForKey:@"description"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                         NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                    documentAttributes:nil error:nil];
        bookCell.bookDescription.attributedText=descriptionValue;
        
        return bookCell;
    }
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.picCollectionView.bounds.size;

    if (self.isImageSearchEnabled) {
        return self.picCollectionView.bounds.size;
    }
    else{
      
        NSLog(@"Current Item to calculate height,%ld-%i",(long)indexPath.item,self.bookArray.count);
    NSDictionary *book =[self.bookArray objectAtIndex:indexPath.item];
        NSString *htmlString=[book valueForKey:@"description"];
    NSAttributedString *descriptionValue= [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                                           options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                     NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                documentAttributes:nil error:nil];
        
    NSLog(@".............................Size: %@",NSStringFromCGSize(self.picCollectionView.bounds.size));
        return self.picCollectionView.bounds.size;
  
        float height=[self textViewSize:descriptionValue];
        if (height+100<self.picCollectionView.bounds.size.height) {
            return self.picCollectionView.bounds.size;
        }
       else
        return   CGSizeMake(self.picCollectionView.bounds.size.width, 100+ height);
    }
    
} 

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//
//}

#pragma mark- Searchbar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchInformationType==InformationTypeImage) {
        [self.webViewForImageExtraction loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",imageSearchPreHeader,searchBar.text,imageSearchPostHeader]]]];
        picSearchBar.placeholder=@"Search Book";
        self.isImageSearchEnabled=YES;
        searchInformationType=InformationTypeBook;
    }
    else if(searchInformationType==InformationTypeBook ){
        [self searchWithItem:searchBar.text];
        picSearchBar.placeholder=@"Search Image";
        self.isImageSearchEnabled=NO;
        searchInformationType=InformationTypeImage;
    }
    
    
    [searchBar resignFirstResponder];
}

#pragma mark- WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    self.imageRemoteLocationArray= [self getImageURLArray:html];
    [self.picCollectionView reloadData];
}

-(NSMutableArray*)getImageURLArray:(NSString*)htmlCode{
    
    if (!htmlCode || [htmlCode length] == 0) {
        return nil;
    }
    
    NSMutableArray* urlArray = [[NSMutableArray alloc] init];
    char* code = (char*)[htmlCode cStringUsingEncoding:NSUTF8StringEncoding];
    char temp[5000];
    memset(temp, 0, 5000);
    
    char* p = NULL;
    char* q = NULL;
    p = q = code;
    //   int tokenLen = strlen("href=\"/imgres?imgurl=");
    int tailTokenLen = strlen("&amp;imgrefurl=");
    //
    for (q=p;(q!=NULL&&p!=NULL);) {
        // p = strstr(code,"href=\"/imgres?imgurl=");
        p=strstr(code,"src=\"");
        if (!p) {
            break;
        }
        p=p+4;
        //   p = p + tokenLen;
        //   q = strstr(p,"&amp;imgrefurl=");
        q=strstr(p,"\" data");
        memset(temp, 0, 5000);
        
        if (!q) {
            break;
        }
        memcpy(temp,p,q-p);
        
        
        
        NSString* URL = [NSString stringWithCString:temp encoding:NSUTF8StringEncoding];
        if (URL) {
            URL=[URL substringFromIndex:1];
            [urlArray addObject:URL];
            
        }
        
        NSLog(@"URL NO %u URL SIZE %lu", urlArray.count-1, (unsigned long)URL.length);
        q = q + tailTokenLen;
        p = q;
        code = p;
        
    }
    return urlArray;
    
}

-(void)searchWithItem:(NSString*)searchItem{
    
    NSString  *urlString=[NSString stringWithFormat:@"%@%@%@" ,@"https://itunes.apple.com/search?term=",searchItem,@"&entity=ibook&limit=10"];
    NSString *urlStringUTF=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __block  NSDictionary *datadictionary=nil;
   //[[NSBundle mainBundle] pathForResource:@"Locations-JSON" ofType:@"rtf"];
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStringUTF]];
    NSError *error;
    
    if (data) {
        datadictionary= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    
    else {
        
        UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"Message" message:@"Data Connection Failure" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
    }
    
    if (self.bookArray) {
        self.bookArray=[NSMutableArray new];
        
    }
    
    
    self.bookArray =  [datadictionary valueForKey:@"results"];
    
    
    if (  self.bookArray .count>0) {
        [self.picCollectionView reloadData];
    }
    else{
        self.isImageSearchEnabled=YES;
        self.searchInformationType=InformationTypeImage;
    }
    
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
       self.currentScrollIndex=[[self.picCollectionView indexPathsForVisibleItems] firstObject];
    
    NSLog(@"Pre Current Visible Cell:%d",self.currentScrollIndex.row);
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"Size.........************: %@ %@",NSStringFromCGSize(self.view.bounds.size),NSStringFromCGSize(self.picCollectionView.bounds.size));
   
  //  [self.picCollectionView reloadData];
    if (self.picCollectionView.visibleCells.count>0) {
    
    NSIndexPath *indexpath=[[self.picCollectionView indexPathsForVisibleItems] objectAtIndex:0];
   //
        NSLog(@"Post Current Visible Item :%d ,%d ",indexpath.item,self.currentScrollIndex.item);
    [self.picCollectionView reloadItemsAtIndexPaths:@[indexpath]] ;
  //  [self.picCollectionView scrollToItemAtIndexPath:self.currentScrollIndex atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
}


- (CGFloat)textViewSize:(NSAttributedString *)textViewString
{
    // NSLog(@"PreSize %@",NSStringFromCGRect(textView.frame));
    UITextView * textView = [[UITextView alloc] init];
    [textView setAttributedText:textViewString];
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(self.picCollectionView.bounds.size.width, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
     NSLog(@"PostSize %@",NSStringFromCGRect(textView.frame));
    return  textView.frame.size.height;
}
@end
