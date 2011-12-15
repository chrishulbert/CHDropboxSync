//
//  MyImgCell.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 25/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "MyImgCell.h"

@implementation MyImgCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const int leftBorder=10;
    const int topBorder=0;
    int cellHt = self.frame.size.height;
    int calcWid = 100;//cellHt*16/9+1;
    self.imageView.frame = CGRectMake(leftBorder, topBorder, calcWid, cellHt-topBorder*2-1);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    self.textLabel.frame = CGRectMake(leftBorder+calcWid+10, self.textLabel.frame.origin.y,
                                      self.frame.size.width-150, self.textLabel.frame.size.height);
}

@end
