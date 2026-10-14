#import <UIKit/UIKit.h>
@interface Theme : NSObject
+ (UIColor *)background; + (UIColor *)panel; + (UIColor *)accent; + (UIColor *)mint; + (UIColor *)text; + (UIColor *)muted;
+ (UILabel *)label:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color;
+ (UIView *)card;
@end
