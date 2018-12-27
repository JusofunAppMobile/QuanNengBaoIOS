//
//  DetailInformationVC.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/18.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "DetailInformationVC.h"
#import "ChangeIndustryOrAreaController.h"
#import "ModifyCompanyViewController.h"
#define Back_COLOR [UIColor colorWithRed:235.0/255.0 green:236/255.0 blue:238/255.0 alpha:1.0];

#define SIZE_SCALE  ([UIScreen mainScreen].bounds.size.width / 320.0)

@interface DetailInformationVC ()<UITextFieldDelegate,ChangeIndustryOrAreaDelegate,ModifyCompanyViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

{
    
    UITextField    *_phoneNumberTF;
    UITextField    *_PasswordTF;
    UITextField    *_userNameTF;
    UIImageView    *_heandImageView;
    UIButton       *_BindingLable;
    UIButton       *ModifyButton;
    UIButton       *PositionButton;
    NSString       *_theImagePath;
    BOOL           _isRegist;
    NSString       *_theJobId;
    BOOL           _Binding;
    NSString       *_photoUrl;
    UIScrollView   *_BackScrollview;
    NSString       *_tempImgPath;
    
}





@end

@implementation DetailInformationVC

- (void)ChoiceCompanyName:(NSString *)comName JobId:(NSString *)jobId
{
    
    
    _theJobId = jobId;
    [ModifyButton setTitle:comName forState:UIControlStateNormal];
    [ModifyButton setTitleColor:KHexRGB(0x333333) forState:UIControlStateNormal];
}

-(void)changeIndustryOrAreaCellSelected:(NSDictionary *)model andSaveDic:(NSMutableArray *)dic
{
    

    _positionName = model[@"name"];
    _positionID = model[@"parentid"];
    [PositionButton setTitle:model[@"name"] forState:UIControlStateNormal];
    [PositionButton setTitleColor:KHexRGB(0x333333) forState:UIControlStateNormal];
}

-(void)layout
{
    
    _BackScrollview = [[UIScrollView alloc]init];
    _BackScrollview.backgroundColor = [UIColor clearColor];
    _BackScrollview.bouncesZoom = YES;
    _BackScrollview.frame = CGRectMake(0, KNavigationBarHeight, [UIScreen mainScreen].bounds.size.width, KDeviceH-KNavigationBarHeight);
    
    [self.view addSubview:_BackScrollview];
    
    _heandImageView = [[UIImageView alloc]initWithFrame:CGRectMake((KDeviceW - 75)/2, 30, 75, 75)];
    _heandImageView.backgroundColor = [UIColor clearColor];
    _heandImageView.image = [UIImage imageNamed:@"默认头像"];
    _heandImageView.layer.masksToBounds = YES;
    _heandImageView.layer.cornerRadius = 75/2.0;
    
    
    UIButton *changeHeandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeHeandBtn.frame = _heandImageView.frame;
    changeHeandBtn.backgroundColor = [UIColor clearColor];
    [changeHeandBtn addTarget:self action:@selector(heandBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    for (NSInteger i = 0; i < 5; i++) {
//
//        UIView *backView = [[UIView alloc]init];
//        backView.backgroundColor = [UIColor whiteColor];
//        backView.frame = CGRectMake(15, 135 + 70*i, KDeviceW-30, 50);
//        [_BackScrollview addSubview:backView];
//    }
    //手机号
    
    _BindingLable = [[UIButton alloc]init];
    [_BindingLable setTitle:@"已绑定" forState:UIControlStateNormal];
    _BindingLable.userInteractionEnabled = NO;
    _BindingLable.titleLabel.font = [UIFont systemFontOfSize:13];
    [_BindingLable setTitleColor:KHexRGB(0x1e9efb) forState:UIControlStateNormal];
    _BindingLable.frame = CGRectMake(KDeviceW - 50 - 27, 135, 50, 50);
    
    _phoneNumberTF = [[UITextField alloc]init];
    _phoneNumberTF.font=[UIFont systemFontOfSize:16];
    _phoneNumberTF.delegate = self;
    _phoneNumberTF.backgroundColor = [UIColor clearColor];
    _phoneNumberTF.frame = CGRectMake(27, 135, KDeviceW - 27*2-_BindingLable.width, 50);
    _phoneNumberTF.textColor = KHexRGB(0x333333);
    _phoneNumberTF.placeholder = @"手机号";
    _phoneNumberTF.text = _phoneNum;
    _phoneNumberTF.userInteractionEnabled = NO;
    
    
   
    //    [_BindingLable addTarget:self action:@selector(BindingClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //密码
    _PasswordTF = [[UITextField alloc]init];
    _PasswordTF.font=[UIFont systemFontOfSize:16];
    _PasswordTF.delegate = self;
    _PasswordTF.backgroundColor = [UIColor clearColor];
    _PasswordTF.frame = CGRectMake(27,135 + 70 , KDeviceW - 27*2, 50);
    _PasswordTF.placeholder = @"请输入密码";
    _PasswordTF.textColor = KHexRGB(0x333333);
    _PasswordTF.secureTextEntry = YES;
    
    
    //姓名
    _userNameTF = [[UITextField alloc]init];
    _userNameTF.font=[UIFont systemFontOfSize:16];
    _userNameTF.delegate = self;
    _userNameTF.backgroundColor = [UIColor clearColor];
    _userNameTF.frame = CGRectMake(27,135 + 70 *2.0 , KDeviceW - 27*2, 50);
    _userNameTF.placeholder = @"请输入姓名";
    _userNameTF.textColor = KHexRGB(0x333333);
    
    
    //公司名
    ModifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ModifyButton.frame = CGRectMake(27,135 + 70*3.0, KDeviceW - 27*2, 50);
    [ModifyButton setTitle:@"请输入公司名" forState:UIControlStateNormal];
    [ModifyButton setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
    ModifyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    ModifyButton.backgroundColor = [UIColor clearColor];
    ModifyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [ModifyButton addTarget:self action:@selector(ModifyClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //职位
    PositionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    PositionButton.frame = CGRectMake(27,135 + 70*4.0 , KDeviceW - 27*2, 50);
    [PositionButton setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
    [PositionButton setTitle:@"请选择职位" forState:UIControlStateNormal];
    PositionButton.titleLabel.font = [UIFont systemFontOfSize:16];
    PositionButton.backgroundColor = [UIColor clearColor];
    PositionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [PositionButton addTarget:self action:@selector(postionClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *ArrowImageView = [[UIImageView alloc]init];
    ArrowImageView.image = [UIImage imageNamed:@"canTouchIcon"];
    ArrowImageView.frame = CGRectMake(KDeviceW- 30, PositionButton.frame.origin.y+(50-13)/2, 7, 13);
    
    //完成
    UIButton *OKButton = [UIButton buttonWithType:UIButtonTypeCustom];
    OKButton.frame = CGRectMake(15,CGRectGetMaxY(PositionButton.frame) + 35,  KDeviceW-15*2, 40);
    [OKButton setTitle:@"确认" forState:UIControlStateNormal];
    OKButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [OKButton setTitleColor:KHexRGB(0xffffff) forState:UIControlStateNormal];
    [OKButton setBackgroundImage:KImageName(@"圆角渐变") forState:UIControlStateNormal];
    [OKButton addTarget:self action:@selector(OKBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_BackScrollview addSubview:_heandImageView];
    [_BackScrollview addSubview:changeHeandBtn];
    [_BackScrollview addSubview:_phoneNumberTF];
    [_BackScrollview addSubview:_BindingLable];
    [_BackScrollview addSubview:_PasswordTF];
    [_BackScrollview addSubview:_userNameTF];
    [_BackScrollview addSubview:ModifyButton];
    [_BackScrollview addSubview:PositionButton];
    [_BackScrollview addSubview:OKButton];
    [_BackScrollview addSubview:ArrowImageView];
    
    [self addLineWithY:_phoneNumberTF.maxY];
    [self addLineWithY:_PasswordTF.maxY];
    [self addLineWithY:_userNameTF.maxY];
    [self addLineWithY:ModifyButton.maxY];
    [self addLineWithY:PositionButton.maxY];

    
    _BackScrollview.contentSize = CGSizeMake(KDeviceW, CGRectGetMaxY(OKButton.frame)+20);
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarTitle:@"补充信息" ];
    [self setBackBtn:@"back"];
    
    [self layout];
    
}

-(void)OKBtnClick
{
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    if (!_PasswordTF.text || [_PasswordTF.text isEqualToString:@""]) {
        //        [self showHUDSuccessWithStatus:];
        [MBProgressHUD showHint:@"请输入密码" toView:self.view];
        return;
    }
    if (!_userNameTF.text || [_userNameTF.text isEqualToString:@""]) {
        //        [self showHUDSuccessWithStatus:@"请输入姓名"];
        [MBProgressHUD showHint:@"请输入姓名" toView:self.view];
        return;
    }
    
    if ([ModifyButton.titleLabel.text isEqualToString: @"请输入公司名"]) {
        [paraDic setObject:@"" forKey:@"companyid"];
        [paraDic setObject:@"" forKey:@"company"];
    }else{
        [paraDic setObject:_theJobId forKey:@"companyid"];
        [paraDic setObject:ModifyButton.titleLabel.text forKey:@"company"];
        
    }
    if ([PositionButton.titleLabel.text isEqualToString: @"请选择职位"]) {
        [paraDic setObject:@"" forKey:@"job"];
        [paraDic setObject:@"" forKey:@"jobid"];
    }else{
        [paraDic setObject:_positionName forKey:@"job"];
        [paraDic setObject:_positionID forKey:@"jobid"];
    }
    
    //注册
    [paraDic setObject:_phoneNumberTF.text forKey:@"phonenumber"];
    [paraDic setObject:_userNameTF.text forKey:@"nickname"];
    [paraDic setObject:[Tools md5:_PasswordTF.text] forKey:@"password"];
    if (_photoUrl) {
        [paraDic setObject:_photoUrl forKey:@"photo"];
    }else{
        [paraDic setObject:@"" forKey:@"photo"];
    }
    
    [RequestManager postWithURLString:NewRegister parameters:paraDic success:^(id responseObject) {
        
        if ([responseObject[@"result"] integerValue] == 0) {
            
            [User clearTable];
            User *model = [User mj_objectWithKeyValues:[responseObject objectForKey:@"userinfo"]];
            [model save];
           // [MBProgressHUD showSuccess:@"登录成功" toView:nil];
            //[USER gotUserinfo];
            
            [self performSelector:@selector(backAction) withObject:nil afterDelay:1];
            
            
        }else{
            
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"网络错误，请稍候重试！" toView:self.view];
    }];
    
}

-(void)backAction
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)postionClick
{
    
    ChangeIndustryOrAreaController *job = [[ChangeIndustryOrAreaController alloc]
                                           initWithQueryType:QueryTypeJob
                                           andIsChangeJob:YES];
    job.delegate = self;
    [self.navigationController pushViewController:job animated:YES];
}

-(void)heandBtnClick
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照", @"从相册中选择", nil];
    sheet.tag = 1001;
    [sheet showInView:self.view];
}

-(void)ModifyClick
{
    
    ModifyCompanyViewController *detaiVC = [[ModifyCompanyViewController alloc]init];
    detaiVC.modifyName = ModifyButton.titleLabel.text;
    [detaiVC giveDelegate:self];
    [self.navigationController pushViewController:detaiVC animated:YES];
}


#pragma mark -- actionsheet代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2) {
        
        
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//预置类型相册选取
        //判断是否支持摄像头
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 1:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 0:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
            }
        }else {
            switch (buttonIndex) {
                case 1:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 0:
                    return;
            }
        }
        //创建UIImagePickerController
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = sourceType;//设置类型
        [self presentViewController:imagePicker animated:YES completion:nil];//弹出模态
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //_headerImg.image = image;
    UIImage *headImage = [image jm_imageWithRoundedCornersAndSize:CGSizeMake(82, 82) andCornerRadius:41];
    _heandImageView.image = headImage;
    if (image!=nil)
    {
        NSData *data;
        //            data = UIImageJPEGRepresentation(orgImage, 0.5);
        
        data = UIImageJPEGRepresentation([self CompressedImageSize:image.size HeadImage:image], 0.5);
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYYMMddHHMMSS"];
        NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];
        
        //保存图片的路径
        _tempImgPath = [imageDocPath stringByAppendingPathComponent:currentDay];
        _tempImgPath = [NSString stringWithFormat:@"%@.png",_tempImgPath];
        [[NSFileManager defaultManager] createFileAtPath:_tempImgPath contents:data attributes:nil];
        
        [self uploadHeaderImg];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -- 上传头像
-(void)uploadHeaderImg
{
    NSString *userid;
    if (USER.userID.length > 0) {
        userid = USER.userID;
    }else
        userid = @"";
    
    NSDictionary *dict = @{
                           @"userid":userid
                           };
    NSLog(@"----%@",userid);
    [RequestManager uploadWithURLString:UploadHeaderImg_Post parameters:dict progress:^(NSProgress *progress) {
        
    } uploadParam:_tempImgPath success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 0) {
            
            [MBProgressHUD showHint:@"头像上传成功" toView:self.view];
            _photoUrl = [NSString stringWithFormat:@"%@",responseObject[@"photo"]];
            USER.photo = responseObject[@"photo"];
            
            //            [USER gotUserinfo];
            
            [self setHeadImage];
            
            
        }else{
            
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"网络错误，请稍候重试！" toView:self.view];
    }];
}

- (UIImage *)CompressedImageSize:(CGSize)imageSize HeadImage:(UIImage *)image{
    
    
    CGSize headSize;
    if (imageSize.width >= imageSize.height) {
        
        if (imageSize.width > 1000.0) {
            
            headSize = CGSizeMake(1000.0, imageSize.width/1000.0* imageSize.height);
        }else if (imageSize.width < 150.0){
            
            headSize = CGSizeMake(150/imageSize.height * imageSize.width, 150);
        }else{
            
            headSize = imageSize;
        }
    }else{
        
        if (imageSize.height > 1000.0) {
            
            headSize = CGSizeMake(imageSize.height/1000.0*imageSize.width,1000.0);
        }else if (imageSize.height < 150.0){
            
            headSize = CGSizeMake(150,150/imageSize.width * imageSize.height );
        }else{
            
            headSize = imageSize;
        }
    }
    
    UIImage *headImage = [self imageCompressForSize:image targetSize:headSize];
    return headImage;
}

//压缩图片
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

//创建分割线
- (void)addLineWithY:(CGFloat)y{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(27, y, KDeviceW-27*2, 1)];
    view.backgroundColor = KHexRGB(0xf2f2f2);
    [_BackScrollview addSubview:view];
}

-(void)setHeadImage
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:USER.photo]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                UIImage *headImage = [image jm_imageWithRoundedCornersAndSize:CGSizeMake(82, 82) andCornerRadius:41];
                                _heandImageView.image = headImage;
                            }
                        }];
    
}

@end
