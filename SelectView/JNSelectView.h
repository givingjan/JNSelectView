//
//  JNSelectView.h
//  MOpen
//
//  Created by JaN on 2016/7/25.
//  Copyright © 2016年 softmobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JNSelectView : UIView


// Simple Single SelectView
+ (void)presentSingleSelectViewWithList:(NSArray*)ary title:(NSString*)strTitle completionHandler:(void(^)(NSInteger index))completionHandler;

// Simple Multiple SelectView
+ (void)presentMultipleSelectViewWithList:(NSArray*)ary title:(NSString*)strTitle completionHandler:(void(^)(NSArray *aryList))completionHandler;

// Multiple SelectView With MaxPick & MinimumPick
+ (void)presentMultipleSelectViewWithList:(NSArray*)ary
                                    title:(NSString*)strTitle
                                  maxPick:(NSInteger)maxPick
                              minimumPick:(NSInteger)minimumPick 
                        completionHandler:(void(^)(NSArray *aryList))completionHandler;


// Multiple SelectView With MaxPick & MinimumPick, Remember What's index has been picked.
+ (void)presentMultipleSelectViewWithList:(NSArray*)ary
                             selectedList:(NSArray*)arySelected
                                    title:(NSString*)strTitle
                                  maxPick:(NSInteger)maxPick
                              minimumPick:(NSInteger)minimumPick
                        completionHandler:(void(^)(NSArray *list))completionHandler;


@end

