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

    // === PREMIUM 3D MODERN THEME ===
    ImGuiStyle& style = ImGui::GetStyle();
    style.Alpha = 1.0f;
    style.WindowRounding = 12.0f;
    style.FrameRounding = 6.0f;
    style.ChildRounding = 8.0f;
    style.PopupRounding = 8.0f;
    style.ScrollbarRounding = 12.0f;
    style.GrabRounding = 6.0f;
    style.TabRounding = 6.0f;
    style.WindowBorderSize = 1.0f;
    style.FrameBorderSize = 0.0f;
    style.WindowPadding = ImVec2(12.0f, 12.0f);
    style.ItemSpacing = ImVec2(8.0f, 8.0f);
    style.ItemInnerSpacing = ImVec2(6.0f, 6.0f);
    
    ImVec4* colors = style.Colors;
    colors[ImGuiCol_Text]                   = ImVec4(0.95f, 0.96f, 0.98f, 1.00f);
    colors[ImGuiCol_TextDisabled]           = ImVec4(0.36f, 0.42f, 0.47f, 1.00f);
    colors[ImGuiCol_WindowBg]               = ImVec4(0.07f, 0.08f, 0.10f, 0.95f);
    colors[ImGuiCol_ChildBg]                = ImVec4(0.11f, 0.12f, 0.15f, 1.00f);
    colors[ImGuiCol_PopupBg]                = ImVec4(0.08f, 0.08f, 0.08f, 0.94f);
    colors[ImGuiCol_Border]                 = ImVec4(0.00f, 0.85f, 1.00f, 0.50f); // Default neon border
    colors[ImGuiCol_BorderShadow]           = ImVec4(0.00f, 0.00f, 0.00f, 0.00f);
    colors[ImGuiCol_FrameBg]                = ImVec4(0.15f, 0.16f, 0.19f, 1.00f);
    colors[ImGuiCol_FrameBgHovered]         = ImVec4(0.20f, 0.21f, 0.25f, 1.00f);
    colors[ImGuiCol_FrameBgActive]          = ImVec4(0.25f, 0.26f, 0.30f, 1.00f);
    colors[ImGuiCol_TitleBg]                = ImVec4(0.09f, 0.10f, 0.12f, 1.00f);
    colors[ImGuiCol_TitleBgActive]          = ImVec4(0.09f, 0.10f, 0.12f, 1.00f);
    colors[ImGuiCol_TitleBgCollapsed]       = ImVec4(0.00f, 0.00f, 0.00f, 0.51f);
    colors[ImGuiCol_MenuBarBg]              = ImVec4(0.14f, 0.14f, 0.14f, 1.00f);
    colors[ImGuiCol_ScrollbarBg]            = ImVec4(0.02f, 0.02f, 0.02f, 0.53f);
    colors[ImGuiCol_ScrollbarGrab]          = ImVec4(0.31f, 0.31f, 0.31f, 1.00f);
    colors[ImGuiCol_ScrollbarGrabHovered]   = ImVec4(0.41f, 0.41f, 0.41f, 1.00f);
    colors[ImGuiCol_ScrollbarGrabActive]    = ImVec4(0.51f, 0.51f, 0.51f, 1.00f);
    
    // Cyberpunk/Neon Blue Accents
    colors[ImGuiCol_CheckMark]              = ImVec4(0.00f, 0.85f, 1.00f, 1.00f);
    colors[ImGuiCol_SliderGrab]             = ImVec4(0.00f, 0.85f, 1.00f, 1.00f);
    colors[ImGuiCol_SliderGrabActive]       = ImVec4(0.00f, 0.65f, 1.00f, 1.00f);
    colors[ImGuiCol_Button]                 = ImVec4(0.00f, 0.55f, 0.85f, 0.80f);
    colors[ImGuiCol_ButtonHovered]          = ImVec4(0.00f, 0.70f, 1.00f, 1.00f);
    colors[ImGuiCol_ButtonActive]           = ImVec4(0.00f, 0.45f, 0.75f, 1.00f);
    
    colors[ImGuiCol_Header]                 = ImVec4(0.00f, 0.55f, 0.85f, 0.40f);
    colors[ImGuiCol_HeaderHovered]          = ImVec4(0.00f, 0.70f, 1.00f, 0.80f);
    colors[ImGuiCol_HeaderActive]           = ImVec4(0.00f, 0.55f, 0.85f, 1.00f);
    colors[ImGuiCol_Separator]              = ImVec4(0.25f, 0.25f, 0.28f, 0.50f);
    colors[ImGuiCol_SeparatorHovered]       = ImVec4(0.00f, 0.70f, 1.00f, 0.78f);
    colors[ImGuiCol_SeparatorActive]        = ImVec4(0.00f, 0.55f, 0.85f, 1.00f);
    colors[ImGuiCol_Tab]                    = ImVec4(0.15f, 0.16f, 0.19f, 1.00f);
    colors[ImGuiCol_TabHovered]             = ImVec4(0.00f, 0.70f, 1.00f, 0.80f);
    colors[ImGuiCol_TabActive]              = ImVec4(0.00f, 0.55f, 0.85f, 1.00f);
    colors[ImGuiCol_TabUnfocused]           = ImVec4(0.11f, 0.12f, 0.15f, 1.00f);
    colors[ImGuiCol_TabUnfocusedActive]     = ImVec4(0.11f, 0.12f, 0.15f, 1.00f);

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
        
        CGFloat x = (view.bounds.size.width - 420) / 2;
        CGFloat y = (view.bounds.size.height - 320) / 2;
        ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
        ImGui::SetNextWindowSize(ImVec2(420, 320), ImGuiCond_FirstUseEver);
        
        // --- 3D ANIMATED RGB NEON BORDER ---
        float time = ImGui::GetTime();
        float r = (sin(time * 2.0f) * 0.5f) + 0.5f;
        float g = (sin(time * 2.0f + 2.0f) * 0.5f) + 0.5f;
        float b = (sin(time * 2.0f + 4.0f) * 0.5f) + 0.5f;
        ImVec4 animatedBorderColor = ImVec4(r, g, b, 1.0f);
        ImVec4 animatedTitleColor = ImVec4(r, g, b, 0.7f);

        ImGui::PushStyleColor(ImGuiCol_Border, animatedBorderColor);
        ImGui::PushStyleColor(ImGuiCol_TitleBgActive, animatedTitleColor);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 2.0f); // Make border slightly thicker for the glow

        if (MenDeal)
        {                
            ImGui::Begin(oxorany("Statistics King"), &MenDeal, ImGuiWindowFlags_NoCollapse);
            
            // --- Animated Premium Separator under Title ---
            ImVec2 p = ImGui::GetCursorScreenPos();
            ImVec2 window_size = ImGui::GetWindowSize();
            ImDrawList* draw_list = ImGui::GetWindowDrawList();
            draw_list->AddRectFilledMultiColor(ImVec2(p.x - 12, p.y - 6), ImVec2(p.x + window_size.x - 12, p.y - 4), 
                                               ImColor(r, g, b, 1.0f), ImColor(0.0f, 0.8f, 1.0f, 1.0f), 
                                               ImColor(0.0f, 0.8f, 1.0f, 1.0f), ImColor(r, g, b, 1.0f));
            
            ImGui::Spacing();

            if (ImGui::BeginTabBar(oxorany("Tab"), ImGuiTabBarFlags_FittingPolicyScroll)) 
            {
                // === TAB 1: ESP ===
                if (ImGui::BeginTabItem("ESP Features")) 
                {
                    ImGui::Spacing();
                    
                    // Main Enable Checkbox customized
                    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 0.0f, 1.0f));
                    ImGui::Checkbox(oxorany("Enable Cheats Master Switch"), &Vars.Enable);
                    ImGui::PopStyleColor();
                    
                    ImGui::Separator();
                    ImGui::Spacing();

                    // Modern styled table for ESP Checkboxes
                    if (ImGui::BeginTable("split", 4, ImGuiTableFlags_BordersInnerV | ImGuiTableFlags_RowBg))
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
                    ImGui::Separator();
                    ImGui::Spacing();

                    ImGui::Checkbox(oxorany("Out of Screen"), &Vars.OOF); ImGui::SameLine(180);
                    ImGui::Checkbox(oxorany("Enemy Count"), &Vars.enemycount);
                    
                    ImGui::Spacing();
                    
                    // --- Fix Login Option Styled ---
                    ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.8f, 0.2f, 0.2f, 0.7f));
                    ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(1.0f, 0.3f, 0.3f, 1.0f));
                    if (ImGui::Button(oxorany("Fix Login Issue"), ImVec2(130, 25))) {
                        self.view.hidden = YES; 
                        MenDeal = false; 
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fixLoginTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.view.hidden = NO; 
                            MenDeal = true; 
                        });
                    }
                    ImGui::PopStyleColor(2);
                    
                    ImGui::SameLine();
                    ImGui::SetNextItemWidth(150);
                    ImGui::SliderFloat(oxorany("##fixlogin"), &fixLoginTimeout, 40.0f, 80.0f, oxorany("Duration: %.0f s"));

                    ImGui::EndTabItem();
                }
                
                // === TAB 2: AIMBOT ===
                if (ImGui::BeginTabItem("AimBot & Combat")) 
                {
                    ImGui::Spacing();
                    ImGui::Checkbox(oxorany("Silent Aim"), &SilentAim); ImGui::SameLine(180);
                    ImGui::Checkbox(oxorany("Check Is Visible"), &CheckWall1);

                    ImGui::Spacing();
                    ImGui::Separator();
                    ImGui::Spacing();

                    ImGui::Checkbox("Enable Aimbot", &Vars.Aimbot); ImGui::SameLine(150);
                    ImGui::Checkbox("Visible Only", &Vars.VisibleCheck); ImGui::SameLine(280);
                    ImGui::Checkbox("Ignore Knocked", &Vars.IgnoreKnocked); 

                    ImGui::Spacing();
                    ImGui::Separator();
                    ImGui::Spacing();

                    ImGui::SetNextItemWidth(160);
                    ImGui::Combo("Trigger Condition", &Vars.AimWhen, Vars.dir, 4);

                    ImGui::SetNextItemWidth(160);
                    ImGui::Combo("Target Hitbox", &Vars.AimHitbox, Vars.aimHitboxes, 3);

                    ImGui::SetNextItemWidth(160);
                    ImGui::Combo("Aimbot Mode", &Vars.AimMode, Vars.aimModes, 3);

                    if (Vars.AimMode == 2) {
                        ImGui::Spacing();
                        ImGui::SetNextItemWidth(250);
                        ImGui::SliderFloat(oxorany("FOV Size"), &Vars.AimFov, 0.0f, 360.0f, oxorany("%.0f px Radius"));
                    }

                    ImGui::EndTabItem();
                }
                
                // === TAB 3: DEVELOPER INFO ===
                if (ImGui::BeginTabItem("Developer Info")) 
                {
                    ImGui::Spacing();
                    ImGui::TextColored(animatedBorderColor, "DEVELOPER INFORMATION"); // Animated text color
                    ImGui::Separator();
                    ImGui::Spacing();
                    
                    ImGui::Text("Developed & Maintained By:");
                    ImGui::TextColored(ImVec4(0.0f, 0.85f, 1.0f, 1.0f), "@chamikadinith");
                    
                    ImGui::Spacing();
                    ImGui::TextDisabled("Status: Undetected & Premium Version");
                    ImGui::EndTabItem();
                }
                
                ImGui::EndTabBar();
            }
            ImGui::End();
        }
        
        ImGui::PopStyleVar();
        ImGui::PopStyleColor(2);

        // --- Game Drawing & Logic Calls (UNTOUCHED) ---
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
