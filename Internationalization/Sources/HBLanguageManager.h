//
//  HBLanguageManager.h
//  Internationalization
//
//  Created by Hilal Baig on 5/2/17.
//  Copyright © 2017 HilalB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ELanguage)
{
    ELanguageEnglish,
    ELanguageUrdu,
    ELanguagePashto,
	
    ELanguageCount
};

@interface HBLanguageManager : NSObject

+ (void)setupCurrentLanguage;
+ (NSArray *)languageStrings;
+ (NSArray *)languageCodes;
+ (NSArray *)languageDownloadUrls;
+ (NSString *)currentLanguageString;
+ (NSString *)currentLanguageCode;
+ (NSInteger)currentLanguageIndex;
+ (void)saveLanguageByIndex:(NSInteger)index;
+ (BOOL)isCurrentLanguageRTL;

@end
