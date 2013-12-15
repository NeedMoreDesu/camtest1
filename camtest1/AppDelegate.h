//
//  AppDelegate.h
//  camtest1
//
//  Created by dev on 11/26/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "State.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder
<UIApplicationDelegate,
CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property State *state;
@property CLLocationManager *locationManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
