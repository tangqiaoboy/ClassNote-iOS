//
//  DTGridViewCell+HFClassGridViewCell.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-25.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFClassGridViewCell.h"

@implementation HFClassGridViewCell

@synthesize titleLabel, textColor;

- (id)initWithReuseIdentifier:(NSString *)anIdentifier {
    
	if (!(self = [super initWithReuseIdentifier:anIdentifier])) return nil;
	
	titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Class1";
	textColor = [UIColor whiteColor];
	
    return self;
}

- (void)prepareForReuse {
	self.frame = CGRectZero;
}

- (void)drawRect:(CGRect)rect {
	
	NSInteger halfHeight = (NSInteger)(self.frame.size.height/2.0);
    NSInteger halfWidth = (NSInteger)(self.frame.size.width/2.0);
	
	CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
	self.titleLabel.frame = CGRectMake(halfWidth - labelSize.width/2.0, halfHeight-labelSize.height/2.0, labelSize.width, labelSize.height);
	
	[self addSubview:self.titleLabel];
	
	[self layoutSubviews];
}

- (void)dealloc {
	[titleLabel release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ title:%@ frame=(%i %i; %i %i)>", [self class], self.titleLabel.text, (NSInteger)self.frame.origin.x, (NSInteger)self.frame.origin.y, (NSInteger)self.frame.size.width, (NSInteger)self.frame.size.height];
}


@end
