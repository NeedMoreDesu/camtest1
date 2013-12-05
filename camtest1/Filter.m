//
//  Filter.m
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "Filter.h"
#import <GPUImage/GPUImage.h>

@implementation Filter

- (Filter*) initWithName:(NSString*)name
          description:(NSString*)description
                class:(Class)filterClass
{
    if ([super init])
    {
        self.name = name;
        self.description = description;
        self.filterClass = filterClass;
    }
    return self;
}

- (UIImage*) applyFilterToImage:(UIImage*)image
{
    return [[[[self filterClass] alloc] init] imageByFilteringImage:image];
}

+(NSArray*)filters
{
    return
    @[[[Filter alloc] initWithName:@"SepiaFilter"
                       description:@"Simple sepia tone filter"
                             class:[GPUImageSepiaFilter class]],
      
      [[Filter alloc] initWithName:@"LanczosResamplingFilter"
                       description:@"This lets you up- or downsample an image using Lanczos resampling, which results in noticeably better quality than the standard linear or trilinear interpolation. Simply use -forceProcessingAtSize: to set the target output resolution for the filter, and the image will be resampled for that new size."
                             class:[GPUImageLanczosResamplingFilter class]],
      
      [[Filter alloc] initWithName:@"SharpenFilter"
                       description:@"Sharpens the image"
                             class:[GPUImageSharpenFilter class]],
      
      [[Filter alloc] initWithName:@"UnsharpMaskFilter"
                       description:@"Applies an unsharp mask"
                             class:[GPUImageUnsharpMaskFilter class]],
      
      [[Filter alloc] initWithName:@"GaussianBlurFilter"
                       description:@"A hardware-optimized, variable-radius Gaussian blur"
                             class:[GPUImageGaussianBlurFilter class]],
      
      [[Filter alloc] initWithName:@"SobelEdgeDetectionFilter"
                       description:@"Sobel edge detection, with edges highlighted in white"
                             class:[GPUImageSobelEdgeDetectionFilter class]],
      
      [[Filter alloc] initWithName:@"rewittEdgeDetectionFilter"
                       description:@"Prewitt edge detection, with edges highlighted in white"
                             class:[GPUImagePrewittEdgeDetectionFilter class]],
      
      [[Filter alloc] initWithName:@"ThresholdEdgeDetectionFilter"
                       description:@"Performs Sobel edge detection, but applies a threshold instead of giving gradual strength values"
                             class:[GPUImageThresholdEdgeDetectionFilter class]],
      
      [[Filter alloc] initWithName:@"CannyEdgeDetectionFilter"
                       description:@"This uses the full Canny process to highlight one-pixel-wide edges"
                             class:[GPUImageCannyEdgeDetectionFilter class]],
      
      [[Filter alloc] initWithName:@"NonMaximumSuppressionFilter"
                       description:@"Currently used only as part of the Harris corner detection filter, this will sample a 1-pixel box around each pixel and determine if the center pixel's red channel is the maximum in that area. If it is, it stays. If not, it is set to 0 for all color components."
                             class:[GPUImageNonMaximumSuppressionFilter class]],
      
      [[Filter alloc] initWithName:@"YDerivativeFilter"
                       description:@"An internal component within the Harris corner detection filter, this calculates the squared difference between the pixels to the left and right of this one, the squared difference of the pixels above and below this one, and the product of those two differences."
                             class:[GPUImageXYDerivativeFilter class]],
      
      [[Filter alloc] initWithName:@"DilationFilter"
                       description:@"This performs an image dilation operation, where the maximum intensity of the red channel in a rectangular neighborhood is used for the intensity of this pixel. The radius of the rectangular area to sample over is specified on initialization, with a range of 1-4 pixels. This is intended for use with grayscale images, and it expands bright regions."
                             class:[GPUImageDilationFilter class]],
      
      [[Filter alloc] initWithName:@"RGBDilationFilter"
                       description:@"This is the same as the GPUImageDilationFilter, except that this acts on all color channels, not just the red channel."
                             class:[GPUImageRGBDilationFilter class]],
      
      [[Filter alloc] initWithName:@"ErosionFilter"
                       description:@"This performs an image erosion operation, where the minimum intensity of the red channel in a rectangular neighborhood is used for the intensity of this pixel. The radius of the rectangular area to sample over is specified on initialization, with a range of 1-4 pixels. This is intended for use with grayscale images, and it expands dark regions."
                             class:[GPUImageErosionFilter class]],
      
      [[Filter alloc] initWithName:@"OpeningFilter"
                       description:@"This performs an erosion on the red channel of an image, followed by a dilation of the same radius. The radius is set on initialization, with a range of 1-4 pixels. This filters out smaller bright regions."
                             class:[GPUImageOpeningFilter class]],
      
      [[Filter alloc] initWithName:@"ClosingFilter"
                       description:@"This performs a dilation on the red channel of an image, followed by an erosion of the same radius. The radius is set on initialization, with a range of 1-4 pixels. This filters out smaller dark regions."
                             class:[GPUImageClosingFilter class]],
      
      [[Filter alloc] initWithName:@"LocalBinaryPatternFilter"
                       description:@"This performs a comparison of intensity of the red channel of the 8 surrounding pixels and that of the central one, encoding the comparison results in a bit string that becomes this pixel intensity. The least-significant bit is the top-right comparison, going counterclockwise to end at the right comparison as the most significant bit."
                             class:[GPUImageLocalBinaryPatternFilter class]],
      
      [[Filter alloc] initWithName:@"MotionBlurFilter"
                       description:@"Applies a directional motion blur to an image"
                             class:[GPUImageMotionBlurFilter class]],
      
      [[Filter alloc] initWithName:@"ZoomBlurFilter"
                       description:@"Applies a directional motion blur to an image"
                             class:[GPUImageZoomBlurFilter class]]];
}

@end
