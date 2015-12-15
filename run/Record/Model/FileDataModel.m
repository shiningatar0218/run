//
//  FileDataModel.m
//  run
//
//  Created by runner on 15/3/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "FileDataModel.h"
#import "Activity.h"
#import "DataModel.h"
#import "define.h"
#import "FileData.h"

@interface FileDataModel ()
{
    NSArray *_dataArray;
}

@end

@implementation FileDataModel

- (void)getFileDataModelWith:(Activity *)model {
    
    NSString *string = model.file_url;
    
    NSInteger count = 0;
    int user_id = [model.user_id intValue];
    while (user_id) {
        user_id /= 10;
        count ++;
    }
    NSString *fileName = @"";
    if (string.length > 0) {
        NSRange range = [string rangeOfString:@".txt"];
        fileName = [string substringWithRange:NSMakeRange(range.location - 12 - count-1, 12 + count + 1)];
    }
    
    [DATAMODEL readDataFromFile:fileName completion:^(BOOL didFinish, NSArray *array) {
        _dataArray = array;
    }];
}

- (void)getAltitudeData {
    
    if (!_dataArray) {
        self.failureBlock(_dataArray);
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *array_x = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *array_y = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *dic in _dataArray) {
        FileData *model = [FileData FileDataWithModel:dic];
        [array_x addObject:[NSString stringWithFormat:@"%f",model.dis]];
        [array_y addObject:[NSString stringWithFormat:@"%f",model.alt]];
    }
    
    [array addObject:array_x];
    [array addObject:array_y];
    
    self.returnBlock (array);
    
}

- (void)getPaceData {
    if (!_dataArray) {
        self.failureBlock(_dataArray);
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *array_x = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *array_y = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *dic in _dataArray) {
        FileData *model = [FileData FileDataWithModel:dic];
        [array_x addObject:[NSString stringWithFormat:@"%f",model.dis]];
                
        [array_y addObject:[NSString stringWithFormat:@"%f",model.pace]];
    }
    
    [array addObject:array_x];
    [array addObject:array_y];
    
    self.returnBlock (array);
    
}

@end
