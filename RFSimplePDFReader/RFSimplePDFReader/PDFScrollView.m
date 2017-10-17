//    File: PDFScrollView.m
//Abstract: UIScrollView subclass that handles the user input to zoom the PDF page.  This class handles swapping the TiledPDFViews when the zoom level changes.
// Version: 1.0
//Copyright (C) 2010 Apple Inc. All Rights Reserved.
//

#import "PDFScrollView.h"
#import "TiledPDFView.h"
#import <QuartzCore/QuartzCore.h>

#define BARBUTTON(TITLE, SELECTOR) 	[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStyleBordered target:self action:SELECTOR]
#define TOOLBAR_HEIGHT 44.0f
#define PAGING_AREA_WIDTH 48.0f



@implementation PDFScrollView


- (instancetype)initWithFrame:(CGRect)frame resource:(NSString *)resource
{
    if ((self = [super initWithFrame:frame])) {
		
		// Set up the UIScrollView
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		[self setBackgroundColor:[UIColor grayColor]];
		self.maximumZoomScale = 5.0;
		self.minimumZoomScale = .25;
		
		// Open the PDF document
		NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:resource withExtension:nil];
		pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
		
        _pageCount = CGPDFDocumentGetNumberOfPages(pdf);
        _pageNumber = 1;
        
		// Get the PDF Page that we will be drawing
		page = CGPDFDocumentGetPage(pdf, _pageNumber);
		CGPDFPageRetain(page);
		
		// determine the size of the PDF page
		CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
		pdfScale = self.frame.size.width/pageRect.size.width;
		pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);


		// Create the TiledPDFView based on the size of the PDF page and scale it to fit the view.
		pdfView = [[TiledPDFView alloc] initWithFrame:pageRect andScale:pdfScale];
		[pdfView setPage:page];
		[self addSubview:pdfView];
        
    }
    return self;
}




- (void)dealloc
{
	CGPDFPageRelease(page);
	CGPDFDocumentRelease(pdf);
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

// We use layoutSubviews to center the PDF page in the view
- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
	
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = pdfView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    pdfView.frame = frameToCenter;
    
	// to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
	// tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
	// which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
	pdfView.contentScaleFactor = 1.0;
}

#pragma mark -
#pragma mark UIScrollView delegate methods

// A UIScrollView delegate callback, called when the user starts zooming. 
// We return our current TiledPDFView.
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return pdfView;
}

// A UIScrollView delegate callback, called when the user begins zooming.  When the user begins zooming
// we remove the old TiledPDFView and set the current TiledPDFView to be the old view so we can create a
// a new TiledPDFView when the zooming ends.
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    NSLog(@"[%s]",__FUNCTION__);

	// Remove back tiled view.
	[oldPDFView removeFromSuperview];

	
	// Set the current TiledPDFView to be the old view.
	oldPDFView = pdfView;
	[self addSubview:oldPDFView];
}

// A UIScrollView delegate callback, called when the user stops zooming.  When the user stops zooming
// we create a new TiledPDFView based on the new zoom level and draw it on top of the old TiledPDFView.
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"[%s] scale[%f] [%f]",__FUNCTION__,pdfScale,scale);
    // set the new scale factor for the TiledPDFView
	pdfScale *=scale;
	
	// Calculate the new frame for the new TiledPDFView
	CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
	pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
	
	// Create a new TiledPDFView based on new frame and scaling.
	pdfView = [[TiledPDFView alloc] initWithFrame:pageRect andScale:pdfScale];
	[pdfView setPage:page];
	
	// Add the new TiledPDFView to the PDFScrollView.
	[self addSubview:pdfView];
}

-(void)clickPre
{
    _pageNumber--;
    if (_pageNumber <= 0)
    {
        _pageNumber = 1;
    }
    page = CGPDFDocumentGetPage(pdf, _pageNumber);
    
    [pdfView setPage:page];
    [pdfView setNeedsDisplay];
}

-(void)clickNext
{
    _pageNumber++;
    if (_pageNumber > _pageCount)
    {
        _pageNumber = _pageCount;
    }
    page = CGPDFDocumentGetPage(pdf, _pageNumber);
    
    [pdfView setPage:page];
    [pdfView setNeedsDisplay];
}


@end
