/**
 *  DrippsOperation.m
 * 
 *  Created by David Dripps on 7/24/11.
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

#import "DrippsOperation.h"

@interface DrippsOperation (PrivateStuff)

- (NSManagedObjectContext *)appDelegateContext;

- (void)mergeContextChanges:(NSNotification *)notification;

@end

@implementation DrippsOperation

- (id)init
{
    self = [super init];
    
    if (self)
    {
        //create a new NSManagedObjectContext
        nsmoc = [[NSManagedObjectContext alloc] init];
        
        //use the same Persistent Store Coordinator as the AppDelegate
        [nsmoc setPersistentStoreCoordinator:[[self appDelegateContext] persistentStoreCoordinator]];
        
        //don't worry about tracking undos (maybe in the next version)
        [nsmoc setUndoManager:nil];
        
        //register for change notifications to this context
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(mergeContextChanges:)
                   name:NSManagedObjectContextDidSaveNotification
                 object:nsmoc];
        
        //I use retries all the time so I left this here in case anyone else wants to use it too
        retryCount = 0;
    }
    
    return self;
}

- (void)saveChanges
{
    if([nsmoc hasChanges])
    {
        [nsmoc save:nil];
    }
}

- (void)dealloc
{
    nsmoc = nil;        //normally I'd release this object, but that seems to throw a SIGABRT
    
    [super dealloc];
}

#pragma mark - Private methods

- (NSManagedObjectContext *)appDelegateContext
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate managedObjectContext];
}

- (void)mergeContextChanges:(NSNotification *)notification
{
    [[self appDelegateContext] performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                                withObject:notification
                                             waitUntilDone:YES];
}

@end
