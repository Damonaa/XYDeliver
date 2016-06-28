//
//  XYPreview.h
//  Deliver
//
//  Created by 李小亚 on 16/6/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYFilter, XYPreview;

@protocol XYPreviewDelegate <NSObject>

- (void)preview:(XYPreview *)preview didTapImage:(UIImage *)image;

@end


@interface XYPreview : UIView


@property (nonatomic, weak) id<XYPreviewDelegate> delegate;

/**
 *  滤镜模型
 */
@property (nonatomic, strong) XYFilter *filterItem;
/**
 *  是否是选中，默认NO
 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;


@end
