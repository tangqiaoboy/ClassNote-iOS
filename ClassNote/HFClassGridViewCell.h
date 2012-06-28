//
//  DTGridViewCell+HFClassGridViewCell.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-25.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "DTGridViewCell.h"

@interface HFClassGridViewCell : DTGridViewCell {
    UILabel *titleLabel;
	UIColor *textColor;
}


@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIColor *textColor;
@end
