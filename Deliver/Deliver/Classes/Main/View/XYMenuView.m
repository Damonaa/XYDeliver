//
//  XYMenuView.m
//  Deliver
//
//  Created by 李小亚 on 16/6/1.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYMenuView.h"

@interface XYMenuView ()<UITableViewDataSource, UITableViewDelegate>



@end

@implementation XYMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.457];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = 30;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reusedID = @"menuCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"图片";
        cell.imageView.image = [UIImage imageNamed:@"tool_btn_photo_default"];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"相机";
        cell.imageView.image = [UIImage imageNamed:@"tool_btn_camera_default"];
    }else if (indexPath.row ==2){
        cell.textLabel.text = @"横排文字";
        cell.imageView.image = [UIImage imageNamed:@"text_setting_btn_horizontal_default"];
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"竖排文字";
        cell.imageView.image = [UIImage imageNamed:@"text_setting_btn_ vertical_default"];
    }else{
        cell.textLabel.text = @"删除";
        cell.imageView.image = [UIImage imageNamed:@"tool_btn_delete_default"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //发出选中的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:XYSelectedMenu object:self userInfo:@{XYSelectedMenu:[NSNumber numberWithInteger:indexPath.row]}];
    
    self.hidden = YES;
}



@end
