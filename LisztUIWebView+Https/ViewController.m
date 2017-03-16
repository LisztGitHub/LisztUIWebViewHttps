//
//  ViewController.m
//  LisztUIWebView+Https
//
//  Created by Liszt on 2017/1/19.
//  Copyright © 2017年 Liszt. All rights reserved.
//

#import "ViewController.h"
#import "UIWebView+Https.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.webView tp_configHttps:@"https://github.com/"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
