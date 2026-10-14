#import "Theme.h"

@implementation Theme

+ (UIColor *)background {
    return [UIColor colorWithRed:0.86
                           green:0.89
                            blue:0.93
                           alpha:1.0];
}

+ (UIColor *)panel {
    return [UIColor colorWithRed:0.94
                           green:0.95
                            blue:0.97
                           alpha:1.0];
}

+ (UIColor *)accent {
    return [UIColor colorWithRed:0.12
                           green:0.48
                            blue:0.67
                           alpha:1.0];
}

+ (UIColor *)mint {
    return [UIColor colorWithRed:0.16
                           green:0.53
                            blue:0.39
                           alpha:1.0];
}

+ (UIColor *)text {
    return [UIColor colorWithRed:0.16
                           green:0.19
                            blue:0.25
                           alpha:1.0];
}

+ (UIColor *)muted {
    return [UIColor colorWithRed:0.39
                           green:0.43
                            blue:0.50
                           alpha:1.0];
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
    view.layer.cornerRadius = 16.0;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor =
        [UIColor colorWithWhite:0.65 alpha:0.25].CGColor;
    view.layer.shadowColor = UIColor.blackColor.CGColor;
    view.layer.shadowOpacity = 0.04;
    view.layer.shadowRadius = 8.0;
    view.layer.shadowOffset = CGSizeMake(0, 3);
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
