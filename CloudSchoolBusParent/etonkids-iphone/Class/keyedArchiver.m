
#import "keyedArchiver.h"

static keyedArchiver * instance;

@implementation keyedArchiver

+(id) Instance
{
    if(instance == nil)
    {
        instance = [[keyedArchiver alloc] init];
    }
    return instance;
}
+(NSString *) getArchiverPath:(NSString *) archiverName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* docDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat",archiverName]];
    
    return docDir;
}
+(void) delArchiver:(NSString *) archiverName
{
    NSString * docDir = [self getArchiverPath:archiverName];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:docDir])
    {
        [defaultManager removeItemAtPath:docDir error:nil];
    }
}
+(BOOL) setArchiver:(NSString *) archiverName withData:(id) data forKey:(NSString *)akey
{
    NSString * docDir = [self getArchiverPath:archiverName];
    
    NSMutableData * dataFile = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataFile];
    [archiver encodeObject:data forKey:akey];
    [archiver finishEncoding];
    [archiver release];
    BOOL r = [dataFile writeToFile:docDir atomically:YES];
    [dataFile release];
    return r;
}
+(id) getArchiver:(NSString *)archiverName forKey:(NSString *) akey
{
    NSString * docDir = [self getArchiverPath:archiverName];
    
    NSData *content= [NSData dataWithContentsOfFile:docDir];
    if(content == nil)
        return nil;
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:content] retain];
    id obj = [unarchiver decodeObjectForKey:akey];
    [unarchiver release];
    
    return obj;
}

@end
