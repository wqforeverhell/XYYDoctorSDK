//
//  DDPhotoListViewController.m
//  DiaoDiao
//
//  Created by wangzeng on 14-10-23.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "DDPhotoListViewController.h"
#import "XYYSDK.h"
@interface DDPhotoListViewController ()

@end

@implementation DDPhotoListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    if (self.delegate) {
        self.delegate=nil;
    }
    self.albumList=nil;
    self.assetCollection=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = RGBA(52, 52, 52, 1);
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setupNextWithString:@"取消" withColor:MAIN_BOTTOM_COLOR];
    
    
    
    _filterType = QBImagePickerFilterTypeAllPhotos;
    
    _albumList = [[NSMutableArray alloc] init];
    //    __unsafe_unretained DDPhotoListViewController* vc = self;
    //    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
    //        if(assetsGroup) {
    //            switch(vc.filterType) {
    //                case QBImagePickerFilterTypeAllAssets:
    //                    [assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    //                    break;
    //                case QBImagePickerFilterTypeAllPhotos:
    //                    [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    //                    break;
    //                case QBImagePickerFilterTypeAllVideos:
    //                    [assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
    //                    break;
    //            }
    //
    //            if(assetsGroup.numberOfAssets > 0) {
    //                [vc.albumList addObject:assetsGroup];
    //                [self.tableView reloadData];
    //            }
    //        }
    //    };
    //
    //    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
    //        NSLog(@"Error: %@", [error localizedDescription]);
    //    };
 
    PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumVideos;
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    for (NSInteger i=0; i<smartAlbums.count; i++) {
        // 获取一个相册PHAssetCollection
        @autoreleasepool {
        PHCollection *collection = smartAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            if (fetchResult.count>0) {
                [_albumList addObject:collection];
            }
            
        }else {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
        }
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"%ld", [_albumList count]);
    return [_albumList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *CellIdentifier = @"PhotoListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    UIImageView* imageview = (UIImageView*)[cell viewWithTag:1];
    [imageview setContentMode:UIViewContentModeScaleAspectFill];
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:2];
    PHCollection *collection = [_albumList objectAtIndex:row];
    PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    imageview.layer.cornerRadius = 4;
    imageview.layer.masksToBounds = YES;
    PHAsset *asset = nil;
    asset = fetchResult[0];
    PHImageRequestOptions *imageoptions = [[PHImageRequestOptions alloc] init];
    imageoptions.synchronous=YES;
    [imageoptions setResizeMode:PHImageRequestOptionsResizeModeFast];
    [imageoptions setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:(CGSize){250,250} contentMode:PHImageContentModeAspectFit options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
        if (result) {
            [imageview setImage:result];
        }
    }];
    NSLog(@"assetsGroup:%@",asset.creationDate);
    
    titleLabel.text = [NSString stringWithFormat:@"%@(%ld)", [self transformAblumTitle:collection.localizedTitle], fetchResult.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _assetCollection = [_albumList objectAtIndex:row];
    [self performSegueWithIdentifier:@"ChoosePhotoSeg" sender:self];
}

- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }else{
        return title;
    }
    return nil;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    @autoreleasepool {
    if([segue.identifier isEqualToString:@"ChoosePhotoSeg"]) {
        ChoosePhotoViewController* controller = (ChoosePhotoViewController*)segue.destinationViewController;
        controller.assetsGroup = _assetCollection;
        controller.limit = _limit;
        controller.orignal = _orignal;
        controller.delegate = _delegate;
    }
    }
}

#pragma mark - 重载取消
- (void)onNext {
    [super onNext];
    [super onBack];
}
@end
