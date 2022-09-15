//
//  UIBezierPath+Additions.h
//  Karaoke
//
//  Created by Rain Nguyen on 10/5/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIBezierPath.h>

@interface UIBezierPath (Additions)

+ (UIBezierPath * _Nullable)bezierPathWithSquare:(CGRect)square numberOfSides:(NSUInteger)numberOfSides cornerRadius:(CGFloat)cornerRadius;

@end
