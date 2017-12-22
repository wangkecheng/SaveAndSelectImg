//
//  ImgModel.h
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSDefine.h"
@interface ImgModel : NSObject
+(ImgModel *)modelByAsset:(PHAsset *)asset;

@property(nonatomic,strong) PHAsset *asset;

@property(nonatomic,strong) UIImage *image;

@property(nonatomic,strong) UIImage *bigImage;

@property(nonatomic,assign)BOOL isSelect;
@end
