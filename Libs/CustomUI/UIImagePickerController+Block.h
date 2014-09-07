#import <UIKit/UIKit.h>


#pragma mark Class Interface

typedef enum : NSUInteger {
    kWFImagePikcerFinishedTypeChoosen = 10011,
    kWFImagePikcerFinishedTypeTakePhoto,
    kWFImagePikcerFinishedTypeCanceled,
} WFImagePikcerFinishedType;

typedef void(^ImagePickerFinishBlock)(WFImagePikcerFinishedType finishType,UIImage *image);


@interface UIImagePickerController (Block)<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

#pragma mark - Properties

@property (nonatomic, copy) ImagePickerFinishBlock finishBlock;

#pragma mark - Static Methods

+ (UIImagePickerController *)imagePickerWithFinishBlock:(ImagePickerFinishBlock)finishBlock;

#pragma mark - Instance Methods


@end