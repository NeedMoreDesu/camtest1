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
      
      [[Filter alloc] initWithName:@"BoxBlurFilter"
                       description:@"A hardware-optimized, variable-radius box blur"
                             class:[GPUImageBoxBlurFilter class]],
      
      [[Filter alloc] initWithName:@"GaussianSelectiveBlurFilter"
                       description:@"A Gaussian blur that preserves focus within a circular region"
                             class:[GPUImageGaussianSelectiveBlurFilter class]],
      
      [[Filter alloc] initWithName:@"GaussianBlurPositionFilter"
                       description:@"The inverse of the GPUImageGaussianSelectiveBlurFilter, applying the blur only within a certain circle"
                             class:[GPUImageGaussianBlurPositionFilter class]],
      
      [[Filter alloc] initWithName:@"MedianFilter"
                       description:@"Takes the median value of the three color components, over a 3x3 area"
                             class:[GPUImageMedianFilter class]],
      
      [[Filter alloc] initWithName:@"BilateralFilter"
                       description:@"A bilateral blur, which tries to blur similar color values while preserving sharp edges"
                             class:[GPUImageBilateralFilter class]],
      
      [[Filter alloc] initWithName:@"TiltShiftFilter"
                       description:@"A simulated tilt shift lens effect"
                             class:[GPUImageTiltShiftFilter class]],
      
      [[Filter alloc] initWithName:@"3x3ConvolutionFilter"
                       description:@"Runs a 3x3 convolution kernel against the image"
                             class:[GPUImage3x3ConvolutionFilter class]],
      
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
      
      [[Filter alloc] initWithName:@"HarrisCornerDetectionFilter"
                       description:@"Runs the Harris corner detection algorithm on an input image, and produces an image with those corner points as white pixels and everything else black. The cornersDetectedBlock can be set, and you will be provided with a list of corners (in normalized 0..1 X, Y coordinates) within that callback for whatever additional operations you want to perform."
                             class:[GPUImageHarrisCornerDetectionFilter class]],
      
      [[Filter alloc] initWithName:@"NobleCornerDetectionFilter"
                       description:@"Runs the Noble variant on the Harris corner detector. It behaves as described above for the Harris detector."
                             class:[GPUImageNobleCornerDetectionFilter class]],
      
      [[Filter alloc] initWithName:@"NonMaximumSuppressionFilter"
                       description:@"Currently used only as part of the Harris corner detection filter, this will sample a 1-pixel box around each pixel and determine if the center pixel's red channel is the maximum in that area. If it is, it stays. If not, it is set to 0 for all color components."
                             class:[GPUImageNonMaximumSuppressionFilter class]],
      
      [[Filter alloc] initWithName:@"YDerivativeFilter"
                       description:@"An internal component within the Harris corner detection filter, this calculates the squared difference between the pixels to the left and right of this one, the squared difference of the pixels above and below this one, and the product of those two differences."
                             class:[GPUImageXYDerivativeFilter class]],
      
      [[Filter alloc] initWithName:@"CrosshairGenerator"
                       description:@"This draws a series of crosshairs on an image, most often used for identifying machine vision features. It does not take in a standard image like other filters, but a series of points in its -renderCrosshairsFromArray:count: method, which does the actual drawing. You will need to force this filter to render at the particular output size you need."
                             class:[GPUImageCrosshairGenerator class]],
      
      [[Filter alloc] initWithName:@"DilationFilter"
                       description:@"This performs an image dilation operation, where the maximum intensity of the red channel in a rectangular neighborhood is used for the intensity of this pixel. The radius of the rectangular area to sample over is specified on initialization, with a range of 1-4 pixels. This is intended for use with grayscale images, and it expands bright regions."
                             class:[GPUImageDilationFilter class]],
      
      [[Filter alloc] initWithName:@"RGBDilationFilter"
                       description:@"This is the same as the GPUImageDilationFilter, except that this acts on all color channels, not just the red channel."
                             class:[GPUImageRGBDilationFilter class]],
      
      [[Filter alloc] initWithName:@"ErosionFilter"
                       description:@"This performs an image erosion operation, where the minimum intensity of the red channel in a rectangular neighborhood is used for the intensity of this pixel. The radius of the rectangular area to sample over is specified on initialization, with a range of 1-4 pixels. This is intended for use with grayscale images, and it expands dark regions."
                             class:[GPUImageErosionFilter class]],
      
      [[Filter alloc] initWithName:@"RGBErosionFilter"
                       description:@"This is the same as the GPUImageErosionFilter, except that this acts on all color channels, not just the red channel."
                             class:[GPUImageRGBErosionFilter class]],
      
      [[Filter alloc] initWithName:@"OpeningFilter"
                       description:@"This performs an erosion on the red channel of an image, followed by a dilation of the same radius. The radius is set on initialization, with a range of 1-4 pixels. This filters out smaller bright regions."
                             class:[GPUImageOpeningFilter class]],
      
      [[Filter alloc] initWithName:@"RGBOpeningFilter"
                       description:@"This is the same as the GPUImageOpeningFilter, except that this acts on all color channels, not just the red channel."
                             class:[GPUImageRGBOpeningFilter class]],
      
      [[Filter alloc] initWithName:@"ClosingFilter"
                       description:@"This performs a dilation on the red channel of an image, followed by an erosion of the same radius. The radius is set on initialization, with a range of 1-4 pixels. This filters out smaller dark regions."
                             class:[GPUImageClosingFilter class]],
      
      [[Filter alloc] initWithName:@"RGBClosingFilter"
                       description:@"This is the same as the GPUImageClosingFilter, except that this acts on all color channels, not just the red channel."
                             class:[GPUImageRGBClosingFilter class]],
      
      [[Filter alloc] initWithName:@"LocalBinaryPatternFilter"
                       description:@"This performs a comparison of intensity of the red channel of the 8 surrounding pixels and that of the central one, encoding the comparison results in a bit string that becomes this pixel intensity. The least-significant bit is the top-right comparison, going counterclockwise to end at the right comparison as the most significant bit."
                             class:[GPUImageLocalBinaryPatternFilter class]],
      
      [[Filter alloc] initWithName:@"HighPassFilter"
                       description:@"This applies a high pass filter to incoming video frames. This is the inverse of the low pass filter, showing the difference between the current frame and the weighted rolling average of previous ones. This is most useful for motion detection."
                             class:[GPUImageHighPassFilter class]],
      
      [[Filter alloc] initWithName:@"MotionDetector"
                       description:@"This is a motion detector based on a high-pass filter. You set the motionDetectionBlock and on every incoming frame it will give you the centroid of any detected movement in the scene (in normalized X,Y coordinates) as well as an intensity of motion for the scene."
                             class:[GPUImageMotionDetector class]],
      
      [[Filter alloc] initWithName:@"HoughTransformLineDetector"
                       description:@"Detects lines in the image using a Hough transform into parallel coordinate space. This approach is based entirely on the PC lines process developed by the Graph@FIT research group at the Brno University of Technology and described in their publications: M. Dubská, J. Havel, and A. Herout. Real-Time Detection of Lines using Parallel Coordinates and OpenGL. Proceedings of SCCG 2011, Bratislava, SK, p. 7 (http://medusa.fit.vutbr.cz/public/data/papers/2011-SCCG-Dubska-Real-Time-Line-Detection-Using-PC-and-OpenGL.pdf) and M. Dubská, J. Havel, and A. Herout. PClines — Line detection using parallel coordinates. 2011 IEEE Conference on Computer Vision and Pattern Recognition (CVPR), p. 1489- 1494 (http://medusa.fit.vutbr.cz/public/data/papers/2011-CVPR-Dubska-PClines.pdf)."
                             class:[GPUImageHoughTransformLineDetector class]],
      
      [[Filter alloc] initWithName:@"LineGenerator"
                       description:@"A helper class that generates lines which can overlay the scene. The color of these lines can be adjusted using -setLineColorRed:green:blue:"
                             class:[GPUImageLineGenerator class]],
      
      [[Filter alloc] initWithName:@"MotionBlurFilter"
                       description:@"Applies a directional motion blur to an image"
                             class:[GPUImageMotionBlurFilter class]],
      
      [[Filter alloc] initWithName:@"ZoomBlurFilter"
                       description:@"Applies a directional motion blur to an image"
                             class:[GPUImageZoomBlurFilter class]]];
}

@end