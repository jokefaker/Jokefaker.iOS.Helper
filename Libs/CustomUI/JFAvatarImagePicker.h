#import <Foundation/Foundation.h>
#import "UIImagePickerController+Block.h"

#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

@interface JFAvatarImagePicker : NSObject


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Static Methods
+ (void)showInViewController:(UIViewController *)viewController finishBlock:(ImagePickerFinishBlock)finishBolck;

#pragma mark - Instance Methods

- (void)showInViewController:(UIViewController *)viewController finishBlock:(ImagePickerFinishBlock)finishBolck;

@end