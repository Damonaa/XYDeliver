//
//  XYContainerView.h
//  Deliver
//
//  Created by 李小亚 on 16/5/29.
//  Copyright © 2016年 李小亚. All rights reserved.
// 展示拼图的容器

#import <UIKit/UIKit.h>
/**
 *  重新布局block
 */
typedef void(^LayoutCVBlock)();

@class XYScrollView, XYMenuView;

@interface XYContainerView : UIView

//模板比例 1：1，4：3， 3：4
typedef enum{
    TemplateScaleOneToOne,
    TemplateScaleFourToThree,
    TemplateScaleThreeToFour
}TemplateScale;

/**
 *  模板模型的index
 */
@property (nonatomic, assign) NSInteger templateIndex;
/**
 *  模板比例
 */
@property (nonatomic, assign) TemplateScale templateScale;

/**
 *  空白的模板个数
 */
//@property (nonatomic, assign) NSInteger emptySVCount;
/**
 *  存放全部的空白的模板
 */
@property (nonatomic, strong) NSMutableArray *emptySVs;

/**
 *  存放添加的图片
 */
@property (nonatomic, strong) NSMutableArray *images;

/**
 *  选中的scrollView
 */
@property (nonatomic, strong) XYScrollView *currentSV;
/**
 *  重新布局block
 */
@property (nonatomic, copy) LayoutCVBlock layoutCV;

/**
 *  点击scroll弹出菜单
 */
@property (nonatomic, weak) XYMenuView *menuView;


@end
