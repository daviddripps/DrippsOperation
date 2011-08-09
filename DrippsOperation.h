/**
 *  DrippsOperation.h
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

#import <Foundation/Foundation.h>

// ******
// * remember to call -(void)saveChanges; in your -(void)main; to save the context
// ******

@interface DrippsOperation : NSOperation
{
    NSManagedObjectContext *nsmoc;
    
    int retryCount;
}

- (void)saveChanges;

@end
