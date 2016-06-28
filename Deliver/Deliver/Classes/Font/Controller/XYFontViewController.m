//
//  XYFontViewController.m
//  Deliver
//
//  Created by 李小亚 on 16/6/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYFontViewController.h"
#import "XYFontCell.h"
#import "XYFont.h"
#import "NSString+XY.h"

@interface XYFontViewController ()

@property (nonatomic, strong) NSMutableArray *fonts;

@end

@implementation XYFontViewController

#pragma mark - 懒加载
- (NSMutableArray *)fonts{
    if (!_fonts) {
        //先从沙盒中取
        _fonts = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString fontArrayDir]];
        if (_fonts == nil) {
            _fonts = [NSMutableArray array];
            XYFont *font1 = [XYFont fontWithName:@"翩翩体" simplifiedNormalfaced:@"HanziPenSC-W3" simplifiedBoldfaced:@"HanziPenSC-W5" traditionalNormalfaced:@"HanziPenTC-W3" traditionalBoldfaced:@"HanziPenTC-W5"  typeCount:4 fontTag:0];
            
            [_fonts addObject:font1];
            XYFont *font2 = [XYFont fontWithName:@"兰亭黑" simplifiedNormalfaced:@"FZLTXHK--GBK1-0" simplifiedBoldfaced:@"FZLTTHK--GBK1-0" traditionalNormalfaced:@"FZLTXHB--B51-0" traditionalBoldfaced:@"FZLTTHB--B51-0" typeCount:4 fontTag:1];
            [_fonts addObject:font2];
            XYFont *font3 = [XYFont fontWithName:@"楷书" simplifiedNormalfaced:@"STKaiti-SC-Regular" simplifiedBoldfaced:@"STKaiti-SC-Bold" traditionalNormalfaced:@"STKaiTi-TC-Regular" traditionalBoldfaced:@"STKaiTi-TC-Bold" typeCount:4 fontTag:2];
            [_fonts addObject:font3];
            XYFont *font4 = [XYFont fontWithName:@"手札体" simplifiedNormalfaced:@"HannotateSC-W5" simplifiedBoldfaced:@"HannotateSC-W7" traditionalNormalfaced:@"HannotateTC-W5" traditionalBoldfaced:@"HannotateTC-W7" typeCount:4 fontTag:3];
            [_fonts addObject:font4];
            XYFont *font5 = [XYFont fontWithName:@"雅痞" simplifiedNormalfaced:@"YuppySC-Regular" simplifiedBoldfaced:nil traditionalNormalfaced:@"YuppyTC-Regular" traditionalBoldfaced:nil typeCount:2 fontTag:4];
            [_fonts addObject:font5];
            
            XYFont *font6 = [XYFont fontWithName:@"Andale Mono Regular" simplifiedNormalfaced:@"AndaleMonoAndaleMono" simplifiedBoldfaced:nil traditionalNormalfaced:nil traditionalBoldfaced:nil typeCount:2 fontTag:5];
            [_fonts addObject:font6];
            
            XYFont *font7 = [XYFont fontWithName:@"Brush Script Std Medium" simplifiedNormalfaced:@"BrushScriptStd" simplifiedBoldfaced:nil traditionalNormalfaced:nil traditionalBoldfaced:nil typeCount:2 fontTag:6];
            [_fonts addObject:font7];
            //写入沙盒
            [NSKeyedArchiver archiveRootObject:_fonts toFile:[NSString fontArrayDir]];
        }
        
        
        
    }
    return _fonts;
}

#pragma mark - 生命周期
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    [self.tableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //保存到沙盒
    [NSKeyedArchiver archiveRootObject:_fonts toFile:[NSString fontArrayDir]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fonts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYFontCell *fontCell = [XYFontCell fontCellWithTableView:tableView];
    
    fontCell.font = self.fonts[indexPath.row];
    
    return fontCell;
}

//- (NSString *)fontArrayDir{
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *fontDir = [path stringByAppendingPathComponent:@"fontArray.acr"];
//    return fontDir;
//}


- (void)dealloc{
    XYLog(@"销毁字体VC");
}

@end
