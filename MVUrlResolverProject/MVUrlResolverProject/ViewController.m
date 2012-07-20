//
//  ViewController.m
//  MVUrlResolverProject
//
//  Created by Matthew Velie on 7/20/12.
//  Copyright (c) 2012 Matthew Velie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize shortUrlTextField;
@synthesize fullUrlLabel;
@synthesize processButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	//create and set delegate
	urlResolver = [[MVUrlResolver alloc] init];
	[urlResolver setDelegate:self];
	
	//highlight text field
	[shortUrlTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	//save when finished
	[urlResolver saveShortDictionaryToPlist];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)processButtonTouchUpInside:(UIButton *)sender
{
	if([shortUrlTextField.text isEqualToString:@""] || [shortUrlTextField.text isEqualToString:@"http://"])
	{
		fullUrlLabel.text = @"Invalid Url";
		return;
	}
	
	NSLog(@"Processing short url: %@", shortUrlTextField.text);
	fullUrlLabel.text = @"Processing...";
	[processButton setEnabled:FALSE];
	[urlResolver determineOriginalUrlFromTinyUrlString:shortUrlTextField.text];
}

- (IBAction)clearButtonTouchUpInside:(UIButton *)sender
{
	NSLog(@"Clearing text fields");
	shortUrlTextField.text = @"";
	fullUrlLabel.text = @"";
	[processButton setEnabled:TRUE];
}

# pragma mark - MVUrlResolver Delegate
- (void)shortUrl:(NSURL *)url proccessedToFullURL:(NSURL *)fullUrl fromCache:(BOOL)cache
{
	NSLog(@"Short: %@ -> Long: %@ -- From Cache: %d", [url absoluteString], [fullUrl absoluteString], cache);
	fullUrlLabel.text = [fullUrl absoluteString];
	[processButton setEnabled:TRUE];
}
@end
