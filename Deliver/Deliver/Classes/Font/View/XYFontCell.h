//
//  XYFontCell.h
//  Deliver
//
//  Created by 李小亚 on 16/6/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYFont;

@interface XYFontCell : UITableViewCell

@property (nonatomic, strong) XYFont *font;

/**
 *  创建自定义的cell
 */
+ (instancetype)fontCellWithTableView:(UITableView *)tableView;

@end