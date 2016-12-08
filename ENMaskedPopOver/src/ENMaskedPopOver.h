//
//  ENMaskedPopOver.h
//  ENMaskedPopOver
//
//  Created by 罗亦文 on 2016/12/8.
//  Copyright © 2016年 evenluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ENMaskedPopOver : UIView

+ (instancetype)showPopOverText:(NSString *)text attributes:(NSDictionary *)attributes inView:(UIView *)view basedOn:(UIView *)triggerView;

- (instancetype)initWithText:(NSString *)text attributes:(NSDictionary *)attributes container:(UIView *)containerView basedOn:(UIView *)triggerView;

@end

typedef NS_ENUM(NSInteger, ENPopOverArrow) {
    ENPopOverArrowUp,
    ENPopOverArrowDown
};

@interface ENPopOverView : UIView

@property (nonatomic, assign) ENPopOverArrow arrowDirection;
@property (nonatomic, assign) CGPoint anchorPoint;

- (instancetype)initWithFrame:(CGRect)frame anchorPoint:(CGPoint)anchorPoint arrowDirection:(ENPopOverArrow)direction;

@end
