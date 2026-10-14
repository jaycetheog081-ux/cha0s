#import "Theme.h"

@implementation Theme

+ (UIColor *)dynamicLight:(UIColor *)light dark:(UIColor *)dark {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traits) {
            return traits.userInterfaceStyle == UIUserInterfaceStyleDark
                ? dark
                : light;
        }];
    }
    return dark;
}

+ (UIColor *)background {
    return [self dynamicLight:
        [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1]
        dark:[UIColor colorWithRed:0.035 green:0.043 blue:0.075 alpha:1]];
}

+ (UIColor *)panel {
    return [self dynamicLight:
        [UIColor whiteColor]
        dark:[UIColor colorWithRed:0.075 green:0.086 blue:0.135 alpha:1]];
}

+ (UIColor *)accent {
    return [UIColor colorWithRed:0.49 green:0.39 blue:1 alpha:1];
}

+ (UIColor *)mint {
    return [self dynamicLight:
        [UIColor colorWithRed:0.02 green:0.48 blue:0.42 alpha:1]
        dark:[UIColor colorWithRed:0.20 green:0.82 blue:0.75 alpha:1]];
}

+ (UIColor *)text {
    return [self dynamicLight:
        [UIColor colorWithWhite:0.04 alpha:1]
        dark:[UIColor whiteColor]];
}

+ (UIColor *)muted {
    return [self dynamicLight:
        [UIColor colorWithWhite:0.32 alpha:1]
        dark:[UIColor colorWithWhite:0.70 alpha:1]];
}

+ (UILabel *)label:(NSString *)text
              size:(CGFloat)size
            weight:(UIFontWeight)weight
             color:(UIColor *)color {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}

+ (UIView *)card {
    UIView *view = [UIView new];
    view.backgroundColor = self.panel;
    view.layer.cornerRadius = 18;
    view.layer.borderWidth = 1;

    view.layer.borderColor = [[self dynamicLight:
        [UIColor colorWithWhite:0 alpha:0.08]
        dark:[UIColor colorWithWhite:1 alpha:0.09]] CGColor];

    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
