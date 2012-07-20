//
//  MVUrlResolver.h
//
//  Created by Matthew Velie on 6/26/12.
//  Copyright (c) 2012 Matthew Velie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLIST_FILENAME @"shortUrl.plist"

@protocol MVUrlResolverDelegate <NSObject>
- (void)shortUrl:(NSURL *)url proccessedToFullURL:(NSURL *)fullUrl fromCache:(BOOL)cache;
@end

@interface MVUrlResolver : NSObject <NSURLConnectionDelegate>
{
	NSMutableDictionary *shortUrlDictionary;
	NSMutableDictionary *dirtyUrlDictionary;
	NSString *plistFile;
	
	__weak id<MVUrlResolverDelegate> delegate;
}
//short url dictionary contains all of the data that has been processed
@property (nonatomic, readonly) NSMutableDictionary *shortUrlDictionary;
//if your url is in this dictonary it hasn't been processed yet
@property (nonatomic, readonly) NSMutableDictionary *dirtyUrlDictionary;

//if you want a callback when url is processed
@property (weak) id<MVUrlResolverDelegate> delegate;

//initialize with a bunch of url strings to process
- (id)initWithArrayOfTinyUrlStringsToProcess:(NSArray *)array;

//used for single strings
- (void)determineOriginalUrlFromTinyUrl:(NSURL *)url;
- (void)determineOriginalUrlFromTinyUrlString:(NSString *)urlString;

//should happen automatically but you can call it programatically to make sure
- (void)saveShortDictionaryToPlist;
@end
