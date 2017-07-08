//
//  Private API for Touch Bar, discovered by Alexsander Akers: https://github.com/a2/touch-baer
//

#import <AppKit/AppKit.h>

@interface NSTouchBar ()

+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSString *)identifier;

+ (void)dismissSystemModalFunctionBar:(NSTouchBar *)touchBar;

@end
