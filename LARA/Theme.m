#import "Theme.h"
@implementation Theme
+ (UIColor *)background { return [UIColor colorWithRed:.035 green:.043 blue:.075 alpha:1]; }
+ (UIColor *)panel { return [UIColor colorWithRed:.075 green:.086 blue:.135 alpha:1]; }
+ (UIColor *)accent { return [UIColor colorWithRed:.49 green:.39 blue:1 alpha:1]; }
+ (UIColor *)mint { return [UIColor colorWithRed:.20 green:.82 blue:.75 alpha:1]; }
+ (UIColor *)text { return UIColor.whiteColor; }
+ (UIColor *)muted { return [UIColor colorWithWhite:.70 alpha:1]; }
+ (UILabel *)label:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color { UILabel *l=[UILabel new]; l.text=text; l.font=[UIFont systemFontOfSize:size weight:weight]; l.textColor=color; l.numberOfLines=0; return l; }
+ (UIView *)card { UIView *v=[UIView new]; v.backgroundColor=self.panel; v.layer.cornerRadius=18; v.layer.borderWidth=1; v.layer.borderColor=[UIColor colorWithWhite:1 alpha:.09].CGColor; v.translatesAutoresizingMaskIntoConstraints=NO; return v; }
@end
