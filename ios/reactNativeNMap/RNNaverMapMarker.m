//
//  RNNaverMapMarker.m
//
//  Created by flask on 18/04/2019.
//  Copyright © 2019 flask. All rights reserved.
//

#import "RNNaverMapMarker.h"

#import <React/RCTBridge.h>
#import <React/RCTImageLoader.h>
#import <React/RCTUtils.h>
#import <NMapsMap/NMFNaverMapView.h>
#import <NMapsGeometry/NMGLatLng.h>
#import <NMapsMap/NMFMarker.h>
#import <NMapsMap/NMFOverlayImage.h>

#import "RCTConvert+NMFMapView.h"

@implementation RNNaverMapMarker {
  RCTImageLoaderCancellationBlock _reloadImageCancellationBlock;
  __weak UIImageView *_iconImageView;
  UIView *_iconView;
}

  static NSMutableDictionary *_overlayImageHolder;

  +(void)initialize {
    _overlayImageHolder = [[NSMutableDictionary alloc] init];
  }

- (instancetype)init
{
  if ((self = [super init])) {
    _realMarker = [NMFMarker new];

    __block RNNaverMapMarker *this = self;
    _realMarker.touchHandler = ^BOOL(NMFOverlay *overlay) {
      if (this.onClick != nil) {
        this.onClick(@{});
        return YES;
      }
      return NO;
    };
  }
  return self;
}

- (void)setZIndex:(NSInteger) zIndex {
    _realMarker.zIndex = zIndex;
}

- (void)setHidden:(BOOL) hidden {
    _realMarker.hidden = hidden;
}

- (void)setCoordinate:(NMGLatLng*) coordinate {
  _realMarker.position = coordinate;
}

- (void)setWidth:(CGFloat) width {
  _realMarker.width = width;
}

- (void)setHeight:(CGFloat) height {
  _realMarker.height = height;
}

- (void)setRotation:(CGFloat) rotation {
  _realMarker.angle = rotation;
}

- (void)setPinColor:(UIColor *) pinColor {
  _realMarker.iconTintColor = pinColor;
}

- (void)setAlpha:(CGFloat) alpha {
  _realMarker.alpha = alpha;
}

- (void)setAnchor:(CGPoint) anchor {
  _anchor = anchor;
  _realMarker.anchor = anchor;
}

- (void)setAngle:(CGFloat) angle {
    _realMarker.angle = angle;
}

- (void)setFlatEnabled:(BOOL) flatEnabled {
    _realMarker.flat = flatEnabled;
}

- (void)setIconPerspectiveEnabled:(BOOL) iconPerspectiveEnabled {
    _realMarker.iconPerspectiveEnabled = iconPerspectiveEnabled;
}

- (void)setisHideCollidedSymbols:(BOOL) isHideCollidedSymbols {
    _realMarker.isHideCollidedSymbols = isHideCollidedSymbols;
}

- (void)setIsHideCollidedMarkers:(BOOL) isHideCollidedMarkers {
    _realMarker.isHideCollidedMarkers = isHideCollidedMarkers;
}

- (void)setIsHideCollidedCaptions:(BOOL) isHideCollidedCaptions {
    _realMarker.isHideCollidedCaptions = isHideCollidedCaptions;
}

- (void)isForceShowIcon:(BOOL) isForceShowIcon {
    _realMarker.isForceShowIcon = isForceShowIcon;
}


- (void)setMapView:(NMFMapView*) mapView {
  _realMarker.mapView = mapView;
}

- (void)setCaptionText:(NSString *) text {
  _realMarker.captionText = text;
}

- (void)setCaptionTextSize:(CGFloat) size {
  _realMarker.captionTextSize = size;
}

- (void)setCaptionColor:(UIColor *) color {
  _realMarker.captionColor = color == nil ? UIColor.blackColor : color;
}

- (void)setCaptionHaloColor:(UIColor *) haloColor {
  _realMarker.captionHaloColor = haloColor == nil ? UIColor.whiteColor : haloColor;
}

- (void)setCaptionAligns:(NSArray<NMFAlignType *> *) aligns {
  _realMarker.captionAligns = aligns;
}

- (void)setCaptionOffset:(CGFloat) offset {
    _realMarker.captionOffset = offset;
}
- (void)setCaptionRequestedWidth:(CGFloat) captionWidth {
   _realMarker.captionRequestedWidth = captionWidth;
}

- (void)setCaptionMinZoom:(double) minZoom {
   _realMarker.captionMinZoom = minZoom;
}

- (void)setCaptionMaxZoom:(double) maxZoom {
   _realMarker.captionMaxZoom = maxZoom;
}

- (void)setSubCaptionText:(NSString *) subText {
    _realMarker.subCaptionText = subText;
}

- (void)setSubCaptionTextSize:(CGFloat) subTextSize {
    _realMarker.subCaptionTextSize = subTextSize;
}

- (void)setSubCaptionColor:(UIColor *) subColor {
    _realMarker.subCaptionColor = subColor == nil ? UIColor.blackColor : subColor;
}

- (void)setSubCaptionHaloColor:(UIColor *) subHaloColor {
    _realMarker.subCaptionHaloColor = subHaloColor == nil ? UIColor.whiteColor : subHaloColor;
}

- (void)setSubCaptionRequestedWidth:(CGFloat) subCaptionWidth {
    _realMarker.subCaptionRequestedWidth = subCaptionWidth;
}

- (void)setSubCaptionMinZoom:(double) subMinZoom {
   _realMarker.subCaptionMinZoom = subMinZoom;
}

- (void)setSubCaptionMaxZoom:(double) subMaxZoom {
   _realMarker.subCaptionMaxZoom = subMaxZoom;
}

- (void)setEdge:(NSInteger)edge{
   _edge = edge;
}

- (void)setImage:(NSString *) image
{
  _image = image;

  if (_reloadImageCancellationBlock) {
    _reloadImageCancellationBlock();
    _reloadImageCancellationBlock = nil;
  }

  if (!_image) {
    if (_iconImageView) [_iconImageView removeFromSuperview];
    return;
  }

if(_edge == 0){
    NMFOverlayImage *overlayImage = [_overlayImageHolder valueForKey:image];
    if (overlayImage != nil) {
        if (self->_iconImageView) [self->_iconImageView removeFromSuperview];
        self->_realMarker.iconImage = overlayImage;
        return;
    }
}

  _reloadImageCancellationBlock = [[_bridge moduleForClass:[RCTImageLoader class]] loadImageWithURLRequest:[RCTConvert NSURLRequest:_image]
                                                                          size:self.bounds.size
                                                                         scale:RCTScreenScale()
                                                                       clipped:YES
                                                                    resizeMode:RCTResizeModeCenter
                                                                 progressBlock:nil
                                                              partialLoadBlock:nil
                                                               completionBlock:^(NSError *error, UIImage *image) {
                                                                 if (error) {
                                                                   NSLog(@"%@", error);
                                                                   return;
                                                                 }
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                   if (self->_iconImageView) [self->_iconImageView removeFromSuperview];
                                                                     
                                                                     if(self->_edge == 0){
                                                                         if (self->_iconImageView) [self->_iconImageView removeFromSuperview];
                                                                                                                                            NMFOverlayImage *overlayImage = [NMFOverlayImage overlayImageWithImage: image];
                                                                                                                                            self->_realMarker.iconImage = overlayImage;

                                                                                                                                            [_overlayImageHolder setObject:overlayImage forKey:self->_image];
                                                                     }else{
                                                                         
                                                                         UIImage *resizedImage =  [self strechImageSides:image newWidth:self->_realMarker.width wideEdge:self->_edge];
                                                                         
                                                                         NMFOverlayImage *overlayImage = [NMFOverlayImage overlayImageWithImage: resizedImage];
                                                                         self->_realMarker.iconImage = overlayImage;
                                                                         
                                                                         [_overlayImageHolder setObject:overlayImage forKey:self->_image];
                                                                     }
                                                                 });
                                                               }];
}
- (UIImage *)strechImageSides:(UIImage *)image newWidth:(CGFloat)_newWidth wideEdge:(NSInteger) inset{
    NSInteger newWidth = _newWidth / image.scale;
    if(image.size.width >= newWidth){
        return image;
    }
    NSLog(@" %f  %f", image.size.width, _newWidth);
    CGFloat originalWidth = image.size.width;
    CGFloat tiledAreaWidth = ceil((newWidth - originalWidth)/2.0);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(originalWidth + tiledAreaWidth, image.size.height), NO, 0);
    UIImage *firstResizable = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, inset, 0, originalWidth - (inset + 1)) resizingMode:UIImageResizingModeTile];
    [firstResizable drawInRect:CGRectMake(0, 0, originalWidth + tiledAreaWidth, image.size.height)];
    UIImage *leftPart = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, image.size.height), NO, 0);
    UIImage *secondResizable = [leftPart resizableImageWithCapInsets:UIEdgeInsetsMake(0, (originalWidth - inset - 1 ) + tiledAreaWidth, 0, inset) resizingMode:UIImageResizingModeTile];
    [secondResizable drawInRect:CGRectMake(0, 0, newWidth, image.size.height)];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return fullImage;

}
@end
