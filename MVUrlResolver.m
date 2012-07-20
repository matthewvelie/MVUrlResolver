//
//  MVUrlResolver.m
//
//  Created by Matthew Velie on 6/26/12.
//  Copyright (c) 2012 Matthew Velie. All rights reserved.
//

#import "MVUrlResolver.h"

@implementation MVUrlResolver

@synthesize shortUrlDictionary;
@synthesize dirtyUrlDictionary;
@synthesize delegate;

- (id)init
{
	return [self initWithArrayOfTinyUrlStringsToProcess:nil];
}

- (id)initWithArrayOfTinyUrlStringsToProcess:(NSArray *)array
{
	if (self = [super init])
    {
		// Initialization code here
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		plistFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:PLIST_FILENAME];
		
		//load up saved url dictionary
		shortUrlDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFile];
		if (!shortUrlDictionary) {
			shortUrlDictionary = [[NSMutableDictionary alloc] init];
			[shortUrlDictionary writeToFile:plistFile atomically:YES];
		}
		
		//if we were given an array to start with, determine all the items for that array
		if(array != nil)
		{
			for(NSString *string in array)
			{
				[self determineOriginalUrlFromTinyUrlString:string];
			}
		}
    }
    return self;
}

- (void)dealloc
{
	[self saveShortDictionaryToPlist];
}

- (void)saveShortDictionaryToPlist
{
	//save the dictionary out to a file so it can be used later
	[shortUrlDictionary writeToFile:plistFile atomically:YES];
}

- (void)determineOriginalUrlFromTinyUrlString:(NSString *)urlString
{
	[self determineOriginalUrlFromTinyUrl:[NSURL URLWithString:urlString]];
}

- (void)determineOriginalUrlFromTinyUrl:(NSURL *)url
{
	//intialize and set to be a head request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"HEAD"];
	
	NSString *urlString = [url absoluteString];
	if([shortUrlDictionary objectForKey:urlString] != nil)
	{
		//value already exists
		if(delegate != nil && [delegate respondsToSelector:@selector(shortUrl:proccessedToFullURL:fromCache:)])
		{
			[delegate shortUrl:url proccessedToFullURL:[NSURL URLWithString:[shortUrlDictionary objectForKey:urlString]] fromCache:TRUE];
		}
		return;
	}
	
	//mark record as dirty
	[dirtyUrlDictionary setObject:@"1" forKey:[url absoluteString]];
	
	//start connection
	[NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLRequest delegates 

- (NSURLRequest *)connection: (NSURLConnection *)connection
             willSendRequest: (NSURLRequest *)request
            redirectResponse: (NSURLResponse *)redirectResponse;
{
	//check for a redirect
	if (redirectResponse) {
		
		//add the new url to the short dictionary
		[shortUrlDictionary setObject:[[request URL] absoluteString] forKey:[connection.originalRequest.URL absoluteString]];
		
		//continue with request, make sure it is a head reuqest
		NSMutableURLRequest *newRequest = [request mutableCopy];
		[newRequest setHTTPMethod:@"HEAD"];
		
		return newRequest;
	}
	else
	{
		return request;
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *startingUrl = [connection.currentRequest.URL absoluteString];
	NSString *finalUrl = [shortUrlDictionary objectForKey:startingUrl];
	[dirtyUrlDictionary removeObjectForKey:startingUrl]; //mark no longer dirty as it is done by removing from dict
	
	//call delegate if setup
	if(delegate != nil && [delegate respondsToSelector:@selector(shortUrl:proccessedToFullURL:fromCache:)])
	{
		[delegate shortUrl:connection.originalRequest.URL proccessedToFullURL:[NSURL URLWithString:finalUrl] fromCache:FALSE];
	}
}

@end
