SlidingCardUIView
=================

<b>What it does:<b/>

UI for iOS similar to Jelly app http://jelly.co/

![Screenshot](https://github.com/stenio123/SlidingCardsUIView/raw/master/SlidingCardsUIView/screen.gif)

SlidingCardUIView allows you to create an array of several views (like information cards), and give to SlidingCardUIView. This class will add a gesture recognizer that allows users to drag the view down to make it disappear, and having the next view in the array pop up into the front. 

The current functionality is circular - once you pull down the last view of the array and it disappears, the first view will reappear.

<b>How to use it in 30 seconds:<b/>

1- Create a new project on XCode <br/>
2- import AVViewCOntrollerExample.h and .m, and import SlidingCardsUIView.h and .m. <br/>
3- Make sure that AVViewControllerExample is the root view controller (if using interface builder, make sure to set the class of your UIViewController on interface Builder to this class).<br/>
4- Run and start dragging to see the default values at work!<br/>


<b>How to use in your project:<b/>

In order to edit the views, just create your UIViews programmatically (as described on UIViewControllerExample), and call -(void)showViewsFromArray:(NSArray *)views forViewController:(UIViewController *)controller;

For any questions or comments let me know!

@stenio123
