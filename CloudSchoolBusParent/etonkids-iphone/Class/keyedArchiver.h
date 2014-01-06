
#import <Foundation/Foundation.h>

@interface keyedArchiver : NSObject

+(id) Instance;
+(void) delArchiver:(NSString *) archiverName;
+(id) getArchiver:(NSString *)archiverName forKey:(NSString *) akey;
+(BOOL) setArchiver:(NSString *) archiverName withData:(id) data forKey:(NSString *)akey;

@end
