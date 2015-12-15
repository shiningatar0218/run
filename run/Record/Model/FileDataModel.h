//
//  FileDataModel.h
//  run
//
//  Created by runner on 15/3/26.
//  Copyright (c) 2015年 runner. All rights reserved.
//

#import "ViewModel.h"
#import "Activity.h"

@interface FileDataModel : ViewModel

- (void)getFileDataModelWith:(Activity *)model;

- (void)getAltitudeData;
- (void)getPaceData;

@end
