//
//  YQPCDView.m
//  YQPCDPickerViewSample
//
//  Created by OSX on 17/7/13.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import "YQPCDView.h"
//界面宽高
#define YQScreenHeight [UIScreen mainScreen].bounds.size.height
#define YQScreenWidth [UIScreen mainScreen].bounds.size.width
//界面宽高比例（参数以UI效果图来修改）
#define YQSH YQScreenHeight / 667
#define YQSW YQScreenWidth / 375

static dispatch_once_t onceToken;
static YQPCDView *instance = nil;

@interface YQPCDView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) UIView *bgView;//背景
@property (strong, nonatomic) UIPickerView *pickerView;//地址选择器
@property (strong, nonatomic) UIButton *cancelButton;//取消按钮
@property (strong, nonatomic) UIButton *doneButton;//确定按钮
@property (strong, nonatomic) UILabel *pickerViewTitleLabel;//标题
@property (strong, nonatomic) NSDictionary *dataDictionary;//数据字典
@property (strong, nonatomic) NSArray *provinceArray;//省数组
@property (strong, nonatomic) NSArray *cityArray;//市数组
@property (strong, nonatomic) NSArray *districtArray;//区数组
@property (nonatomic,assign) NSInteger index1; // 省下标
@property (nonatomic,assign) NSInteger index2; // 市下标
@property (nonatomic,assign) NSInteger index3; // 区下标
@property (nonatomic,strong) NSArray *selections; //选择的三个下标
@property (strong, nonatomic) UILabel *pickerLabel;//设置pickerView字体大小用

//记录数据
@property (strong, nonatomic) NSString *province;//省
@property (strong, nonatomic) NSString *city;//市
@property (strong, nonatomic) NSString *district;//区
@end

@implementation YQPCDView

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        instance = [[YQPCDView alloc] init];
    });
    return instance;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
    }
    return _bgView;
}

//地址选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, YQSH * 35, self.bounds.size.width, self.bgView.bounds.size.height - YQSH * 35)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        
    }
    return _pickerView;
}

//取消按钮
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, YQSW * 80, YQSH * 35);
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        [_cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

//标题
- (UILabel *)pickerViewTitleLabel {
    if (!_pickerViewTitleLabel) {
        _pickerViewTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(YQSW * 80, 0, self.bounds.size.width - YQSW * 160, YQSH * 35)];
        _pickerViewTitleLabel.text = @"选择区域";
        _pickerViewTitleLabel.backgroundColor = [UIColor whiteColor];
        _pickerViewTitleLabel.textAlignment = NSTextAlignmentCenter;
        _pickerViewTitleLabel.font = [UIFont systemFontOfSize:20.0f];
        _pickerViewTitleLabel.textColor = [UIColor blackColor];
        
    }
    return _pickerViewTitleLabel;
}

//确定按钮
- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.frame = CGRectMake(self.bgView.bounds.size.width - YQSW * 80, 0, YQSW * 80, YQSH * 35);
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _doneButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_doneButton setBackgroundColor:[UIColor whiteColor]];
        [_doneButton addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

//数据字典
- (NSDictionary *)dataDictionary {
    if (!_dataDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ProvinceCityDistrict" ofType:@"plist"];
        _dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _dataDictionary;
}

//设置pickerView字体大小用
- (UILabel *)pickerLabel {
    if (!_pickerLabel){
        _pickerLabel = [[UILabel alloc] init];
        _pickerLabel.adjustsFontSizeToFitWidth = YES;
        [_pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [_pickerLabel setBackgroundColor:[UIColor whiteColor]];
        [_pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    return _pickerLabel;
}

- (void)createPCDViewAddTo:(UIView *)view {
    self.frame = view.bounds;
    self.bgView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height / 3);
    [self.bgView addSubview:self.pickerView];
    [self.bgView addSubview:self.cancelButton];
    [self.bgView addSubview:self.doneButton];
    [self.bgView addSubview:self.pickerViewTitleLabel];
    self.backgroundColor = [UIColor clearColor];
    [self addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    if (self.selections.count) {
        self.index1 = [self.selections[0] integerValue];
        self.index2 = [self.selections[1] integerValue];
        self.index3 = [self.selections[2] integerValue];
    }
    [self calculateData];
    [view addSubview:self];
    
    [UIView animateWithDuration:1.0 animations:^{
       self.bgView.frame = CGRectMake(0, self.bounds.size.height / 3 * 2, self.bounds.size.width, self.bounds.size.height / 3);
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//根据下标数组解析对应数组
- (void)calculateData {
    //省
    self.provinceArray = [self.dataDictionary allKeys];
    //市
    self.cityArray = [[self.dataDictionary[self.provinceArray[self.index1]] firstObject]allKeys];
    //区
    self.districtArray = [[self.dataDictionary[self.provinceArray[self.index1]] firstObject] objectForKey:self.cityArray[self.index2]] ;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.provinceArray.count;
            break;
        case 1:
            return self.cityArray.count;
            break;
        case 2:
            return self.districtArray.count;
            break;
            
        default:
            break;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return YQScreenWidth / 3;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return YQSH * 35;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    self.pickerLabel = (UILabel*)view;
    self.pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return self.pickerLabel;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    self.province = self.provinceArray[self.index1];
    self.city = self.cityArray[self.index2];
    self.district = self.districtArray[self.index3];
    switch (component) {
        case 0:
            return self.provinceArray[row];
            break;
        case 1:
            return self.cityArray[row];
            break;
        case 2:
            return self.districtArray[row];
            break;
        default:
            break;
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.index1 = row;
            self.index2 = 0;
            self.index3 = 0;
            [self calculateData];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
            
        case 1:
            self.index2 = row;
            self.index3 = 0;
            [self calculateData];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            break;
            
        case 2:
            self.index3 = row;
            break;
            
        default:
            break;
    }
    self.province = self.provinceArray[self.index1];
    self.city = self.cityArray[self.index2];
    self.district = self.districtArray[self.index3];
}

//确定按钮点击事件
- (void)doneClick:(UIButton *)sender {
    [self.delegate doneBackForProvince:self.province city:self.city district:self.district];
    [self close];
}

- (void)close {
    [UIView animateWithDuration:1.0 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.bgView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height / 3);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self doDealloc];
    }];
    
}

- (void)doDealloc {
    onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
    instance = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
