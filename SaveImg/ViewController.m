//
//  ViewController.m
//  SaveImg
//
//  Created by warron on 2017/12/20.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "ViewController.h"
#import "WSPHPhotoLibrary.h"

#import "AlbumListVC.h"
#import "HDMainNavC.h"
#import "ImgModel.h"

#import "HWCollectionViewCell.h"
#import "LWImageBrowser.h"//浏览界面
#define SCREENWIDTH	[UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewH;


//选择的图片数据
@property(nonatomic,strong) NSMutableArray *arrSelected;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	_collectionView.backgroundColor = [UIColor whiteColor];
	_collectionView.scrollEnabled  = NO;
	
	_flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
	_flowLayout.minimumInteritemSpacing = 3;//同一行
	_flowLayout.minimumLineSpacing = 3;//同一列
}

- (IBAction)actionOne:(id)sender {
	
	[[WSPHPhotoLibrary library] saveImage:[UIImage imageNamed:@"123ab"] assetCollectionName:@"meme" sucessBlock:^(NSString *str, PHAsset *obj) {
		
	} faildBlock:^(NSError *error) {
		
	}];
}

- (IBAction)actionTwo:(id)sender {
	weakObj;
	AlbumListVC *VC = [[AlbumListVC alloc]
					   initWithArrSelected:self.arrSelected
					   maxCout:9
					   selectBlock:^(NSMutableArray<ImgModel *> *imgModelArr) {
						   dispatch_async(dispatch_get_main_queue(), ^{
							   [weakSelf.collectionView reloadData];
						   });
					   }];
	HDMainNavC *nav = [[HDMainNavC alloc]initWithRootViewController:VC];
	[weakSelf presentViewController:nav animated:YES completion:nil];
}
//这里的arrSelect  一定要初始化， 因为选择视图中的已选择数组 只是指针而已，指向这里创建的数组，这里创建的数组在该页面没有被
//摧毁的时候，一直存在在内存中，而选择视图中的指针虽然会消亡，但不会影响到这里
-(NSMutableArray *)arrSelected{
	if (!_arrSelected) {
	     _arrSelected  = [NSMutableArray array];
	}
	return _arrSelected;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _arrSelected.count+1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	CGFloat w = (CGRectGetWidth(collectionView.frame) - 20) / 4.0;
	return CGSizeMake(w,w);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UINib *nib = [UINib nibWithNibName:@"HWCollectionViewCell" bundle: [NSBundle mainBundle]];
	[collectionView registerNib:nib forCellWithReuseIdentifier:@"HWCollectionViewCell"];
	
	HWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HWCollectionViewCell" forIndexPath:indexPath];
	
	if (indexPath.row == _arrSelected.count) {
		ImgModel *model = [[ImgModel alloc]init];
		model.image = [UIImage imageNamed:@"pic_xiangmuquan_fazhaopian"];
		[cell  setAddImgModel:model]; 
	}
	else{
		[cell setModel:_arrSelected[indexPath.item]];
			weakObj;
		cell.deleteBlock = ^(ImgModel * model) {
			//删除照片
			if (!model) {
				return;
			}
			NSInteger index =  [weakSelf.arrSelected indexOfObject:model];
			[weakSelf.arrSelected removeObjectAtIndex:index];
			[weakSelf.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
			[weakSelf.collectionView reloadData];
			[weakSelf setCollectionViewHeight];
		};
	}
	[self setCollectionViewHeight];
	return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.item !=_arrSelected.count) {  //点击图片看大图
		//点击放大查看
		HWCollectionViewCell *cell = (HWCollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0]];
		
		NSMutableArray *arr = [NSMutableArray arrayWithCapacity:_arrSelected.count];
		for (ImgModel * model in _arrSelected) {
			LWImageBrowserModel* broModel = [[LWImageBrowserModel alloc]
											 initWithplaceholder:model.bigImage
											 thumbnailURL:nil
											 HDURL:nil
											 containerView:cell.contentView
											 positionInContainer:cell.contentView.frame
											 index:indexPath.row];
			[arr addObject:broModel];
		}
		
		LWImageBrowser* browser = [[LWImageBrowser alloc]
								   initWithImageBrowserModels:arr
								   currentIndex:indexPath.row];
		browser.isScalingToHide = NO;
		browser.isShowPageControl = NO;
		browser.isShowSaveImgBtn = NO;
		[browser show];
	}else{
		[self.view endEditing:YES];
		//添加新图片
		[self actionTwo:nil];
	}
}

//设置CollectionView高度
-(void)setCollectionViewHeight{
	_collectionViewH.constant = ((SCREENWIDTH - 30) /4.0)* ((int)(_arrSelected.count)/4+1)+15;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
