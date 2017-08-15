//
//  NSBundle+Language.h
//  Internationalization
//
//  Created by Hilal Baig on 5/2/17.
//  Copyright © 2017 HilalB. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef USE_ON_FLY_LOCALIZATION

@interface NSBundle (Language)

+ (void)setLanguage:(NSString *)language;


@end

#endif
