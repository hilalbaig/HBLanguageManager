//
//  NSBundle+Language.m
//  Internationalization
//
//  Created by Hilal Baig on 5/2/17.
//  Copyright © 2017 HilalB. All rights reserved.
//

#import "NSBundle+Language.h"
#import "HBLanguageManager.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define CUSTOM_BUNDLE_NAME @"LangugesBundle.bundle"//@"MyBundle.bundle"

//https://iosapplove.com/archive/2013/01/localizable-strings-how-to-load-translations-dynamically-and-use-it-inside-your-iphone-app/

static NSBundle *staticCustomBundle = nil;



static const char kBundleKey = 0;


@interface BundleEx : NSBundle

@end

@implementation BundleEx

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle *bundle = objc_getAssociatedObject(self, &kBundleKey);
    
//    if ([key isEqualToString:@"t1P-rE-Sd3.title"]) {
//        NSLog(@"%@ : %@",key,value);
//    }
    
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    }
    else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end

@implementation NSBundle (Language)


+ (void)setLanguage:(NSString *)language
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [BundleEx class]);
    });
    
    
    if ([HBLanguageManager isCurrentLanguageRTL]) {
        if ([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft]; //view
            [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft]; //navigation
            
            [[UITextField appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft]; //txtField
            [[UITextField appearance] setTextAlignment:NSTextAlignmentRight];
        }
    } else {
        if ([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight]; //view
            [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight]; //navigation
            
            [[UITextField appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight]; //txtField
            [[UITextField appearance] setTextAlignment:NSTextAlignmentLeft];
            
        }
    }
    
    
    
    
    [[NSUserDefaults standardUserDefaults] setBool:[HBLanguageManager isCurrentLanguageRTL] forKey:@"AppleTextDirection"];
    [[NSUserDefaults standardUserDefaults] setBool:[HBLanguageManager isCurrentLanguageRTL] forKey:@"NSForceRightToLeftWritingDirection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
//    id value = language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil; //local
    
    
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    
//    NSBundle *bundle = [self getCurrentBundle]; //server or local
//    
//    if ([bundle load]) {
//        if ([bundle isLoaded]) {
//            [bundle unload];
//        }
//    }
    
    
    //FlushBundleCache(value);
    id value = [self getCurrentBundle]; //server or local
    
    objc_setAssociatedObject([NSBundle mainBundle], &kBundleKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    
    
}


+(NSBundle*)getCurrentBundle {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *externalBundlePath = [documentsDirectory stringByAppendingPathComponent:CUSTOM_BUNDLE_NAME];
    NSString *lProj = [NSString stringWithFormat:@"%@.lproj",[HBLanguageManager currentLanguageCode].lowercaseString];
    NSString *langPath =  [externalBundlePath stringByAppendingPathComponent:lProj];
    NSURL *url = [NSURL fileURLWithPath:langPath];
    NSBundle *extBundle = [NSBundle bundleWithURL:url];
    
    if(extBundle) {
        return extBundle;
    } else {
        //external bundle is not yet downloaded.. so we load inapp internal bundle
        
        NSBundle *intBuldle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[HBLanguageManager currentLanguageCode].lowercaseString ofType:@"lproj"]];
        return intBuldle;
    }
    
    
}

extern void _CFBundleFlushBundleCaches(CFBundleRef bundle)
__attribute__((weak_import));

BOOL FlushBundleCache(NSBundle *prefBundle) {
    // Before calling the function, we need to check if it exists
    // since it was weak-linked.
    if (_CFBundleFlushBundleCaches != NULL) {
        NSLog(@"Flushing bundle cache with _CFBundleFlushBundleCaches");
        CFBundleRef cfBundle = CFBundleCreate(nil, (CFURLRef)[prefBundle bundleURL]);
        _CFBundleFlushBundleCaches(cfBundle);
        CFRelease(cfBundle);
        return YES; // Success
    }
    return NO; // Not available
}


@end
