//
//  JNSelectView.m
//  MOpen
//
//  Created by JaN on 2016/7/25.
//  Copyright © 2016年 softmobile. All rights reserved.
//


#import "JNSelectView.h"
#import "SelectViewCell.h"
#define kSelectViewHeight 400.0f

#define kMaxHeight [UIScreen mainScreen].bounds.size.height - 120.0f
#define kHeaderHeight 36.0f
#define kMarginHorizontal 20.0f
#define kButtonHeight 40.0f
#define kButtonTitleColor [UIColor colorWithRed:17/255.0f green:79/255.0f blue:155/255.0f alpha:1.0f]
#define kHeaderBackgroundColor [UIColor blackColor]
#define kHeaderTitleColor [UIColor whiteColor]
#define kButtonBackgroundColor [UIColor clearColor]
#define kBtnCancelTag 0
#define kBtnConfirmTag 1
#define kButtonTitleCancel @"Cancel"
#define kButtonTitleConfirm @"OK"

#define kDefaultMaxPick 1000
#define kDefaultMinimumPick 0

@interface JNSelectView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIView *m_vSelectView;
@property (strong, nonatomic) NSString *m_strTitle;
@property (strong, nonatomic) UITableView *m_tvContent;
@property (strong, nonatomic) NSArray *m_aryDataList;
@property (assign, nonatomic) BOOL m_bIsMultiple;
@property (assign, nonatomic) NSInteger m_iCurrentSelected;
@property (assign, nonatomic) NSInteger m_iMaxPick;
@property (assign, nonatomic) NSInteger m_iMinimumPick;
@property (strong, nonatomic) UIButton *m_btConfirm;

@property (copy,   nonatomic) void (^multipleCompletionHandler)(NSArray *aryList);
@property (copy,   nonatomic) void (^singleCompletionHandler)(NSInteger index);

@end
@implementation JNSelectView


#pragma mark - Public Method
+ (void)presentMultipleSelectViewWithList:(NSArray*)ary
                                    title:(NSString*)strTitle
                        completionHandler:(void(^)(NSArray *list))completionHandler {
    
    UIViewController *topVc = [JNSelectView topMostController];
    NSArray *aryDataList = [JNSelectView getDataList:ary selectedList:nil];
    JNSelectView *view = [JNSelectView getSelectViewWithList:aryDataList title:strTitle multiple:YES heigh:kSelectViewHeight];
    view.m_iMaxPick = kDefaultMaxPick;
    view.m_iMinimumPick = kDefaultMinimumPick;
    view.multipleCompletionHandler = completionHandler;
    [view updateButtonState];
    [topVc.view addSubview:view];
    
    [JNSelectView showView:topVc.view selectView:view];
}

+ (void)presentMultipleSelectViewWithList:(NSArray*)ary
                             selectedList:(NSArray*)arySelected
                                    title:(NSString*)strTitle
                                  maxPick:(NSInteger)maxPick
                              minimumPick:(NSInteger)minimumPick
                        completionHandler:(void(^)(NSArray *list))completionHandler {
    
    UIViewController *topVc = [JNSelectView topMostController];
    NSArray *aryDataList = [JNSelectView getDataList:ary selectedList:arySelected];
    JNSelectView *view = [JNSelectView getSelectViewWithList:aryDataList title:strTitle multiple:YES heigh:kSelectViewHeight];
    view.m_iMaxPick = maxPick;
    view.m_iMinimumPick = minimumPick;
    view.multipleCompletionHandler = completionHandler;
    [view updateButtonState];
    [topVc.view addSubview:view];
    
    [JNSelectView showView:topVc.view selectView:view];
}


+ (void)presentMultipleSelectViewWithList:(NSArray*)ary
                                    title:(NSString*)strTitle
                                  maxPick:(NSInteger)maxPick
                              minimumPick:(NSInteger)minimumPick
                        completionHandler:(void(^)(NSArray *list))completionHandler {
    
    UIViewController *topVc = [JNSelectView topMostController];
    NSArray *aryDataList = [JNSelectView getDataList:ary selectedList:nil];
    JNSelectView *view = [JNSelectView getSelectViewWithList:aryDataList title:strTitle multiple:YES heigh:kSelectViewHeight];
    view.m_iMaxPick = maxPick;
    view.m_iMinimumPick = minimumPick;
    [view updateButtonState];
    view.multipleCompletionHandler = completionHandler;
    [topVc.view addSubview:view];
    
    [JNSelectView showView:topVc.view selectView:view];
}


+ (void)presentSingleSelectViewWithList:(NSArray*)ary title:(NSString*)strTitle completionHandler:(void(^)(NSInteger index))completionHandler {
    UIViewController *topVc = [JNSelectView topMostController];
    NSArray *aryDataList = [JNSelectView getDataList:ary selectedList:nil];
    JNSelectView *view = [JNSelectView getSelectViewWithList:aryDataList title:strTitle multiple:NO heigh:kSelectViewHeight];
    view.singleCompletionHandler = completionHandler;
    [topVc.view addSubview:view];
    [JNSelectView showView:topVc.view selectView:view];
}



+ (void)presentSingleSelectViewWithList:(NSArray*)ary
                          selectedIndex:(NSInteger)selectedIndex
                                  title:(NSString*)strTitle
                      completionHandler:(void(^)(NSInteger index))completionHandler {
    UIViewController *topVc = [JNSelectView topMostController];
    NSArray *arySelected = selectedIndex == -1? nil : @[[NSNumber numberWithInt:selectedIndex]];
    NSArray *aryDataList = [JNSelectView getDataList:ary selectedList:arySelected];
    JNSelectView *view = [JNSelectView getSelectViewWithList:aryDataList title:strTitle multiple:NO heigh:kSelectViewHeight];
    if (selectedIndex != -1) {
        view.m_iCurrentSelected = selectedIndex;
    }
    view.singleCompletionHandler = completionHandler;
    [topVc.view addSubview:view];
    [JNSelectView showView:topVc.view selectView:view];
}


#pragma mark - Private Method
+ (NSArray *)getDataList:(NSArray*)aryList selectedList:(NSArray *)arySelected {
    NSMutableArray *aryResult = [[NSMutableArray alloc]init];

    NSMutableDictionary *dic;
    for (int i = 0 ; i < aryList.count ; i++) {
        dic = [@{@"Title":aryList[i],@"Selected":[NSNumber numberWithBool:NO]}mutableCopy];
        [aryResult addObject:dic];
    }
    
    if (arySelected != nil) {
        NSInteger index;
        for (NSNumber *number in arySelected) {
            index = [number integerValue];
            [aryResult[index] setObject:[NSNumber numberWithBool:YES] forKey:@"Selected"];
        }
    }
    
    return aryResult;
}

+ (UIViewController*)topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

+ (JNSelectView *)getSelectViewWithList:(NSArray *)aryList title:(NSString*)strTitle multiple:(BOOL)bIsMultiple heigh:(CGFloat)height {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if (height > kMaxHeight) {
        height = kMaxHeight;
    }
    
    JNSelectView *view = [[JNSelectView alloc]initWithFrame:CGRectMake(0, 0,screenSize.width, screenSize.height)];
    view.backgroundColor = [UIColor clearColor];
    view.m_strTitle = strTitle;
    view.m_aryDataList = aryList;
    view.m_bIsMultiple = bIsMultiple;
    view.m_vSelectView = [view getSelectViewWithHeight:height];
    
    [view addHeaderView];
    [view addTableView];
    [view addButtonView];
    [view addSubview:view.m_vSelectView];
    
    return view;
}

+ (void)showView:(UIView *)topView selectView:(UIView*)selectView {
    
    CGRect beginRect = selectView.frame;
    CGRect endRect = selectView.frame;
    
    beginRect.origin.y = topView.frame.size.height;
    selectView.frame = beginRect;
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        selectView.frame = endRect;
        selectView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
    
}

+ (void)dismissView:(UIView *)topView selectView:(UIView*)selectView {
    
    CGRect endRect = selectView.frame;
    
    endRect.origin.y = topView.frame.size.height;
    
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        selectView.frame = endRect;
        selectView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [selectView removeFromSuperview];
    }];

}

- (void)addHeaderView {
    UIView *vHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.m_vSelectView.frame.size.width, kHeaderHeight)];
    vHeader.backgroundColor = kHeaderBackgroundColor;
    
    UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, vHeader.frame.size.width, kHeaderHeight)];
    lbTitle.textColor = kHeaderTitleColor;
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.font = [UIFont systemFontOfSize:13.0f];
    lbTitle.text = self.m_strTitle;
    
    [vHeader addSubview:lbTitle];
    
    [self.m_vSelectView addSubview:vHeader];
}

- (void)addTableView {
    self.m_tvContent = [[UITableView alloc]initWithFrame:CGRectMake(0, kHeaderHeight, self.m_vSelectView.frame.size.width, self.m_vSelectView.frame.size.height - kButtonHeight - kHeaderHeight)];
    [self registerCell:self.m_bIsMultiple];
    self.m_tvContent.showsVerticalScrollIndicator = NO;
    self.m_tvContent.delegate = self;
    self.m_tvContent.dataSource = self;
    
    [self.m_vSelectView addSubview:self.m_tvContent];
}

- (void)addButtonView {
    UIView *selectView = self.m_vSelectView;
    NSArray *aryBtns = @[kButtonTitleCancel,kButtonTitleConfirm];
    UIView *vBtnView = [[UIView alloc]initWithFrame:CGRectMake(0,selectView.frame.size.height - kButtonHeight, selectView.frame.size.width, kButtonHeight)];
    
    UIButton *btn;
    
    for (int i = 0 ; i < aryBtns.count ; i ++) {
        btn = [[UIButton alloc]initWithFrame:CGRectMake(i * (vBtnView.frame.size.width / 2), 0, vBtnView.frame.size.width / 2, kButtonHeight)];
        btn.tag = i;
        [btn setTitle:aryBtns[i] forState:UIControlStateNormal];
        [btn setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
        [btn setBackgroundColor:kButtonBackgroundColor];
        [btn addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        
        if (btn.tag == kBtnConfirmTag) {
            self.m_btConfirm = btn;
        }
        
        [vBtnView addSubview:btn];
    }
    
    [self.m_vSelectView addSubview:vBtnView];
}

- (NSInteger)getPickCount {
    NSInteger count = 0;
    
    for (NSMutableDictionary *dic in self.m_aryDataList) {
        
        if ([[dic objectForKey:@"Selected"]boolValue] == YES) {
            count += 1;
        }
    }
    
    return count;
}

- (void)pickCell:(NSIndexPath *)indexPath {
    BOOL bIsSelected = [[self.m_aryDataList[indexPath.row] objectForKey:@"Selected"]boolValue];
    
    if ([self getPickCount] < self.m_iMaxPick) {
        [self.m_aryDataList[indexPath.row] setObject:[NSNumber numberWithBool:!bIsSelected] forKey:@"Selected"];
    } else {
        if (bIsSelected == YES) {
            [self.m_aryDataList[indexPath.row] setObject:[NSNumber numberWithBool:!bIsSelected] forKey:@"Selected"];
        }
    }
    
}

- (void)updateButtonState {

    if ([self getPickCount] >= self.m_iMinimumPick) {
        self.m_btConfirm.userInteractionEnabled = YES;
        [self.m_btConfirm setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
    } else {
        self.m_btConfirm.userInteractionEnabled = NO;
        [self.m_btConfirm setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (NSArray *)getSelectedIndexes {
    NSMutableArray *aryIndexes = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.m_aryDataList.count; i++) {
        if ([[self.m_aryDataList[i] objectForKey:@"Selected"] boolValue] == YES) {
            [aryIndexes addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    return aryIndexes;
}
- (void)handleTap:(UIButton*)btnSender {
    switch (btnSender.tag) {
        case kBtnCancelTag: {
            [self dismissThisView];
            break;
        }
        case kBtnConfirmTag: {
            // multiple selected
            if (self.m_bIsMultiple == YES) {
                if (self.multipleCompletionHandler) {
                    self.multipleCompletionHandler([self getSelectedIndexes]);
                }
            }
            // single selected
            else
            {
                if (self.singleCompletionHandler) {
                    NSInteger index = [[self getSelectedIndexes][0] integerValue];
                    self.singleCompletionHandler(index);
                }
            }
            
            [self dismissThisView];
            break;
        }
            
        default:
            break;
    }
    
    self.singleCompletionHandler = nil;
    self.multipleCompletionHandler = nil;
}

- (void)dismissThisView {
    UIViewController *topVc = [JNSelectView topMostController];
    
    if ([topVc isKindOfClass:[UIAlertController class]]) {
        return;
    }
    
    [JNSelectView dismissView:topVc.view selectView:self];
}

- (void)registerCell:(BOOL)bIsMultiple {
    UINib *nib = [UINib nibWithNibName:@"SelectViewCell" bundle:nil];
    [self.m_tvContent registerNib:nib forCellReuseIdentifier:@"cell"];
}

- (UIView *)getSelectViewWithHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    CGFloat x = kMarginHorizontal;
    CGFloat y = (screenSize.height - height)/2;
    
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(x,y , screenSize.width-x*2, height)];
    selectView.backgroundColor = [UIColor whiteColor];
    selectView.layer.cornerRadius = 5.0f;
    selectView.clipsToBounds = YES;
    
    return selectView;
}

#pragma mark - UITableView DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // multiple pick
    SelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.m_lbText.text = [self.m_aryDataList[indexPath.row] objectForKey:@"Title"];
    cell.m_ivCheck.hidden = ![[self.m_aryDataList[indexPath.row] objectForKey:@"Selected"]boolValue];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.m_aryDataList.count;
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // multiple pick
    NSArray *aryPaths;
    if (self.m_bIsMultiple == YES) {
        [self pickCell:indexPath];
        [self updateButtonState];
        
        aryPaths = @[indexPath];
    }
    // single pick
    else {
        // change selected state to 'NO' for last selected.
        
        NSIndexPath *beforeSelectedIndex = [NSIndexPath indexPathForRow:(int)self.m_iCurrentSelected inSection:0];
        [self.m_aryDataList[(int)self.m_iCurrentSelected] setObject:[NSNumber numberWithBool:NO] forKey:@"Selected"];
        [self.m_aryDataList[indexPath.row] setObject:[NSNumber numberWithBool:YES] forKey:@"Selected"];
        // point new obj
        self.m_iCurrentSelected = indexPath.row;
        
        aryPaths = @[indexPath,beforeSelectedIndex];
    }
    
    [tableView reloadRowsAtIndexPaths:aryPaths withRowAnimation:UITableViewRowAnimationFade];
    
}

@end





