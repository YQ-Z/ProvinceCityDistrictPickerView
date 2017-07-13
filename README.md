# ProvinceCityDistrictPickerView
Custom province - city - district pickerView

![PickeViewGif](https://github.com/YQ-Z/ProvinceCityDistrictPickerView/blob/master/Screenshots/YQPCDPickerViewSample.gif)
# Requirements
iOS 8.0 or later

# Example Usage
```
[[YQPCDView sharedInstance]createPCDViewAddTo:self.view];
    [YQPCDView sharedInstance].delegate = self;
```
```
#pragma nark - YQPCDViewDelegate
- (void)doneBackForProvince:(NSString *)province city:(NSString *)city district:(NSString *)district {
    NSLog(@"%@---%@---%@",province,city,district);
}
```
