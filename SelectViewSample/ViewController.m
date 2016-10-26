//
//  ViewController.m
//  SelectViewSample
//
//  Created by JaN on 2016/7/26.
//  Copyright © 2016年 Yu-Jan-Chen. All rights reserved.
//

#import "ViewController.h"
#import "JNSelectView.h"

#define kSingleTag 0
#define kMultipleTag 1

@interface ViewController ()
@property (strong, nonatomic) NSArray *m_arySelected;
@property (assign, nonatomic) NSInteger m_iSelectedIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.m_iSelectedIndex = -1;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateString:(NSString*)strResult {
    self.m_lbResult.text = strResult;
}


- (IBAction)handleTap:(UIButton *)sender {
    switch (sender.tag) {
        case kSingleTag: {
            // self.m_iSelectedIndex should be "-1" at first time. (in this case, we assign -1 to it at viewDidLoad)
            // and then assign new value when get callback.
            NSArray *aryDataList = @[@"Messi",@"Aguero",@"Ronaldo",@"Xavi",@"Suarez"];
            [JNSelectView presentSingleSelectViewWithList:aryDataList
                                            selectedIndex:self.m_iSelectedIndex
                                                    title:@"Please Select your favorite player."
                                        completionHandler:^(NSInteger index)
            {
        
                NSString *strResult = [NSString stringWithFormat:@"Favorite Player : %@",aryDataList[index]];
                self.m_iSelectedIndex = index;
                [self updateString:strResult];
                NSLog(@"Select Index: %ld",(long)index);

            }];
            break;
        }
        case kMultipleTag: {
            NSArray *aryDataList = @[@"Messi",@"Aguero",@"C.Ronaldo",@"Suarez",@"Silva",@"Balotelli",@"Pique",@"Ronney",@"Naymar",@"Nani",@"Young",@"Henry",@"Eto",@"Drogba"];
            /*
             aryDataList -> Datalist for show.
             self.m_arySelected -> Previous selected.(nil available).
             title -> The title.
             */

            [JNSelectView presentMultipleSelectViewWithList:aryDataList
                                               selectedList:self.m_arySelected
                                                      title:@"Choose Your Forward Starting Lineup"
                                                    maxPick:4
                                                minimumPick:1
                                          completionHandler:^(NSArray *aryList)
             {
             
                self.m_arySelected = aryList;
                NSMutableArray *aryResult = [[NSMutableArray alloc]init];
                NSInteger index;
                    
                for (int i = 0 ; i < aryList.count ; i++) {
                    index = [aryList[i] integerValue];
                    [aryResult addObject:aryDataList[index]];
                }
                
                NSString *strResult = [NSString stringWithFormat:@"Forward Starting Lineup :\n%@",[aryResult componentsJoinedByString:@","]];

                [self updateString:strResult];
            }];
            break;
        }

        default:
            break;
    }
}
@end
