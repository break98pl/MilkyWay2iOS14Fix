#import <dlfcn.h>
#import <substrate.h>
#import <FrontBoard/FBSMutableSceneSettings.h>
#import <FrontBoard/FBScene.h>
#import <FrontBoard/FBSceneManager.h>
#import <mach-o/dyld.h>
#import <rootless.h>

#import "MilkyWay2.h"

static AXPassthroughWindow *keyboardWindow;

@interface FBScene ()
- (void)updateSettings:(id)arg1 withTransitionContext:(id)arg2 ;
@end

@interface FBSMutableSceneSettings ()
@property (assign,getter=isForeground,nonatomic) BOOL foreground;
@end

@interface SBAppLayout : NSObject
+(id)homeScreenAppLayout;
@end

@interface SBMainSwitcherViewController : UIViewController
+(id)sharedInstance;
-(BOOL)_dismissSwitcherNoninteractivelyToAppLayout:(SBAppLayout*)arg1 dismissFloatingSwitcher:(BOOL)arg2 animated:(BOOL)arg3 ;
@end

%group iOS14
%hook SBAppLayout
%new 
-(id)rolesToLayoutItemsMap{
    return MSHookIvar<id>(self,"_rolesToLayoutItemsMap");
}
%end //SBApplayout

%hook AXWindowView
-(void)updateLayers{
    %orig;
    for(UIView *hostView in [[self contentView] subviews]){
        if([hostView isKindOfClass:%c(_UIKeyboardLayerHostView)]){
            if(!keyboardWindow){
                keyboardWindow = [[%c(AXPassthroughWindow) alloc] initWithNoRotation];
                [keyboardWindow setBackgroundColor:[UIColor clearColor]];
                [keyboardWindow setWindowLevel:10000];
                [keyboardWindow makeKeyAndVisible];
            }
            for(UIView *subview in [keyboardWindow subviews]){
                [subview removeFromSuperview];
            }
            [keyboardWindow addSubview:hostView];
            [hostView setClipsToBounds:NO];
        }
    }
}
%end //AXWindowView

%hook SBAppSwitcherPageView
-(void)AXlongPressAction:(UIGestureRecognizer*)gestureRecognizer{
    %orig;
    [[%c(SBMainSwitcherViewController) sharedInstance] _dismissSwitcherNoninteractivelyToAppLayout:[%c(SBAppLayout) homeScreenAppLayout] dismissFloatingSwitcher:YES animated:YES];
}
%end //SBAppSwitcherPageView
%end //iOS14

%ctor{
    dlopen("/Library/MobileSubstrate/DynamicLibraries/MilkyWay2.dylib", RTLD_NOW);

    %init(iOS14);
}
