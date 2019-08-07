//
//  ViewController.m
//  NetworkFrame
//
//  Created by scj on 2019/8/7.
//  Copyright © 2019 scj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *urlRequestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    urlRequestBtn.frame = CGRectMake(100, 100, 100, 50);
    [urlRequestBtn setBackgroundColor:[UIColor purpleColor]];
    [urlRequestBtn setTitle:@"请求" forState:UIControlStateNormal];
    [urlRequestBtn addTarget:self action:@selector(requestUrl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:urlRequestBtn];
    
    UIButton *updateImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateImgBtn.frame = CGRectMake(100, 200, 100, 50);
    [updateImgBtn setBackgroundColor:[UIColor purpleColor]];
    [updateImgBtn setTitle:@"上传图片" forState:UIControlStateNormal];
    [updateImgBtn addTarget:self action:@selector(updateUrl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateImgBtn];
    
    UIButton *favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favBtn.frame = CGRectMake(100, 300, 100, 50);
    [favBtn setBackgroundColor:[UIColor purpleColor]];
    [favBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [favBtn addTarget:self action:@selector(favClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:favBtn];
}

//普通请求
- (void)requestUrl {
    /**
     pageId = 1;
     pageSize = 1;
     userCode = 20190805210813240237;
     */
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:InitParams()];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userCode"] = @"20190805210813240237";
    dic[@"pageId"] = @(1);
    dic[@"pageSize"] = @"1";
    //    [AccountAPI(RWMineGameListModel) post:kGetPlayedList params:dic completion:^(RWMineGameListModel *model, RWErrorModel *errorModel) {
    [AccountAPI(NSDictionary) post:kGetPlayedList params:dic completion:^(NSDictionary *model, MYErrorModel *errorModel) {
        if (errorModel) {
            NSLog(@"%@",errorModel.message);
            return;
        }
        if (model.successState) {
            NSLog(@"请求成功");
        }
        else {
            NSLog(@"%@",model[@"message"]);
            return;
        }
    }];
}

//上传图片
- (void)updateUrl {
    NSArray *selectedPhotos = @[@"asd",@"asdf"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i<selectedPhotos.count; i++) {
        NSData *imgData = UIImageJPEGRepresentation(selectedPhotos[i], 0.5);
        NSMutableDictionary *fileDic = [[NSMutableDictionary alloc] init];
        fileDic[@"data"] = imgData;
        switch (i) {
            case 0:
                fileDic[@"imageFile"] = @"imageFile1";
                break;
            case 1:
                fileDic[@"imageFile"] = @"imageFile2";
                break;
            default:
                fileDic[@"imageFile"] = @"imageFile3";
                break;
        }
        [arr addObject:fileDic];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @"1";
    dic[@"content"] = @"asdfasdf";
    [AccountAPI(NSDictionary) postUpload:kFeedbackInsert imgFiles:arr params:dic completion:^(id model, MYErrorModel *errorModel) {
        if (errorModel) {
            
            return;
        }
        if ([model[@"code"] integerValue] == 1) {
            
        }
        else {
            
            return;
        }
    }];
}

//防止重复点击 如收藏/取消收藏
- (void)favClick {
    BOOL isFav = YES;//@"self.infoModel.isCollect";
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    dicParam[@"userCode"] = @"userCode";
    dicParam[@"mapId"] = @"mapId";
    dicParam[@"status"] = @(!isFav);
    [[[[AccountAPI(NSDictionary) rac_post:kGameInfoFavGame params:dicParam] doNext:^(id x) {
        //        self.favButton.userInteractionEnabled = NO;
    }] doCompleted:^{
        //        self.favButton.userInteractionEnabled = YES;
    }] subscribeNext:^(NSDictionary *dic) {
        if (dic.successState) {
            //            self.favButton.selected = !isFav;
            //            self.infoModel.isCollect = !isFav;
        }
    }];
}
@end
