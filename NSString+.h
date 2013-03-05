
@interface NSString (Additions)

+ (NSString*)utf8StringWithData:(NSData*)data;
+ (NSString*)stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding;

- (NSData*)md5digest;
- (NSString*)md5hexdigest;
- (NSDictionary*)md5AttributeDictionary;
- (NSDictionary*)urlQueryDictionary;
- (NSData*)base64data;
- (NSString*)stringByRemovingCharactersInSet:(NSCharacterSet*)set;

@end
