// Require standard library
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
#include <iostream>
#include <UIKit/UIKit.h>
#include <vector>
#import "pthread.h"
#include <array>
#import <os/log.h>
#include <cmath>
#include <deque>
#include <fstream>
#include <algorithm>
#include <string>
#include <sstream>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include <cstdint>
#include <cinttypes>
#include <cerrno>
#include <cctype>

// Imgui library
#import "Esp/CaptainHook.h"
#import "Esp/ImGuiDrawView.h"
#import "IMGUI/imgui.h"
#import "IMGUI/imgui_internal.h"
#import "IMGUI/imgui_impl_metal.h"
#import "IMGUI/zzz.h"

// 🔴 මෙතන තමයි Fonts ටික මුලින්ම Declare කරන්නේ (Hooks.h එකට උඩින්)
ImFont* verdana_smol = nullptr;
ImFont* pixel_big = nullptr;
ImFont* pixel_smol = nullptr;

#include "oxorany/oxorany_include.h"
#import "Helper/Mem.h"
#import "Helper/Vector3.h"
#import "Helper/Vector2.h"
#import "Helper/Quaternion.h"
#import "Helper/Monostring.h"
#include "Helper/font.h"
#include "Helper/data.h"
#include "Helper/Obfuscate.h"

// 🔴 දැන් Hooks.h එකට fonts ටික අඳුරගන්න පුළුවන්
#import "Helper/Hooks.h"

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <unistd.h>
#include <string.h>
#include "Other/dobby_defines.h"
#import "Other/H5hook.h"
#include "Other/Paste.h"

#define Hook(x, y, z) \
{ \
    NSString* result_##y = StaticInlineHookPatch(("Frameworks/UnityFramework.framework/UnityFramework"), x, nullptr); \
    if (result_##y) { \
        void* result = StaticInlineHookFunction(("Frameworks/UnityFramework.framework/UnityFramework"), x, (void *) y); \
        *(void **) (&z) = (void*) result; \
    } \
}

static float fixLoginTimeout = 60.0f;
static bool MenDeal = true;

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale

@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

@implementation ImGuiDrawView
ImFont *_espFont;
ImFont* verdanab;
ImFont* icons;
ImFont* interb;
ImFont* Urbanist;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;

    ImGui::StyleColorsClassic();
    auto& Style = ImGui::GetStyle();
    Style.WindowPadding = ImVec2(8.0f, 8.0f);
    Style.FramePadding = ImVec2(9.0f, 7.0f);
    Style.ScrollbarRounding = 9.0f;
    
    ImVec4* colors = ImGui::GetStyle().Colors;
    colors[ImGuiCol_Text]                   = ImVec4(1.00f, 1.00f, 1.00f, 1.00f);
    colors[ImGuiCol_WindowBg]               = ImVec4(0.06f, 0.06f, 0.08f, 0.94f); 
    colors[ImGuiCol_TitleBgActive]          = ImVec4(0.00f, 0.47f, 0.81f, 1.00f); 
    
    // --- Theme (Blue Theme) ---
    colors[ImGuiCol_CheckMark]              = ImVec4(0.00f, 0.90f, 1.00f, 1.00f); 
    colors[ImGuiCol_SliderGrab]             = ImVec4(0.00f, 0.70f, 1.00f, 1.00f); 
    colors[ImGuiCol_SliderGrabActive]       = ImVec4(0.00f, 0.50f, 1.00f, 1.00f); 
    
    colors[ImGuiCol_Button]                 = ImVec4(0.00f, 0.47f, 0.81f, 0.40f); 
    colors[ImGuiCol_ButtonHovered]          = ImVec4(0.00f, 0.58f, 1.00f, 1.00f); 
    colors[ImGuiCol_ButtonActive]           = ImVec4(0.00f, 0.40f, 0.80f, 1.00f); 
    
    colors[ImGuiCol_Header]                 = ImVec4(0.00f, 0.47f, 0.81f, 0.31f); 
    colors[ImGuiCol_HeaderHovered]          = ImVec4(0.00f, 0.58f, 1.00f, 0.80f);
    colors[ImGuiCol_HeaderActive]           = ImVec4(0.00f, 0.47f, 0.81f, 1.00f);
    
    colors[ImGuiCol_SeparatorHovered]       = ImVec4(0.10f, 0.40f, 0.75f, 0.78f);
    colors[ImGuiCol_SeparatorActive]        = ImVec4(0.10f, 0.40f, 0.75f, 1.00f);
    
    colors[ImGuiCol_Tab]                    = ImVec4(0.00f, 0.40f, 0.70f, 0.86f); 
    colors[ImGuiCol_TabHovered]             = ImVec4(0.00f, 0.58f, 1.00f, 0.80f);
    colors[ImGuiCol_TabActive]              = ImVec4(0.00f, 0.47f, 0.81f, 1.00f);

    ImGui::GetStyle().WindowRounding = 8 / 1.5f;
    ImGui::GetStyle().FrameRounding = 4 / 1.5f;
    ImGui::GetStyle().ChildRounding = 6 / 1.5f;

    ImFont* font = io.Fonts->AddFontFromMemoryTTF(sansbold, sizeof(sansbold), 15.0f, NULL, io.Fonts->GetGlyphRangesCyrillic());
    verdana_smol = io.Fonts->AddFontFromMemoryTTF(verdana, sizeof(verdana), 40, NULL, io.Fonts->GetGlyphRangesCyrillic());
    pixel_big = io.Fonts->AddFontFromMemoryTTF((void*)smallestpixel, sizeof(smallestpixel), 128, NULL, io.Fonts->GetGlyphRangesCyrillic());
    pixel_smol = io.Fonts->AddFontFromMemoryTTF((void*)smallestpixel, sizeof(smallestpixel), 20, NULL, io.Fonts->GetGlyphRangesCyrillic());
    
    ImGui_ImplMetal_Init(_device);

    return self;
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

- (void)loadView
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.view = [[MTKView alloc] initWithFrame:bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;

    Hook(0x4EB3E88 , BLAGCMCGEJG1, old_BLAGCMCGEJG1);
}

#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self updateIOWithTouchEvent:event]; }
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self updateIOWithTouchEvent:event]; }
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self updateIOWithTouchEvent:event]; }
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self updateIOWithTouchEvent:event]; }

#pragma mark - MTKViewDelegate

- (void)drawInMTKView:(MTKView*)view
{
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.nativeScale ?: UIScreen.mainScreen.nativeScale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1.0f / float(view.preferredFramesPerSecond ?: 60);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
        
    [self.view setUserInteractionEnabled:MenDeal];

    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil)
    {
        id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder pushDebugGroup:@"ImGui Main View"];

        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();
        
        CGFloat x = (view.bounds.size.width - 365) / 2;
        CGFloat y = (view.bounds.size.height - 270) / 2;
        ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
        ImGui::SetNextWindowSize(ImVec2(365, 270), ImGuiCond_FirstUseEver);
        
        if (MenDeal)
        {                
            // මෙතනින් තමයි Menu එකේ නම වෙනස් කරලා තියෙන්නේ
            ImGui::Begin(oxorany("Statistics King"), &MenDeal);
            
            if (ImGui::BeginTabBar(oxorany("Tab"), ImGuiTabBarFlags_FittingPolicyScroll)) 
            {
                // === TAB 1: ESP ===
                if (ImGui::BeginTabItem("ESP")) 
                {
                    ImGui::Checkbox(oxorany("Enable Cheats"), &Vars.Enable);
                    ImGui::Separator();

                    if (ImGui::BeginTable("split", 4))
                    {
                        ImGui::TableNextColumn(); ImGui::Checkbox(oxorany("Line"), &Vars.lines);
                        ImGui::TableNextColumn(); ImGui::Checkbox(oxorany("Box"), &Vars.Box);
                        ImGui::TableNextColumn(); ImGui::Checkbox(oxorany("Health"), &Vars.Health);
                        ImGui::TableNextColumn(); ImGui::Checkbox(oxorany("Name"), &Vars.Name);
                        ImGui::TableNextColumn(); ImGui::Checkbox(oxorany("Skeleton"), &Vars.skeleton);
                        ImGui::TableNextColumn(); ImGui::Checkbox(oxorany("Distance"), &Vars.Distance);
                        ImGui::TableNextColumn(); ImGui::Checkbox(oxorany("3D Circle"), &Vars.circlepos);
                        ImGui::TableNextColumn(); ImGui::Checkbox(oxorany("Outline"), &Vars.Outline);
                        ImGui::EndTable();
                    }
                    
                    ImGui::Spacing();
                    ImGui::Checkbox(oxorany("Out of Screen"), &Vars.OOF); ImGui::SameLine();
                    ImGui::Checkbox(oxorany("Enemy Count"), &Vars.enemycount);
                    
                    ImGui::Separator();
                    
                    // --- Fix Login Option ---
                    if (ImGui::Button(oxorany("Fix Login"))) {
                        self.view.hidden = YES; 
                        MenDeal = false; 
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fixLoginTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.view.hidden = NO; 
                            MenDeal = true; 
                        });
                    }
                    ImGui::SameLine();
                    ImGui::SetNextItemWidth(120);
                    ImGui::SliderFloat(oxorany("##fixlogin"), &fixLoginTimeout, 40.0f, 80.0f, oxorany("Fix %.0f s"));

                    ImGui::EndTabItem();
                }
                
                // === TAB 2: AIMBOT ===
                if (ImGui::BeginTabItem("AimBot")) 
                {
                    ImGui::Spacing();
                    ImGui::Checkbox(oxorany("SilentAim"), &SilentAim); ImGui::SameLine();
                    ImGui::Checkbox(oxorany("CheckIsVisible"), &CheckWall1);

                    ImGui::Separator();

                    ImGui::Checkbox("Enable Aimbot", &Vars.Aimbot); ImGui::SameLine();
                    ImGui::Checkbox("Visible", &Vars.VisibleCheck); ImGui::SameLine();
                    ImGui::Checkbox("Knocked", &Vars.IgnoreKnocked); 

                    ImGui::SetNextItemWidth(150);
                    ImGui::Combo("Trigger", &Vars.AimWhen, Vars.dir, 4);

                    ImGui::SetNextItemWidth(150);
                    ImGui::Combo("Hitbox", &Vars.AimHitbox, Vars.aimHitboxes, 3);

                    ImGui::SetNextItemWidth(150);
                    ImGui::Combo("Mode", &Vars.AimMode, Vars.aimModes, 3);

                    if (Vars.AimMode == 2) {
                        ImGui::SliderFloat(oxorany("FOV Size"), &Vars.AimFov, 0.0f, 360.0f, oxorany("%.0f px"));
                    }

                    ImGui::EndTabItem();
                }
                
                // === TAB 3: DEVELOPER INFO ===
                if (ImGui::BeginTabItem("Info Developer")) 
                {
                    ImGui::TextColored(ImVec4(0.0f, 0.8f, 1.0f, 1.0f), "DEVELOPER INFRO");
                    ImGui::TextDisabled("developer by: @chamikadinith");
                    ImGui::EndTabItem();
                }
                
                ImGui::EndTabBar();
            }
            ImGui::End();
        }

        // --- Game Drawing & Logic Calls ---
        ImDrawList* draw_list = ImGui::GetBackgroundDrawList();
        get_players();
        draw_watermark();
        aimbot();
        
        if (game_sdk) {
            game_sdk->init();
        }

        Vars.isAimFov = (Vars.AimFov > 0);

        ImGui::Render();
        ImDrawData* draw_data = ImGui::GetDrawData();
        ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);
      
        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];

        [commandBuffer presentDrawable:view.currentDrawable];
    }

    [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}

@end
