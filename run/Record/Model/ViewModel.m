//
//  ViewModel.m
//  run
//
//  Created by runner on 15/3/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ViewModel.h"


@implementation ViewModel

- (void)setBlockWithReturnBlock:(ReturnValueBlock) returnBlock
               WithFailureBlock:(FailureBlock) failureBlock {
    _returnBlock = returnBlock;
    _failureBlock = failureBlock;
}
@end
