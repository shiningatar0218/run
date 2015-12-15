//
//  ViewModel.h
//  run
//
//  Created by runner on 15/3/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReturnValueBlock)(id returnValue);
typedef void(^FailureBlock)(id failureBlock);


@interface ViewModel : NSObject

@property (nonatomic, copy) ReturnValueBlock returnBlock;
@property (nonatomic, copy) FailureBlock failureBlock;

- (void)setBlockWithReturnBlock:(ReturnValueBlock) returnBlock
               WithFailureBlock:(FailureBlock) failureBlock;


@end
