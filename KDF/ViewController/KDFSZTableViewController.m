//
//  KDFSZTableViewController.m
//  KDF
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFSZTableViewController.h"
#import "SDImageCache.h"

#define PATH @"imagePath"

@interface KDFSZTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *_imageView;
    
    __weak IBOutlet UILabel *dataLabel;
}

@end

@implementation KDFSZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    self.title = @"设置";
    int byteSize = (int)[SDImageCache sharedImageCache].getSize;
    //M大小
    double size = byteSize /1000.0 /1000.0;
    dataLabel.text = [NSString stringWithFormat:@"缓存为%0.2fM",size];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置headerView的视图
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homebg"]];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100) / 2, (200-100) / 2, 100, 100)];
    //设置图片 问题************
    NSString * path = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), PATH];
    //通过路径找到图片
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image) {
        _imageView.image = image;
    }else{
        _imageView.image = [UIImage imageNamed:@"head1"];
    }
    
    _imageView.layer.cornerRadius = 50;
    _imageView.layer.borderWidth = 0.5;
    _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imageView.layer.masksToBounds = YES;
    [headerView addSubview:_imageView];
    self.tableView.tableHeaderView = headerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark--点击事件
-(IBAction)btnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 去除选中时的背景
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                // 改变头像代码
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择",@"还原默认图片", nil];
                [actionSheet showInView: self.view];
            }
            break;
             case 1:
                //清除缓存代码
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"清理完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                [[SDImageCache sharedImageCache] clearDisk];
                int byteSize = (int)[SDImageCache sharedImageCache].getSize;
                //M大小
                double size = byteSize /1000.0 /1000.0;
                dataLabel.text = [NSString stringWithFormat:@"缓存%0.2fM",size];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark--代理方法
//ActionSheet的代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self selectPhoto];
            break;
        case 2:
        {
            _imageView.image = [UIImage imageNamed:@"head1"];
            
            [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), PATH] contents:nil attributes:nil];
            
        }
            break;
            
        default:
            break;
    }
}
-(void)takePhoto{
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:type]){
        UIImagePickerController * ipc = [UIImagePickerController new];
        ipc.delegate = self;
        ipc.sourceType = type;
        ipc.allowsEditing = YES;
        [self presentViewController:ipc animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"设备不支持拍照!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}
-(void)selectPhoto{
    UIImagePickerController * ipc = [UIImagePickerController new];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}
//当完成选择照片时 调用该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    NSLog(@"%@", info);
    if([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
        UIImage *image = info[@"UIImagePickerControllerEditedImage"];
        _imageView.image = image;

        //当图片选择完成时 说明要添加图片 或改动图片 就将_isDealPhoto置为YES
        //        _isDealPhoto = YES;
        //将图片保存到沙盒里面
        // 得到图片的路径
  //********
        NSString * imageDirectory = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
        if (image) {
            // 得到图片的二进制流
            NSData *data = UIImagePNGRepresentation(image);
            if (!data) {
                data = UIImageJPEGRepresentation(image, 0.5);
            }
            //将图片放在指定的路径上（沙盒里面）
            [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/%@", imageDirectory, PATH] contents:data attributes:nil];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
