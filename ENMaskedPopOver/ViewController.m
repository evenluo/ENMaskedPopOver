//
//  ViewController.m
//  ENMaskedPopOver
//
//  Created by 罗亦文 on 2016/12/7.
//  Copyright © 2016年 evenluo. All rights reserved.
//

#import "ViewController.h"
#import "ENMaskedPopOver.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)pop:(id)sender {
    [ENMaskedPopOver showPopOverText:@"这是一个独立的提示信息view，只需要一句话就可以完成整个事情" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor blackColor]} inView:self.view basedOn:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
