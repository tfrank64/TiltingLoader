
// Copyright (c) 2013 Tobias Conradi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface TOCMotionEffectsEngine : NSObject
@end


@implementation TOCMotionEffectsEngine
void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}


BOOL swizzeledMotionEffectsAreSupported() {
    return YES;
}

void swizzledBeginSuspendingForReasonImp (id self, SEL _cmd, NSString *reason) {
    if ([reason isEqualToString:@"mirroringMainScreen"]) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(@"swizzledBeginSuspendingForReason:") withObject:reason];
#pragma clang diagnostic pop
}


+ (void)load {
    Class motionEffectsEngine = NSClassFromString(@"_UIMotionEffectEngine");
    if (!motionEffectsEngine) {
        return;
    }
    SEL swizzledBeginSuspendingForReasonSel = NSSelectorFromString(@"swizzledBeginSuspendingForReason:");
    class_addMethod(motionEffectsEngine, swizzledBeginSuspendingForReasonSel, (IMP)swizzledBeginSuspendingForReasonImp, "v@:@");
    
    Swizzle(motionEffectsEngine, NSSelectorFromString(@"beginSuspendingForReason:"), swizzledBeginSuspendingForReasonSel);
    
    SEL swizzeledSupportedSel = NSSelectorFromString(@"_motionEffectsAreSupportedSwizzeled");
    
    Swizzle(motionEffectsEngine, NSSelectorFromString(@"_motionEffectsAreSupported"), swizzeledSupportedSel);

}

@end
