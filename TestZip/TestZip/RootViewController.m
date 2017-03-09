//
//  RootViewController.m
//  TestZip
//
//  Created by 刘松坡 on 2017/2/27.
//  Copyright © 2017年 languang. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) NSString *zipPath;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *zipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zipButton.frame = CGRectMake(100, 150, 100, 50);
    [zipButton setTitle:@"Zip" forState:UIControlStateNormal];
    [zipButton addTarget:self action:@selector(zipPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zipButton];
    
    UIButton *unZipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    unZipButton.frame = CGRectMake(100, 250, 100, 50);
    [unZipButton setTitle:@"UnZip" forState:UIControlStateNormal];
    [unZipButton addTarget:self action:@selector(unZipPressed) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:unZipButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 350, 100, 20)];
    label.text = NSLocalizedString(@"Test", nil);
    [self.view addSubview:label];
}
//压缩
- (void)zipPressed
{
    NSLog(@"This is zip");
    //文件夹
    NSString *sampleDataPath = [[NSBundle mainBundle].bundleURL URLByAppendingPathComponent:@"Test Data" isDirectory:YES].path;
    self.zipPath = [NSString stringWithFormat:@"%@/\%@.zip", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject], @"test"];
    //小文件
//    NSString *sampleDataPath = [[NSBundle mainBundle].bundleURL URLByAppendingPathComponent:@"PUSH原理与机制" isDirectory:YES].path;
//    NSString *zipPath = [NSString stringWithFormat:@"%@/\%@.zip", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject], @"test2"];
    
    BOOL success = [SSZipArchive createZipFileAtPath:self.zipPath withContentsOfDirectory:sampleDataPath];
    if (success) {
        NSLog(@"zip success");
    }else
    {
        NSLog(@"zip failure");
    }
}

- (void)unZipPressed
{
    NSLog(@"This is unZip");
    
    NSString *zipPath = self.zipPath;
    NSString *zipFileName = @"test";
    NSError *error = nil;
    NSArray<NSString *> *documentFileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] error:&error];
    if (error) {
        //如果扫描document文件夹出错，直接建立新文件夹覆盖
        [self unzipFileAtPath:zipPath destinationFileName:zipFileName fileCount:0];
    }else
    {
        //document文件夹下存在几个同样名字的文件夹
        NSMutableArray *subFileArray = [NSMutableArray arrayWithCapacity:0];//同名字文件夹
        [documentFileArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:zipFileName] && ![obj isEqualToString:[zipFileName stringByAppendingString:@".zip"]]) {
                [subFileArray addObject:obj];
            }
        }];
        [self unzipFileAtPath:zipPath destinationFileName:zipFileName fileCount:subFileArray.count];
    }
    
//    //先建立解压文件夹
//    NSString *documentPath = [NSString stringWithFormat:@"%@/\%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject], @"test3"];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Test Data" ofType:@"zip"];
//    
//    NSURL *fileUrl = [NSURL fileURLWithPath:documentPath];
//    NSError *error = nil;
//    [[NSFileManager defaultManager] createDirectoryAtURL:fileUrl withIntermediateDirectories:YES attributes:nil error:&error];
//    if (error) {
//        NSLog(@"%@", error.localizedDescription);
//    }
//    NSString *unZipPath = fileUrl.path;
//    BOOL success = [SSZipArchive unzipFileAtPath:path toDestination:unZipPath];
//    if (success) {
//        NSLog(@"unZip success");
//    }else
//    {
//        NSLog(@"unZip failure");
//    }
}
//创建新文件夹并解压缩
- (void)unzipFileAtPath:(NSString *)zipPath destinationFileName:(NSString *)fileName fileCount:(NSInteger)fileCount
{
    NSString *tempFileName = fileName;
    if (fileCount != 0) {
        tempFileName = [tempFileName stringByAppendingFormat:@"%ld", fileCount];
    }
    NSString *unzipPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:tempFileName];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:unzipPath withIntermediateDirectories:YES attributes:nil error:&error];
    //start loading
    BOOL result = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            //stop loading
            
        }
    }];
    if (result) {
        NSLog(@"unZip success");
//        NSArray<NSString *> *subFileArray = [[[NSFileManager defaultManager] enumeratorAtPath:unzipPath] allObjects];
//        NSArray *subPathArray = [[NSFileManager defaultManager] subpathsAtPath:unzipPath];
//        [subFileArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"%ld--%@", idx, obj);
//        }];
//        [subPathArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"%ld--%@", idx, obj);
//        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
