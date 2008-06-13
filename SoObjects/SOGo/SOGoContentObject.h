/*
  Copyright (C) 2004 SKYRIX Software AG

  This file is part of OpenGroupware.org.

  OGo is free software; you can redistribute it and/or modify it under
  the terms of the GNU Lesser General Public License as published by the
  Free Software Foundation; either version 2, or (at your option) any
  later version.

  OGo is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
  License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with OGo; see the file COPYING.  If not, write to the
  Free Software Foundation, 59 Temple Place - Suite 330, Boston, MA
  02111-1307, USA.
*/

#ifndef __SOGo_SOGoContentObject_H__
#define __SOGo_SOGoContentObject_H__

#import <SOGo/SOGoObject.h>

@class NSArray;
@class NSCalendarDate;
@class NSException;
@class NSString;
@class SOGoGCSFolder;

@interface SOGoContentObject : SOGoObject
{
  BOOL isNew;
  NSString *content;
  unsigned int version;
  NSCalendarDate *creationDate;
  NSCalendarDate *lastModified;
}

+ (SOGoContentObject *) objectWithRecord: (NSDictionary *) objectRecord
			     inContainer: (SOGoGCSFolder *) newContainer;
- (id) initWithRecord: (NSDictionary *) objectRecord
	  inContainer: (id) newContainer;

/* content */

- (BOOL) isNew;
- (NSString *) contentAsString;
- (NSException *) saveContentString: (NSString *) _str
                        baseVersion: (unsigned int) _baseVersion;
- (NSException *) saveContentString: (NSString *)_str;
- (NSException *) delete;

/* etag support */

- (id) davEntityTag;
- (NSString *) davCreationDate;
- (NSString *) davLastModified;
- (NSString *) davContentLength;

/* message type */

- (NSString *) outlookMessageClass;

@end

@interface SOGoContentObject (OptionalMethods)

- (void) prepareDelete;

@end

#endif /* __SOGo_SOGoContentObject_H__ */
