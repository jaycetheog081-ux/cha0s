#import "Theme.h"

@implementation Theme

+ (UIColor *)background {
    return [UIColor colorWithRed:0.96
                           green:0.97
                            blue:0.99
                           alpha:1.0];
}

+ (UIColor *)panel {
    return UIColor.whiteColor;
}

+ (UIColor *)accent {
    return [UIColor colorWithRed:0.10
                           green:0.62
                            blue:0.83
                           alpha:1.0];
}

+ (UIColor *)mint {
    return [UIColor colorWithRed:0.12
                           green:0.68
                            blue:0.48
                           alpha:1.0];
}

+ (UIColor *)text {
    return [UIColor colorWithRed:0.12
                           green:0.16
                            blue:0.24
                           alpha:1.0];
}

+ (UIColor *)muted {
    return [UIColor colorWithRed:0.43
                           green:0.47
                            blue:0.55
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
    view.layer.cornerRadius = 18.0;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor =
        [UIColor colorWithRed:0.87
                        green:0.90
                         blue:0.94
                        alpha:1.0].CGColor;

    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.045;
    view.layer.shadowRadius = 10.0;
    view.layer.shadowOffset = CGSizeMake(0, 4);

    view.translatesAutoresizingMaskIntoConstraints = NO;

    return view;
}

@end
