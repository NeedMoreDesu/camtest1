//
//  UIImageMetaDocument.m
//  camtest1
//
//  Created by dev on 12/8/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "UIImageMetaDocument.h"

@implementation UIImageMetaDocument

- (BOOL)loadFromContents:(NSData*)contents
                  ofType:(NSString *)typeName
                   error:(NSError *__autoreleasing *)outError
{
    return [self.metaImage loadFromContents:contents ofType:typeName error:outError];
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    return [self.metaImage contentsForType:typeName error:outError];
}

@end
