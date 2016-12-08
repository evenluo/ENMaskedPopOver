//
//  ENMaskedPopOver.m
//  ENMaskedPopOver
//
//  Created by 罗亦文 on 2016/12/8.
//  Copyright © 2016年 evenluo. All rights reserved.
//

#import "ENMaskedPopOver.h"


@interface ENMaskedPopOver ()

@property (nonatomic, strong) ENPopOverView *popOverView;

@end

@implementation ENMaskedPopOver

+ (instancetype)showPopOverText:(NSString *)text attributes:(NSDictionary *)attributes inView:(UIView *)view basedOn:(UIView *)triggerView
{
    ENMaskedPopOver *popOver = [[ENMaskedPopOver alloc] initWithText:text attributes:attributes container:view basedOn:triggerView];
    return popOver;
}

- (instancetype)initWithText:(NSString *)text attributes:(NSDictionary *)attributes container:(UIView *)containerView basedOn:(UIView *)triggerView
{
    if (self = [super initWithFrame:containerView.bounds]) {
        [containerView addSubview:self];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
                                        ]];
        
        // 计算文字所需要的rect，并算出增加padding和箭头之后的rect
        CGRect textRect = [text boundingRectWithSize:CGSizeMake(150, 200) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        textRect.size.height += 26; // 上下的留白和箭头
        textRect.size.width += 16; // 左右的留白
        
        CGRect convertRect = [triggerView convertRect:triggerView.bounds toView:containerView];
        CGPoint convertedCenter = CGPointMake(convertRect.origin.x + convertRect.size.width/2, convertRect.origin.y + convertRect.size.height/2);
        
        // 箭头在上方还是在下方
        BOOL isUp = convertedCenter.y > containerView.bounds.size.height/2 ? YES : NO;
        isUp = YES;
        
        CGPoint popRectOrigin;
        CGFloat minimumMargin = 8;
        CGFloat originY = isUp ? convertedCenter.y + convertRect.size.height/2 + 3 :  convertedCenter.y - convertRect.size.height/2 - textRect.size.height - 3;
        CGFloat anchorX;
        
        if (convertedCenter.x > textRect.size.width/2 + minimumMargin && convertedCenter.x < containerView.frame.size.width - textRect.size.width/2 - minimumMargin ) {
            anchorX = textRect.size.width/2;
            popRectOrigin = CGPointMake(convertedCenter.x - textRect.size.width/2, originY);
        } else if (convertedCenter.x < textRect.size.width/2 + minimumMargin) {
            anchorX = convertedCenter.x - 8;
            popRectOrigin = CGPointMake(8, originY);
        } else {
            anchorX = convertedCenter.x - (containerView.frame.size.width - 8 - textRect.size.width);
            popRectOrigin = CGPointMake(containerView.frame.size.width - textRect.size.width - 8, originY);
        }
        
        textRect.origin = popRectOrigin;
        ENPopOverArrow direction = isUp ? ENPopOverArrowUp : ENPopOverArrowDown;
        // anchorPoint是动画的起止点
        CGPoint anchorPoint = isUp ? CGPointMake(anchorX, 0) : CGPointMake(anchorX, textRect.size.height);
        self.popOverView = [[ENPopOverView alloc] initWithFrame:textRect anchorPoint:anchorPoint arrowDirection:direction];
        self.popOverView.center = [self.popOverView convertPoint:anchorPoint toView:self];
        self.popOverView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
        [self addSubview:self.popOverView];
        
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByClipping];
        [label setAttributedText:[[NSAttributedString alloc] initWithString:text attributes:attributes]];
        [self.popOverView addSubview:label];
        [self.popOverView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.popOverView attribute:NSLayoutAttributeTop multiplier:1.0 constant:isUp ? 18 : 8],
                                           [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.popOverView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:8],
                                           [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.popOverView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:isUp ? -8 : -18],
                                           [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.popOverView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-8]
                                           ]];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.popOverView.center = CGPointMake(textRect.origin.x + textRect.size.width/2, textRect.origin.y + textRect.size.height/2);
            self.popOverView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        } completion:^(BOOL finished) {
            if (finished) {
                [self setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePopOver:)];
                [self addGestureRecognizer:tapGestureRecognizer];
            }
        }];
    }
    return self;
}

- (void)removePopOver:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.popOverView.center = [self.popOverView convertPoint:self.popOverView.anchorPoint toView:self.maskView];
        self.popOverView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end


@implementation ENPopOverView

- (instancetype)initWithFrame:(CGRect)frame anchorPoint:(CGPoint)anchorPoint arrowDirection:(ENPopOverArrow)direction
{
    if (self = [super initWithFrame:frame]) {
        self.anchorPoint = anchorPoint;
        self.arrowDirection = direction;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    switch (self.arrowDirection) {
        case ENPopOverArrowDown: {
            CGRect labelRect =  CGRectMake(0, 0, rect.size.width, rect.size.height - 9);
            UIBezierPath *bezierForRect = [UIBezierPath bezierPathWithRoundedRect:labelRect cornerRadius:2.0];
            
            UIBezierPath *arrowPath = [UIBezierPath bezierPath];
            [arrowPath moveToPoint:self.anchorPoint];
            [arrowPath addLineToPoint:CGPointMake(self.anchorPoint.x + 10, self.anchorPoint.y - 10)];
            [arrowPath addLineToPoint:CGPointMake(self.anchorPoint.x - 10, self.anchorPoint.y - 10)];
            [arrowPath closePath];
            
            [[UIColor whiteColor] setFill];
            [[UIColor clearColor] setStroke];
            [bezierForRect fill];
            [bezierForRect stroke];
            [arrowPath fill];
            [arrowPath stroke];
            break;
        }
            
        case ENPopOverArrowUp: {
            CGRect labelRect =  CGRectMake(0, 9, rect.size.width, rect.size.height - 9);
            UIBezierPath *bezierForRect = [UIBezierPath bezierPathWithRoundedRect:labelRect cornerRadius:2.0];
            
            UIBezierPath *arrowPath = [UIBezierPath bezierPath];
            [arrowPath moveToPoint:self.anchorPoint];
            [arrowPath addLineToPoint:CGPointMake(self.anchorPoint.x + 10, self.anchorPoint.y + 10)];
            [arrowPath addLineToPoint:CGPointMake(self.anchorPoint.x - 10, self.anchorPoint.y + 10)];
            [arrowPath closePath];
            
            [[UIColor whiteColor] setFill];
            [[UIColor clearColor] setStroke];
            [bezierForRect fill];
            [bezierForRect stroke];
            [arrowPath fill];
            [arrowPath stroke];
            break;
        }
            
        default:
            break;
    }
}

@end
