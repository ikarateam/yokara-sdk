//
//  UIBezierPath+Additions.m
//  Karaoke
//
//  Created by Rain Nguyen on 10/5/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import "UIBezierPath+Additions.h"

@implementation UIBezierPath (Additions)

+ (UIBezierPath *)bezierPathWithSquare:(CGRect)square numberOfSides:(NSUInteger)numberOfSides cornerRadius:(CGFloat)cornerRadius
{
    if ( CGRectGetWidth(square) != CGRectGetHeight(square) )
        {
        return nil;
        }
    
    CGFloat squareWidth = CGRectGetWidth(square);
    
    if ( numberOfSides == 0 || cornerRadius < 0.0 || 2.0 * cornerRadius > squareWidth || CGRectIsInfinite(square) || CGRectIsEmpty(square) || CGRectIsNull(square) )
        {
        return nil;
        }
    
    UIBezierPath *path = [UIBezierPath new];
    
    CGFloat theta = 2.0 * M_PI / numberOfSides;
    CGFloat offset = cornerRadius * tan(0.5 * theta);
    
    CGFloat length = squareWidth - path.lineWidth;
    if ( numberOfSides % 4 != 0 )
        {
        length = length * cos(0.5 * theta);
        }
    
    CGFloat sideLength = length * tan(0.5 * theta);
    
    CGFloat p1 = squareWidth / 2.0 + sideLength / 2.0 - offset;
    CGFloat p2 = squareWidth - (squareWidth - length) / 2.0;
    CGPoint point = CGPointMake(p1, p2);
    CGFloat angle = M_PI;
    [path moveToPoint:point];
    
    for ( NSUInteger i = 0; i < numberOfSides; i++ )
    {
    CGFloat x1 = point.x + ( sideLength - offset * 2.0 ) * cos(angle);
    CGFloat y1 = point.y + ( sideLength - offset * 2.0 ) * sin(angle);
    
    point = CGPointMake(x1, y1);
    [path addLineToPoint:point];
    
    CGFloat centerX = point.x + cornerRadius * cos(angle + M_PI_2);
    CGFloat centerY = point.y + cornerRadius * sin(angle + M_PI_2);
    CGPoint center = CGPointMake(centerX, centerY);
    CGFloat radius = cornerRadius;
    CGFloat startAngle =   M_PI_2;
    CGFloat endAngle = angle + theta - M_PI_2;
    NSLog(@" %f %f %f",radius,startAngle,endAngle);
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    point = path.currentPoint;
    angle += theta;
    }
    
    [path closePath];
    
    return path;
}

@end
