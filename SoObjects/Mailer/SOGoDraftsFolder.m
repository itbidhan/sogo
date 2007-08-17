/* SOGoDraftsFolder.m - this file is part of SOGo
 *
 * Copyright (C) 2007 Inverse groupe conseil
 *
 * Author: Wolfgang Sourdeau <wsourdeau@inverse.ca>
 *
 * This file is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#import <Foundation/NSDate.h>
#import <Foundation/NSString.h>
#import <Foundation/NSUserDefaults.h>

#import <NGObjWeb/WOContext+SoObjects.h>
#import <SoObjects/SOGo/SOGoUser.h>

#import "SOGoDraftObject.h"

#import "SOGoDraftsFolder.h"

static NSString *spoolFolder = nil;

static NSTimeInterval lastNew = 0;
static unsigned int newCount;

@implementation SOGoDraftsFolder

+ (void) initialize
{
  NSUserDefaults *ud;

  if (!spoolFolder)
    {
      ud = [NSUserDefaults standardUserDefaults];
      spoolFolder = [ud stringForKey:@"SOGoMailSpoolPath"];
      if (![spoolFolder length])
	spoolFolder = @"/tmp/";
      [spoolFolder retain];

      NSLog(@"Note: using SOGo mail spool folder: %@", spoolFolder);
    }
}

- (NSString *) generateNameForNewDraft
{
  NSString *newName, *login;
  unsigned int currentTime;

  currentTime = [[NSDate date] timeIntervalSince1970];
  if (currentTime == lastNew)
    newCount++;
  else
    {
      lastNew = currentTime;
      newCount = 1;
    }

  login = [[context activeUser] login];
  newName = [NSString stringWithFormat: @"newDraft%u-%u",
		      currentTime, newCount];

  return newName;
}

- (SOGoDraftObject *) newDraft
{
  return [SOGoDraftObject objectWithName: [self generateNameForNewDraft]
			  inContainer: self];
}

- (id) lookupName: (NSString *) name
	inContext: (WOContext *) localContext
	  acquire: (BOOL) acquire
{
  id object;

  if ([name hasPrefix: @"newDraft"])
    object = [SOGoDraftObject objectWithName: name inContainer: self];
  else
    object = [super lookupName: name
		    inContext: localContext
		    acquire: acquire];

  return object;
}

- (BOOL) isInDraftsFolder
{
  return YES;
}

- (NSString *) userSpoolFolderPath
{
  NSString *login;

  login = [[context activeUser] login];

  return [NSString stringWithFormat: @"%@/%@",
		   spoolFolder, login];
}

@end
