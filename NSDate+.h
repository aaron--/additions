
@interface NSDate (Additions)

+ (NSDate *)dateFromISO8601String:(NSString *)iso8601String;
- (NSString *)ISO8601String;

+ (NSDate *)dateFromRFC1123String:(NSString*)rfc1123String;
- (NSString*)RFC1123String;

@end
