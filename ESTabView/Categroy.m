//
//  Categroy.m
//  ESTabView
//
//  Created by 翟泉 on 16/4/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "Categroy.h"

@implementation NSString (ESCategroy)

- (CGFloat)es_widthWithFont:(UIFont *)font; {
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [self boundingRectWithSize:CGSizeMake(9999, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL].size.width;
}

@end
