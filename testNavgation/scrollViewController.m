//
//  scrollViewController.m
//  OliverTestScorllNavtion
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 Oliver. All rights reserved.
//

#import "scrollViewController.h"
#import "Masonry.h"
#import "firstViewController.h"
#import "secondViewController.h"
#import "threeViewController.h"
#import "BaseViewController.h"
#import "fourViewController.h"
#import "fiveViewController.h"
static CGFloat const labelWidth = 100;
// 修改文字显示的比例
static CGFloat const radioSize = 0.6;
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface scrollViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView * topScrollView;
@property (nonatomic,strong)UIScrollView * contentScrollView;
@property (nonatomic,strong)UIButton * backBtn;
@property (nonatomic,strong)UIView * backView;
@property (nonatomic, strong) NSMutableArray * subTitleLabel;
@property (weak , nonatomic) UILabel *selectedLabel;

@end

@implementation scrollViewController


-(NSMutableArray *)subTitleLabel {
    if (_subTitleLabel == nil) {
        _subTitleLabel = [NSMutableArray array];
    }
    return _subTitleLabel;
}

-(void)loadView{

    [super loadView];
    self.topScrollView = [UIScrollView new];
    self.contentScrollView = [UIScrollView new];
    self.backBtn = [UIButton new];
    self.backView = [UIView new];
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.backgroundColor = [UIColor orangeColor];
    self.backView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.topScrollView];
    [self.view addSubview:self.contentScrollView];
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.backBtn];
    
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.backgroundColor = [UIColor purpleColor];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.width.equalTo(@40);
        make.height.equalTo(@64);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).with.offset(10);
        make.centerX.equalTo(self.backView.mas_centerX);
        make.centerY.equalTo(self.backView.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [self.topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.backView.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@64);
        
    }];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.topScrollView.mas_bottom);
        make.right.equalTo(self.view.mas_right);
       
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    firstViewController *zero = [[firstViewController alloc] init];
    zero.title = @"第一个";
    [self addChildViewController:zero];
    
    secondViewController *one = [[secondViewController alloc] init];
    one.title = @"第二个";
    [self addChildViewController:one];
    
    threeViewController *two = [[threeViewController alloc] init];
    two.title = @"第三个";
    [self addChildViewController:two];
    
    fourViewController *three = [[fourViewController alloc] init];
    three.title = @"第四个";
    [self addChildViewController:three];
    
    fiveViewController *four = [[fiveViewController alloc] init];
    four.title = @"第五个";
    [self addChildViewController:four];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUI];
    [self setupSubViewsTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES; // 使右滑返回手势可用

}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    
}
-(void)backBtnClick{

    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)setData{

}
-(void)setUI{

    NSInteger count = self.childViewControllers.count;
    self.topScrollView.contentSize= CGSizeMake(count * labelWidth, 0);
    self.contentScrollView.contentSize = CGSizeMake(count * ScreenWidth , 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
}

/**
 *  添加所有子控制器的标题，创建label 并给 label 添加点击事件
 */
-(void)setupSubViewsTitle {
    NSUInteger count = self.childViewControllers.count;
    CGFloat labelX = 0;
    CGFloat labelY = 20;
    CGFloat labelHeight = 44;
    for (int i = 0;  i < count; i++) {

        BaseViewController * vc = self.childViewControllers[i];
        UILabel * label = [[UILabel alloc] init];
        labelX = i * labelWidth;
        label.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        label.text = vc.title;
        label.textColor = [UIColor whiteColor];
        label.highlightedTextColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:14];
        label.tag = i;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [self.subTitleLabel addObject:label];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        if (i == 0) {
            [self  titleClick:tap];
        }
        [self.topScrollView addSubview:label];
    }
}
/**
 *  实现点击事件的方法
 */
-(void)titleClick:(UITapGestureRecognizer *)tap {
    UILabel * selectedLabel = (UILabel *)tap.view;
    [self selectedLabelTitle:selectedLabel];
    NSInteger index = selectedLabel.tag;
    CGFloat offsetX = index * ScreenWidth;
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    [self showViewController:index];
    [self setupTitleCenter:selectedLabel];
}
/**
 *  设置选中 label 的颜色
 */
-(void)selectedLabelTitle:(UILabel *)label {
    self.selectedLabel.highlighted = NO;
    self.selectedLabel.transform = CGAffineTransformIdentity;
    self.selectedLabel.textColor = [UIColor whiteColor];
    label.highlighted = YES;
    // 设置初始化时，按钮的尺寸
    label.transform = CGAffineTransformMakeScale(radioSize+1, radioSize+1);
    self.selectedLabel = label;
}
-(void)showViewController:(NSInteger)index {
    CGFloat offsetX = index * ScreenWidth;
    BaseViewController * vc = self.childViewControllers[index];
    if (vc.isViewLoaded) {
        return;
    }
    [self.contentScrollView addSubview:vc.view];
    [UIView animateWithDuration:0.3 animations:^{
        vc.view.frame = CGRectMake(offsetX, 0, ScreenWidth, ScreenHeight);

    }];
}
/**
 *  设置选中状态下的标题居中
 */
-(void)setupTitleCenter:(UILabel *)centerLabel {
    // 中间label的x值 = 传进来中间label的x值 - 屏幕宽度的一半
    CGFloat offsetX = centerLabel.center.x - ScreenWidth * 0.5;
    if (offsetX < 0) {  // 如果计算完之后是负数，证明
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.topScrollView.contentSize.width - ScreenWidth;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.topScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;

    if (!isnan(curPage)) {
        NSInteger leftIndex = curPage;
        NSInteger rightIndex = leftIndex + 1;
        UILabel * leftLabel = self.subTitleLabel[leftIndex];
        UILabel * rightLabel;
        if (rightIndex < self.subTitleLabel.count - 1) {
            rightLabel = self.subTitleLabel[rightIndex];
        }
        CGFloat rightScale = curPage - leftIndex;
        CGFloat leftScale = 1 - rightScale;
        leftLabel.transform = CGAffineTransformMakeScale(leftScale * radioSize + 1, leftScale * radioSize + 1);
        rightLabel.transform = CGAffineTransformMakeScale (rightScale * radioSize + 1 , rightScale * radioSize + 1);
    }
   
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self showViewController:index];
    UILabel * selectedLabel = self.subTitleLabel[index];
    [self selectedLabelTitle:selectedLabel];
    [self setupTitleCenter:selectedLabel];
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
