//
//  KDFMapViewController.m
//  KDF
//
//  Created by qianfeng on 16/1/14.
//  Copyright © 2016年 kongdefu. All rights reserved.
//
//自己配置 iOS8以及以上版本：
//使用定位服务的info.plist的配置：
//NSLocationWhenInUseUsageDescription
//NSLocationAlwaysUsageDescription

#import "KDFMapViewController.h"
#import <MapKit/MapKit.h>

#define PATH @"imagePath"

@interface KDFMapViewController ()<MKMapViewDelegate>
{
    MKMapView *myMapView;
    CLLocationManager *_manager;
    UIView *_animationView;
    UILabel *detailLabel;
    NSMutableArray *_arr;
    int a;
}
@end

@implementation KDFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI{
    self.title = @"定位";
    _arr = [NSMutableArray new];
    a = 12345;
    self.view.backgroundColor = [UIColor whiteColor];
    myMapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:myMapView];
    if ([CLLocationManager locationServicesEnabled]) {
        _manager = [CLLocationManager new];
        // 向用户申请定位权限
        [_manager requestWhenInUseAuthorization];
        // 移动多少米定位一次
        _manager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        // 定位精度达到多少米的要求
        _manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        myMapView.delegate = self;
         myMapView.showsUserLocation = YES;
        // 给MKMapView添加一个长按事件
        UIGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [myMapView addGestureRecognizer:longPressGesture];
        
           }
    //自定义rightBarButtonItem
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setTitle:@"移除标记" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClickedOne:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
    
    [self creatAinmationView];
}

//动画视图
- (void)creatAinmationView{
    _animationView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/8, -SCREEN_HEIGHT/4, 6*SCREEN_WIDTH/8, SCREEN_HEIGHT/4)];
    _animationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mapbg"]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    label.text = @"详细地址:";
    detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,40, 6*SCREEN_WIDTH/8, 80)];
    [detailLabel addSubview:label];
    [_animationView addSubview:detailLabel];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont systemFontOfSize:16];
    detailLabel.numberOfLines = 0;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [_animationView addGestureRecognizer:tapGesture];
    [self.view addSubview:_animationView];
    
}
- (void)tapGesture:(UITapGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.5 animations:^{
        _animationView.frame = CGRectMake(SCREEN_WIDTH/8, -SCREEN_HEIGHT/4, 6*SCREEN_WIDTH/8, SCREEN_HEIGHT/4);
        
    } completion:nil];
}
-(void)longPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按");
        // 得到屏幕上长按的坐标
        CGPoint point = [recognizer locationInView:myMapView];
        NSLog(@"%f-%f", point.x, point.y);
        [self addPinView:point];
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"松手");
    }
}
-(void)addPinView:(CGPoint)point{
    //将屏幕上的点转换成经纬度
    CLLocationCoordinate2D coordinate = [myMapView convertPoint:point toCoordinateFromView:myMapView];
    NSLog(@"%f-%f", coordinate.latitude, coordinate.longitude);
    // 创建遮盖物
    MKPointAnnotation * annotation = [MKPointAnnotation new];
    // 设置经纬度
    annotation.coordinate = coordinate;
    // 反编码 得到标题
    [self reverseGeocode:coordinate annotion:annotation];
//    annotation.subtitle = @"测试";
    // 添加大头针
    [myMapView addAnnotation:annotation];
}
// 定位的代理方法
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //只在开始的时候执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 以用户位置为中心点，地图放大(1000是方圆1000米)
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([userLocation coordinate], 1000, 1000);
        [mapView setRegion:region animated:YES];
    });
}

//mapView的代理方法 给每一个annotation设置视图属性

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //当前的位置
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKPinAnnotationView * pinView = [[MKPinAnnotationView alloc]init];
        pinView.pinTintColor = [UIColor redColor];// 设置大头针颜色
        // 显示信息
        pinView.canShowCallout = YES;
//        UIButton * btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        pinView.rightCalloutAccessoryView = btn;
        NSString * path = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), PATH];
        //通过路径找到图片
         UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            view.image = image;
        }else{
            view.image = [UIImage imageNamed:@"head1"];
        }
        pinView.leftCalloutAccessoryView = view;
        return pinView;
    }

    //大头针视图
  MKPinAnnotationView * pinView = [[MKPinAnnotationView alloc]init];
        pinView.pinTintColor = [UIColor blueColor];// 设置大头针颜色
        pinView.animatesDrop = YES;// 设置是否有掉落动画
        pinView.draggable = YES;// 设置是否可以拖动
        // 显示信息
        pinView.canShowCallout = YES;
        // 创建右边视图
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //从12345开始
        btn.tag = a++;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = btn;
 //     创建左边视图
        UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"map1"]];
        view.frame = CGRectMake(0, 0, 50, 50);
        pinView.leftCalloutAccessoryView = view;
    
        return pinView;
}
#pragma mark--点击事件
//删除所有标记
- (IBAction)btnClickedOne:(id)sender{
    if ([myMapView.annotations isKindOfClass:[MKUserLocation class]]) {
        NSLog(@"当前自己位置");
    }else{
        [myMapView removeOverlays:myMapView.overlays];
        [myMapView removeAnnotations:myMapView.annotations];
    }

}
-(IBAction)btnClicked:(UIButton *)sender{
//通过detailLabel显示详细地址
    detailLabel.text = _arr[sender.tag-12345];
    [UIView animateWithDuration:0.5 animations:^{
              _animationView.frame = CGRectMake(SCREEN_WIDTH/8, SCREEN_HEIGHT/4,6*SCREEN_WIDTH/8, SCREEN_WIDTH/2);
            } completion:nil];
}

//反编码得到当前位置的中文信息
-(void)reverseGeocode:(CLLocationCoordinate2D) coordinate annotion:(MKPointAnnotation *)annotion{
    CLLocationDegrees longitude = coordinate.longitude;
    CLLocationDegrees latitude = coordinate.latitude;
    CLLocation *location =[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    CLGeocoder * geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count == 0) {
            NSLog(@"没有找到指定的位置");
            [_arr addObject:@"sorry，没有找到该位置的详细地址！"];
            annotion.title = @"no find";
            annotion.subtitle = @"no find";
        }else{
            for (CLPlacemark *placemark in placemarks) {
                NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@",placemark.name,placemark.locality,placemark.country,placemark.postalCode);
                NSLog(@"%.2f---%.2f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
                annotion.title = placemark.locality;
                annotion.subtitle = placemark.name;
                [_arr addObject:annotion.subtitle];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
