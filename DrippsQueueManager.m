/**
 *  DrippsQueueManager.m
 * 
 *  Created by David Dripps on 8/7/11.
 *  Copyright 2011 David Dripps. All rights reserved.
 * 
 *  This code is licensed under the GNU General Public License (see below)
 *  so you are free to use and modify it any way you wish.  However, all
 *  existing comments and copyright information must remain unmodified.
 * 
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 * 
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 * 
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 *  Feel free to get in touch: david [dot] dripps [at] gmail [dot] com
 * 
 */

#import "DrippsQueueManager.h"
#import "DrippsQueue.h"

#define DEFAULT_DOQUEUE_NAME @"defaultDrippsOperationQueueNameKey"

@interface DrippsQueueManager (PrivateStuff)

+ (DrippsQueueManager *)sharedManager;

@end

@implementation DrippsQueueManager

static DrippsQueueManager *sharedManager = nil;

- (void)addQueue:(DrippsQueue *)newQueue
{
    [DOQueues setObject:newQueue forKey:newQueue.DQName];
}

- (DrippsQueue *)getQueue:(NSString *)queueName
{
    if (! DOQueues)
    {
        DOQueues = [[NSMutableDictionary dictionary] retain];
    }
    
    DrippsQueue *_returnQueue = [DOQueues objectForKey:queueName];
    
    if (nil == _returnQueue)
    {
        _returnQueue = [[DrippsQueue alloc] initWithQueueName:queueName];
        
        [self addQueue:_returnQueue];
    }
    
    return _returnQueue;
}

- (void)dealloc
{
    [DOQueues release], DOQueues = nil;
    
    [super dealloc];
}

#pragma mark - Factory methods

+ (DrippsQueue *)defaultQueue  //if you only need 1 queue
{
    return [[DrippsQueueManager sharedManager] getQueue:DEFAULT_DOQUEUE_NAME];
}

+ (DrippsQueue *)queueWithName:(NSString *)queueName andMaxConcurrency:(NSUInteger)maxCcrncy
{
    DrippsQueue *_returnQueue = [[DrippsQueueManager sharedManager] getQueue:queueName];
    
    if (maxCcrncy > 0)
    {
        [_returnQueue setMaxConcurrentOperationCount:maxCcrncy];
    }
    
    [[DrippsQueueManager sharedManager] addQueue:_returnQueue];
    
    return _returnQueue;
}

+ (DrippsQueue *)queueWithName:(NSString *)queueName
{
    return [[DrippsQueueManager sharedManager] getQueue:queueName];
}

#pragma mark - Singleton stuff

+ (DrippsQueueManager *)sharedManager
{
    if (nil == sharedManager)
    {
        sharedManager = [[super allocWithZone:NULL] init];
    }
    
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
