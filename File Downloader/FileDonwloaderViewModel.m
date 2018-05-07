//
//  FileDonwloaderViewModel.m
//  File Downloader
//
//  Created by Gabriel I Leyva Merino on 5/6/18.
//  Copyright © 2018 Gabriel Leyva Merino. All rights reserved.
//

#import "FileDonwloaderViewModel.h"
#import "JGDownloadAcceleration.h"

@implementation FileDonwloaderViewModel
JGOperationQueue *q; //operations Queu

#pragma Lazy Instantiation
-(double)progress {
    if(!_progress){
        _progress = 0.0;
    }
    return _progress;
}

-(bool)completed{
    if(!_completed){
        _completed = NO;
    }
    return _completed;
}


-(void) downloadFileWith:(NSURL *)url withChunks: (int)chuncks withPath: (NSString *)filePath withFileSize: (long long) size{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"URL %@", url);
    
        BOOL resume = YES; //Remembers where the download left off if there is any network interruption
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; //create url request
    
        [request setTimeoutInterval:90.0];
    
        //start downloading the file
        JGDownloadOperation *operation = [[JGDownloadOperation alloc] initWithRequest:request destinationPath:filePath allowResume:resume customSize: size];
    
        [operation setMaximumNumberOfConnections:chuncks]; //number of chuncks the file will be downlaoded in
        [operation setRetryCount:3];
    
        //Block that is called when the download finishes
        [operation setCompletionBlockWithSuccess:^(JGDownloadOperation *operation) {
            self->_completed = YES;
        } failure:^(JGDownloadOperation *operation, NSError *error) {
            NSLog(@"Operation Failed: %@", error.localizedDescription);
        }];
    
        //Block that is called while the file is downloaded
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, unsigned long long totalBytesReadThisSession, unsigned long long totalBytesWritten, unsigned long long totalBytesExpectedToRead, NSUInteger tag) {
            self->_progress = ((double)totalBytesWritten/(double)totalBytesExpectedToRead)*100.0f;
        }];
    
        [operation setOperationStartedBlock:^(NSUInteger tag, unsigned long long totalBytesExpectedToRead) {
            NSLog(@"Operation Started, JGDownloadAcceleration version %@", kJGDownloadAccelerationVersion);
        }];
    
        if (!q) {
            q = [[JGOperationQueue alloc] init];
            q.handleNetworkActivityIndicator = NO;
            q.handleBackgroundTask = YES;
        }
    
        [q addOperation:operation];
    });
}
@end
