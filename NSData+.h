
@interface NSData (Additions)

- (NSString*)base64;
- (NSString*)hex;

- (NSData*)md5digest;
- (NSString*)md5hexdigest;

- (NSData*)sha1Digest;
- (NSData*)sha1HMacWithKey:(NSString*)key;

@end