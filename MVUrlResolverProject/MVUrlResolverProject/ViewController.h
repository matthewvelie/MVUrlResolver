//
//  ViewController.h
//  MVUrlResolverProject
//
//  Created by Matthew Velie on 7/20/12.
//  Copyright (c) 2012 Matthew Velie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MVUrlResolver.h"

@interface ViewController : UIViewController <MVUrlResolverDelegate>
{
	MVUrlResolver *urlResolver;
}
@property (weak, nonatomic) IBOutlet UITextField *shortUrlTextField;
@property (weak, nonatomic) IBOutlet UILabel *fullUrlLabel;
@property (weak, nonatomic) IBOutlet UIButton *processButton;

- (IBAction)processButtonTouchUpInside:(UIButton *)sender;
- (IBAction)clearButtonTouchUpInside:(UIButton *)sender;

@end
