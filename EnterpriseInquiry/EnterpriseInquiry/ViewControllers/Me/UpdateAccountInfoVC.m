//
//  UpdateAccountInfoVC.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/9.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "UpdateAccountInfoVC.h"
#import "UpdateUserInfoCell.h"
#import "UIImage+Wechat.h"
#import "UpdatePhoneNumberVC.h"
#import "CompanySearchVC.h"
#import "ChangeIndustryOrAreaController.h"
@interface UpdateAccountInfoVC ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ChangeIndustryOrAreaDelegate,CompanySearchDelegate,UITextFieldDelegate>

{
    
    NSArray     *_updateArray;
    UITableView *_mainTableView;
    
    UIImageView *_headerImg;
    UIButton    *_editBtn;
    UITextField *_nickNameField;
    
    UIView      *_pickerBackV;
    UIPickerView*_pickerView;
    NSArray     *_pickerDataSource;
    BOOL        _isOpen;
    BOOL        _isSelected;
    
    NSString    *_selectedSexStr;
    UILabel     *_sexLabel;
    
    NSString    *_positionStr;
    NSString    *_companyName;
    NSString    *_nickNameStr;
    NSString    *_mobileStr;
    NSString    *_jobid;
    NSString    *_companyid;
    
    NSString    *_tempImgPath;
    NSString    *_photoUrl;
    //FileModel   *_fileModel;
}

@end

@implementation UpdateAccountInfoVC

-(void)selectCompanyWithInfo:(NSDictionary *)dict
{

    _companyName = dict[@"normalName"];
    _companyid = dict[@"companyid"];
    [_mainTableView reloadData];
    
}

-(void)changeIndustryOrAreaCellSelected:(NSDictionary *)model andSaveDic:(NSMutableArray *)dic
{
    
    _positionStr = model[@"name"];
    _jobid = model[@"parentid"];
    [_mainTableView reloadData];
}

-(void)layout
{
    
    _mainTableView = [[UITableView alloc] initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH)
                                                  style:UITableViewStylePlain];
    _mainTableView.delegate  = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor  = [UIColor clearColor];
    _mainTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    _mainTableView.tableHeaderView = [self createtableHeaderView];
    _mainTableView.estimatedRowHeight = 0;
    _mainTableView.estimatedSectionHeaderHeight = 0;
    _mainTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_mainTableView];
    
    
    //贴到第一个tableviewcell上
    _nickNameField = [[UITextField alloc] initWithFrame:KFrame(KNavigationBarHeight, 0, KDeviceW-KNavigationBarHeight-35/2, 44)];
    _nickNameField.placeholder = @"请输入昵称";
    _nickNameField.font = KFont(14);
    _nickNameField.delegate = self;
    _nickNameField.textAlignment = NSTextAlignmentRight;
    _nickNameField.textColor = KHexRGB(0x999999);
    
    
    [self createPickView];
}

-(void)createPickView
{
    
    _pickerDataSource = @[@"男",@"女",@"保密"];
    _pickerBackV = [[UIView alloc]
                    initWithFrame:CGRectMake(0,
                                             KDeviceH,
                                             KDeviceW,
                                             200)];
    _pickerBackV.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_pickerBackV];
    
    UILabel *line = [[UILabel alloc]
                     initWithFrame:CGRectMake(0,
                                              0,
                                              KDeviceW,
                                              0.5)];
    line.backgroundColor = KHexRGB(0xeeeeee);
    [_pickerBackV addSubview:line];
    
    _pickerView            = [[UIPickerView alloc]
                              initWithFrame:CGRectMake(0,
                                                       40,
                                                       KDeviceW,
                                                       200-40)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate   = self;
    _pickerView.dataSource = self;
    [_pickerBackV addSubview:_pickerView];
    
    UIButton *doneButton       = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame           = CGRectMake(KDeviceW - 60, 0, 60, 40);
    doneButton.tintColor       = KHexRGB(0x333333);
    doneButton.titleLabel.font = KFont(16);
    [doneButton setTitle:@"完成"
                forState:UIControlStateNormal];
    [doneButton addTarget:self
                   action:@selector(selectDone)
         forControlEvents:UIControlEventTouchUpInside];
    [_pickerBackV addSubview:doneButton];

}

-(UIView*)createtableHeaderView
{
    
    UIView *backView = [[UIView alloc] initWithFrame:KFrame(0, 0, KDeviceW, 84)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = KFrame(14, 0, 50, 84);
    titleLab.font    = KFont(14);
    titleLab.textColor = KHexRGB(0x666666);
    titleLab.text = @"头像";
    [backView addSubview:titleLab];

    
    _headerImg = [[UIImageView alloc] initWithFrame:KFrame(KDeviceW-63-75/2, (84-63)/2, 63, 63)];
    //_headerImg.backgroundColor = KHexRGB(0xf2f2f2);
    _headerImg.image = [UIImage imageNamed:@"默认头像"];
    [self setHeadImage];
    [backView addSubview:_headerImg];
    
    _editBtn = [[UIButton alloc] init];
    _editBtn.frame = _headerImg.frame;
//    [_editBtn setTitle:@"点击修改" forState:UIControlStateNormal];
//    [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _editBtn.backgroundColor = [UIColor clearColor];
//    _editBtn.titleLabel.font = FONT_OF_GLOBAL(14);
    [_editBtn addTarget:self action:@selector(editHeaderImageAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_editBtn];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:KFrame(KDeviceW-35/2-7, (84-13)/2, 7, 13)];
    imgV.image = [UIImage imageNamed:@"canTouchIcon"];
    [backView addSubview:imgV];
    
    UIView *lineV = [[UIView alloc] initWithFrame:KFrame(14, 83, KDeviceW-14, 1)];
    lineV.backgroundColor = KHexRGB(0xf2f2f2);
    [backView addSubview:lineV];
    
//    backView.frame = KFrame(0, 0, KDeviceW, CGRectGetMaxY(_editBtn.frame)+30);
    return backView;
}

-(void)setHeadImage
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:USER.photo]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                             //                                     NSLog(@"%ld",receivedSize/expectedSize);
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                UIImage *headImage = [image jm_imageWithRoundedCornersAndSize:CGSizeMake(82, 82) andCornerRadius:41];
                                _headerImg.image = headImage;
                            }
                        }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
    _mobileStr = USER.mobile;
    [_mainTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setNavigationBarTitle:@"修改资料"];
//    [self setBackBtn:@""];
    [self setNavigationBarTitle:@"修改资料" ];
    [self setBackBtn:@"back"];
    self.view.backgroundColor = KHexRGB(0xf2f2f2);
    
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRight setTitle:@"完成" forState:UIControlStateNormal];
    buttonRight.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    buttonRight.titleLabel.textAlignment = NSTextAlignmentRight;
    buttonRight.frame = CGRectMake(0, 0, 50, 22);
    [buttonRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonRight.titleLabel.font = KFont(16);
    [buttonRight addTarget:self action:@selector(editOverClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightItem;

    _updateArray = @[@"名字",
                     @"企业",
                     @"职位",
                     @"手机"];
    
    _isOpen = NO;
    _isSelected = NO;//是否选了性别
    _selectedSexStr = @"";
    _positionStr = USER.job;
    _companyName = USER.company;
    _nickNameStr = USER.nickname;
    _mobileStr   = USER.mobile;
    _jobid       = USER.jobID;
    _companyid   = USER.companyid;
//    _companyid   = USER.com
    
    [self layout];
    
    
    [KNotificationCenter addObserver:self
                     selector:@selector(TextFieldTextDidChangeNotification:)
                         name:UITextFieldTextDidChangeNotification
                       object:nil];

}



-(void)editOverClick
{
    [self.view endEditing:YES];
    if (_nickNameField.text.length < 2) {
        [MBProgressHUD showError:@"昵称不能少于两个字符" toView:self.view];
        return;
    }
    if (![self checkString:_nickNameField.text]) {
        [MBProgressHUD showError:@"昵称只能由中文、字母或数字组成" toView:self.view];
        return;
    }
    if ( [self IsChinese:_nickNameField.text] && _nickNameField.text.length > 5) {
        [MBProgressHUD showError:@"昵称不能超过5个字符" toView:self.view];
        return;
    }
    if ( ![self IsChinese:_nickNameField.text] && _nickNameField.text.length > 10) {
        [MBProgressHUD showError:@"昵称不能超过10个字符" toView:self.view];
        
        return;
    }
    NSString *photourl = _photoUrl?_photoUrl:@"";
   
    // 密码传空
    NSDictionary *dict = @{
                           @"userid":USER.userID,
                           @"phonenumber":_mobileStr,
                           @"nickname":_nickNameField.text,
                           @"job":_positionStr,
                           @"jobid":_jobid,
                           @"companyname":_companyName,
                           @"companyid":_companyid,
                           @"photo":photourl,
                           @"password":@""
                           };
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:UpdateUserInfo parameters:dict success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 0) {
            [User clearTable];
            User *model = [User mj_objectWithKeyValues:[responseObject objectForKey:@"userinfo"]];
            [model save];
            [MBProgressHUD showHint:@"修改资料成功" toView:self.view];
            [self performSelector:@selector(backAction) withObject:nil afterDelay:1];
            
            [KNotificationCenter postNotificationName:UserinfoChangedNotification object:nil];
            
        }else{
            
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"网络错误，请稍后重试！" toView:self.view];
    }];
}

-(void)backAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 修改头像
-(void)editHeaderImageAction
{
    [self.view endEditing:YES];
    //    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照", @"从相册中选择", nil];
    sheet.tag = 1001;
    [sheet showInView:self.view];
    //    }
}

#pragma mark -- 上传头像
-(void)uploadHeaderImg
{
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSDictionary *dict = @{
                           @"userid":USER.userID,
//                           @"files":_tempImgPath
                           };
    
    [RequestManager uploadWithURLString:UploadHeaderImg_Post parameters:dict progress:^(NSProgress *progress) {
        
    } uploadParam:_tempImgPath success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 0) {
            [MBProgressHUD hideHudToView:self.view animated:YES];
           // [MBProgressHUD showHint:@"头像上传成功" toView:self.view];
            _photoUrl = responseObject[@"photo"];
            //[_headerImg sd_setImageWithURL:[NSURL URLWithString:responseObject[@"photo"]] placeholderImage:nil];
             //[USER gotUserinf
        }else{
        
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"网络错误，请稍候重试！" toView:self.view];
    }];
}

-(void)TextFieldTextDidChangeNotification:(NSNotification*)noti
{
    [self textField:_nickNameField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:_nickNameField.text];
    
}
#pragma mark -- textfield代理

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if ([self IsChinese:textField.text]) {
//
//        if (textField.text.length > 5) {
////            return NO;
//            textField.text = [temp substringToIndex:5];
//        }
//    }else{
//        if (textField.text.length > 10) {
//            textField.text = [temp substringToIndex:10];
//        }
//    }
    return YES;
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
        imagePicker.navigationBar.translucent=NO;
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
    image = [image wcSessionCompress];
    UIImage *headImage = [image jm_imageWithRoundedCornersAndSize:CGSizeMake(82, 82) andCornerRadius:41];
    _headerImg.image = headImage;
    if (image!=nil)
    {
        NSData *data;
        //            data = UIImageJPEGRepresentation(orgImage, 0.5);
        
        data = UIImageJPEGRepresentation(image, 1);
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

#pragma mark -- tableview   delegate datasource  -methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _updateArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellString = @"AccountCellString";
    UpdateUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[UpdateUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titleLabel.text = _updateArray[indexPath.row];
    if (indexPath.row == 0) {
        
        cell.subTitleLabel.hidden = YES;
        cell.imgV.hidden = YES;
        _nickNameField.text = _nickNameStr;
        [cell.contentView addSubview:_nickNameField];
    }
    if (indexPath.row == 1) {
        cell.subTitleLabel.text = _companyName;
    }
    if (indexPath.row == 2) {
//        cell.subTitleLabel.text = _userInfoDict[@"job"];
        cell.subTitleLabel.text = _positionStr;
    }
//    if (indexPath.row == 3) {
////        cell.subTitleLabel.text = _userInfoDict[@"sex"];
//        cell.subTitleLabel.text = _selectedSexStr;
//    }
    if (indexPath.row == 3) {
        cell.subTitleLabel.text = _mobileStr;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.000001;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row;
    
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
            CompanySearchVC *company = [CompanySearchVC new];
            company.delegate = self;
            company.tempCompany = _companyName;
            [self.navigationController pushViewController:company animated:YES];
        }
            break;
        case 2:
        {
            
            ChangeIndustryOrAreaController *job = [[ChangeIndustryOrAreaController alloc]
                                                   initWithQueryType:QueryTypeJob
                                                   andIsChangeJob:YES];
            job.delegate = self;
            [self.navigationController pushViewController:job animated:YES];
        }
            break;
//        case 3:
//        {
//            
//            [self showPickerView];
//        }
//            break;
        case 3:
        {
            UpdatePhoneNumberVC *phone = [UpdatePhoneNumberVC new];
            [self.navigationController pushViewController:phone animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIPickerView代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return  1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return _pickerDataSource.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return _pickerDataSource[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _isSelected = YES;
    _selectedSexStr = _pickerDataSource[row];
}

#pragma mark -- pickerview点击确定
-(void)selectDone
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _pickerBackV.frame = CGRectMake(0, KDeviceH, KDeviceW, 200);
        
    } completion:^(BOOL finished) {
        
        if (!_isSelected) {
            _selectedSexStr = _pickerDataSource[0];
        }
            
        [_mainTableView reloadData];
        
    }];
    [UIView commitAnimations];
    _isOpen = !_isOpen;
}


#pragma mark -- 呈现pickerview
-(void)showPickerView
{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view bringSubviewToFront:_pickerBackV];
        _pickerBackV.frame = !_isOpen ?
        CGRectMake(0, KDeviceH - 200, KDeviceW, 200):
        CGRectMake(0, KDeviceH-KNavigationBarHeight, KDeviceW, 200);
    } completion:^(BOOL finished) {
        
    }];
    [UIView commitAnimations];
    _isOpen = !_isOpen;
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


-(BOOL)checkString:(NSString*)string
{
    
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL enabel;
    if (![pred evaluateWithObject:string]) {
        enabel = NO;
    }else{
        enabel = YES;
    }
    return enabel;
}

//只有数字或字母
-(BOOL)checkStringStrong:(NSString*)string
{
    
    NSString *regex = @"[a-z][A-Z][0-9]";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL enabel;
    if (![predicate evaluateWithObject:string]) {
        enabel = NO;
    }else{
        enabel = YES;
    }
    return enabel;
}

-(BOOL)IsChinese:(NSString *)str {
    
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
