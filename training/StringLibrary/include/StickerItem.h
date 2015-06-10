//
//  StickerItem.h
//  iMessageUtility
//
//  Created by 1200432AArthur on 2014/9/23.
//  Copyright (c) 2014年 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StickerItem : NSObject

@property (nonatomic, assign) NSInteger StickerId;
@property (nonatomic, retain) NSString* StickerName;
@property (nonatomic, retain) UIImage*  StickerImage;

@end
