//
//  WSDefine.h
//  SaveImg
//
//  Created by warron on 2017/12/22.
//  Copyright © 2017年 warron. All rights reserved.
//

//配置颜色
//16进制颜色转为UIColor
#define UIColorFromHX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB颜色转为UIColor
#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

//系统主题颜色
#define SystemThemeColor (UIColorFromHX(0xfcd601))

// 屏幕尺寸
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

//创建弱应用指针
#define weakObject(type) __weak typeof(type) weak##type = type
#define weakObj       __weak __typeof(self) weakSelf = self
 
#import <Photos/Photos.h>
#import "WSPHPhotoLibrary.h"
