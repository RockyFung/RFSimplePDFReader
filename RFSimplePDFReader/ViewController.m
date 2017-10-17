//
//  ViewController.m
//  RFSimplePDFReader
//
//  Created by 冯剑 on 2017/10/17.
//  Copyright © 2017年 冯剑. All rights reserved.
//

#import "ViewController.h"
#import "PDFScrollView.h"

#define BARBUTTON(TITLE, SELECTOR) 	[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define TOOLBAR_HEIGHT 44.0f
#define PAGING_AREA_WIDTH 48.0f


@interface ViewController ()
@property (nonatomic, strong) PDFScrollView *pdfScrollView;
@property (nonatomic, strong) UIToolbar *toolbar;
@end

@implementation ViewController{
    UIBarButtonItem *pageNumberItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pdfScrollView = [[PDFScrollView alloc]initWithFrame:self.view.bounds resource:@"TestPage.pdf"];
    [self.view addSubview:self.pdfScrollView];
    
    // 创建工具条
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, TOOLBAR_HEIGHT)];
    self.toolbar = myToolbar;
    
    
    UIBarButtonItem *nullItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];;
    NSString *title = [NSString stringWithFormat:@"[TestPage.pdf]"];
    UIBarButtonItem *fileNameItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                             style:UIBarButtonItemStylePlain
                                                            target:nil
                                                            action:nil];

    pageNumberItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self refreshPageNumber];
    UIBarButtonItem *preBtn = BARBUTTON(@"上页", @selector(clickPre:));
    UIBarButtonItem *nextBtn = BARBUTTON(@"下页", @selector(clickNext:));
    
    NSArray *items = [NSArray arrayWithObjects:nullItem,fileNameItem,nullItem,pageNumberItem,preBtn,nextBtn, nil];
    self.toolbar.hidden = NO;
    [self.toolbar setItems:items animated:NO];
    [self.view addSubview:self.toolbar];
 
}

-(void)clickPre:(id)sender
{
    [self.pdfScrollView clickPre];
    [self refreshPageNumber];
}

-(void)clickNext:(id)sender
{
    [self.pdfScrollView clickNext];
    [self refreshPageNumber];
}
- (void)refreshPageNumber{
    pageNumberItem.title = [NSString stringWithFormat:@"%ld/%ld",self.pdfScrollView.pageNumber,self.pdfScrollView.pageCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
