
#import "BaseBaseUIImageView.h"
#import "ProvincesAndCitysControl.h"

@interface CityChooseView : BaseBaseUIImageView
{

}
@property(nonatomic,readonly)ProvincesAndCitysControl *provinceAndCity;
- (void)showCurrentProvince:(NSString *)province city:(NSString *)city;
@end
