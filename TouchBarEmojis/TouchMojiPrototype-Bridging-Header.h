//
//  Private API for Touch Bar, discovered by Alexsander Akers: https://github.com/a2/touch-baer
//

#import <AppKit/AppKit.h>

@interface NSTouchBar ()

+ (void)presentSystemModalTouchBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier NS_AVAILABLE_MAC(10.14);
+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSString *)identifier NS_DEPRECATED_MAC(10.12.2, 10.14);

+ (void)dismissSystemModalTouchBar:(NSTouchBar *)touchBar NS_AVAILABLE_MAC(10.14);
+ (void)dismissSystemModalFunctionBar:(NSTouchBar *)touchBar NS_DEPRECATED_MAC(10.12.2, 10.14);

@end
