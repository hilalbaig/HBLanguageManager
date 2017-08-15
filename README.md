# HBLanguageManager
Language manager for iOS apps that handles downloading, syncing, caching, rtl/ltr handling and switching between languages without app restart.

![HBLanguageManager](https://raw.githubusercontent.com/hilalbaig/HBLanguageManager/master/example.gif "HBLanguageManager Gif")

The best language manager for iOS apps that does following for you in free 😉 , 
- [x] switch between languages without app restart
- [x] downloading languages from URL
- [x] syncing with new localizations and changes
- [x] caching it inside app
- [x] automatic handling of RTL & LTR languages

# Usage
Just initiliaze HBLanguageManager in main.m file like: [HBLanguageManager setupCurrentLanguage]; for switching and downloading feature, download repo and see example.

```objective-c
int main(int argc, char * argv[]) {
    @autoreleasepool {
        [HBLanguageManager setupCurrentLanguage];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

```


