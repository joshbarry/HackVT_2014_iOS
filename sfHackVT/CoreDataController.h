//
//  CoreDataController.h
//  sfHackVT
//
//  Created by Joshua Barry on 10/10/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataController : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

+(instancetype)sharedInstance;

- (id) insertToCData:(NSString *)str;

- (NSArray *) fetchCData:(NSString *)str;

- (void)saveContext;

- (void)deleteObj:(NSManagedObject *)object;

- (void)wipeDatas:(NSString *)str;

@end

