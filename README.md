# Objc-Deallocating


#### Tested on iOS 16.0 ~ iOS 16.3.1

#### Fix crash for unoffical input method keyboad showing-up on double tapping TextField that with some few words

objc[15904]: Cannot form weak reference to instance (0x13b5d7000) of class _UIRemoteInputViewController. It is possible that this object was over-released, or is in the process of deallocation.


objc_msgSend$_wantsForwardingFromResponder:toNextResponder:withEvent:





	* thread #1, queue = 'com.apple.main-thread', stop reason = signal SIGABRT
	    frame #0: 0x00000001f3ff9bc4 libsystem_kernel.dylib`__abort_with_payload + 8
	    frame #1: 0x00000001f401bc14 libsystem_kernel.dylib`abort_with_payload_wrapper_internal + 104
	    frame #2: 0x00000001f401bbac libsystem_kernel.dylib`abort_with_reason + 32
	    frame #3: 0x00000001b0cf385c libobjc.A.dylib`_objc_fatalv(unsigned long long, unsigned long long, char const*, char*) + 116
	    frame #4: 0x00000001b0cf37e8 libobjc.A.dylib`_objc_fatal(char const*, ...) + 32
	    frame #5: 0x00000001b0cc6b50 libobjc.A.dylib`weak_register_no_lock + 392
	    frame #6: 0x00000001b0ccb808 libobjc.A.dylib`objc_storeWeak + 448
	    frame #7: 0x00000001b9bade3c UIKitCore`_UIResponderForwarderWantsForwardingFromResponder + 736
	    frame #8: 0x00000001b9ac3470 UIKitCore`__forwardTouchMethod_block_invoke + 44
	    frame #9: 0x00000001b790a7dc CoreFoundation`__NSSET_IS_CALLING_OUT_TO_A_BLOCK__ + 24
	    frame #10: 0x00000001b798b5a4 CoreFoundation`-[__NSSetM enumerateObjectsWithOptions:usingBlock:] + 200
	    frame #11: 0x00000001b9c90e4c UIKitCore`forwardTouchMethod + 236
	    frame #12: 0x00000001b9b8b0c4 UIKitCore`-[UIWindow _sendTouchesForEvent:] + 356
	    frame #13: 0x00000001b9b8a684 UIKitCore`-[UIWindow sendEvent:] + 3284
	    frame #14: 0x00000001b9b89944 UIKitCore`-[UIApplication sendEvent:] + 672
	    frame #15: 0x00000001b9b89000 UIKitCore`__dispatchPreprocessedEventFromEventQueue + 7088
	    frame #16: 0x00000001b9bd0d64 UIKitCore`__processEventQueue + 5632
	    frame #17: 0x00000001ba817a30 UIKitCore`updateCycleEntry + 168
	    frame #18: 0x00000001ba0df678 UIKitCore`_UIUpdateSequenceRun + 84
	    frame #19: 0x00000001ba71e904 UIKitCore`schedulerStepScheduledMainSection + 172
	    frame #20: 0x00000001ba71dad0 UIKitCore`runloopSourceCallback + 92
	    frame #21: 0x00000001b79d622c CoreFoundation`__CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 28
	    frame #22: 0x00000001b79e2614 CoreFoundation`__CFRunLoopDoSource0 + 176
	    frame #23: 0x00000001b796651c CoreFoundation`__CFRunLoopDoSources0 + 244
	    frame #24: 0x00000001b797beb8 CoreFoundation`__CFRunLoopRun + 836
	    frame #25: 0x00000001b79811e4 CoreFoundation`CFRunLoopRunSpecific + 612
	    frame #26: 0x00000001f07a1368 GraphicsServices`GSEventRunModal + 164
	    frame #27: 0x00000001b9e30d88 UIKitCore`-[UIApplication _run] + 888
	    frame #28: 0x00000001b9e309ec UIKitCore`UIApplicationMain + 340