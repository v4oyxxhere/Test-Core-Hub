--============================================================
-- CORE HUB | SLAP DUELS
-- By V4oyxx
--
-- Combat
-- Movement
-- World
-- Visuals
-- Settings
-- Status
--
-- Left Ctrl = Hide / Show UI
--============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

local Character =
    LocalPlayer.Character
    or LocalPlayer.CharacterAdded:Wait()

local Humanoid =
    Character:WaitForChild("Humanoid")

--============================================================
-- RAYFIELD
--============================================================

local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

--============================================================
-- COLORS
--============================================================

local COLORS = {

    Background =
        Color3.fromRGB(
            20,
            13,
            28
        ),

    Topbar =
        Color3.fromRGB(
            27,
            17,
            38
        ),

    Panel =
        Color3.fromRGB(
            31,
            20,
            43
        ),

    Element =
        Color3.fromRGB(
            47,
            30,
            65
        ),

    ElementHover =
        Color3.fromRGB(
            58,
            38,
            80
        ),

    Accent =
        Color3.fromRGB(
            151,
            84,
            213
        ),

    AccentLight =
        Color3.fromRGB(
            187,
            126,
            235
        ),

    Text =
        Color3.fromRGB(
            240,
            235,
            245
        ),

    SubText =
        Color3.fromRGB(
            170,
            155,
            181
        ),

    Stroke =
        Color3.fromRGB(
            83,
            53,
            110
        ),

    Disabled =
        Color3.fromRGB(
            67,
            44,
            82
        )
}

--============================================================
-- PURPLE THEME
--============================================================

local PurpleTheme = {

    TextColor =
        COLORS.Text,

    Background =
        COLORS.Background,

    Topbar =
        COLORS.Topbar,

    Shadow =
        Color3.fromRGB(
            12,
            8,
            18
        ),

    NotificationBackground =
        COLORS.Panel,

    NotificationActionsBackground =
        COLORS.Accent,

    TabBackground =
        Color3.fromRGB(
            39,
            25,
            53
        ),

    TabStroke =
        COLORS.Stroke,

    TabBackgroundSelected =
        COLORS.AccentLight,

    TabTextColor =
        COLORS.SubText,

    SelectedTabTextColor =
        Color3.fromRGB(
            45,
            25,
            58
        ),

    ElementBackground =
        COLORS.Element,

    ElementBackgroundHover =
        COLORS.ElementHover,

    SecondaryElementBackground =
        Color3.fromRGB(
            38,
            24,
            52
        ),

    ElementStroke =
        COLORS.Stroke,

    SecondaryElementStroke =
        Color3.fromRGB(
            69,
            44,
            91
        ),

    SliderBackground =
        Color3.fromRGB(
            72,
            44,
            94
        ),

    SliderProgress =
        COLORS.AccentLight,

    SliderStroke =
        COLORS.Accent,

    ToggleBackground =
        COLORS.Disabled,

    ToggleEnabled =
        COLORS.Accent,

    ToggleDisabled =
        COLORS.Disabled,

    ToggleEnabledStroke =
        COLORS.AccentLight,

    ToggleDisabledStroke =
        COLORS.Stroke,

    ToggleEnabledOuterStroke =
        COLORS.Stroke,

    ToggleDisabledOuterStroke =
        Color3.fromRGB(
            55,
            35,
            71
        ),

    DropdownSelected =
        COLORS.ElementHover,

    DropdownUnselected =
        COLORS.Element,

    InputBackground =
        Color3.fromRGB(
            38,
            24,
            52
        ),

    InputStroke =
        COLORS.Stroke,

    PlaceholderColor =
        COLORS.SubText
}

--============================================================
-- WINDOW
--============================================================

local Window =
    Rayfield:CreateWindow({

        Name =
            "Core Hub | Slap Duels",

        Icon = 0,

        LoadingTitle =
            "Core Hub | Slap Duels",

        LoadingSubtitle =
            "By V4oyxx",

        ShowText =
            "Core Hub",

        Theme =
            PurpleTheme,

        ToggleUIKeybind =
            Enum.KeyCode.LeftControl,

        DisableRayfieldPrompts =
            false,

        DisableBuildWarnings =
            false,

        ConfigurationSaving = {
            Enabled = false
        },

        Discord = {
            Enabled = false,
            Invite = "",
            RememberJoins = false
        },

        KeySystem = false
    })

--============================================================
-- GLOBAL SETTINGS
--============================================================

local DEFAULT_HITBOX = 10
local DEFAULT_SPEED = 16

local HitboxEnabled = false
local VisualizeHitbox = true

local HitboxSize =
    DEFAULT_HITBOX

local HitboxColor =
    COLORS.Element

local HitboxTransparency =
    0.75

local SpeedEnabled = false

local MovementSpeed =
    DEFAULT_SPEED

local InfiniteJump = false

local nightTimeEnabled = false
local originalSky = nil

--============================================================
-- HITBOX STORAGE
--============================================================

local VisualCache = {}
local OriginalHitboxes = {}

--============================================================
-- SAVE ORIGINAL HITBOX
--============================================================

local function SaveOriginal(
    Player,
    HRP
)

    if OriginalHitboxes[Player] then
        return
    end

    OriginalHitboxes[Player] = {

        Size =
            HRP.Size,

        Transparency =
            HRP.Transparency,

        CanCollide =
            HRP.CanCollide
    }
end

--============================================================
-- CREATE PURPLE HITBOX VISUAL
--============================================================

local function CreateVisual(HRP)

    if VisualCache[HRP] then
        return VisualCache[HRP]
    end

    local Adornment =
        Instance.new(
            "BoxHandleAdornment"
        )

    Adornment.Name =
        "CoreHubHitboxVisual"

    Adornment.Adornee =
        HRP

    Adornment.AlwaysOnTop =
        true

    Adornment.Size =
        Vector3.new(
            HitboxSize,
            HitboxSize,
            HitboxSize
        )

    Adornment.Color3 =
        HitboxColor

    Adornment.Transparency =
        HitboxTransparency

    Adornment.ZIndex =
        10

    Adornment.Visible =
        VisualizeHitbox

    Adornment.Parent =
        HRP

    VisualCache[HRP] =
        Adornment

    return Adornment
end

--============================================================
-- REMOVE VISUAL
--============================================================

local function RemoveVisual(HRP)

    local Visual =
        VisualCache[HRP]

    if Visual then

        Visual:Destroy()

        VisualCache[HRP] =
            nil
    end
end

--============================================================
-- APPLY HITBOX
--============================================================

local function ApplyHitbox(Player)

    if Player == LocalPlayer then
        return
    end

    local TargetCharacter =
        Player.Character

    if not TargetCharacter then
        return
    end

    local HRP =
        TargetCharacter:
        FindFirstChild(
            "HumanoidRootPart"
        )

    local TargetHumanoid =
        TargetCharacter:
        FindFirstChildOfClass(
            "Humanoid"
        )

    if not HRP
        or not TargetHumanoid
        or TargetHumanoid.Health <= 0 then

        return
    end

    SaveOriginal(
        Player,
        HRP
    )

    HRP.Size =
        Vector3.new(
            HitboxSize,
            HitboxSize,
            HitboxSize
        )

    HRP.CanCollide =
        false

    HRP.Transparency =
        1

    local Visual =
        CreateVisual(HRP)

    Visual.Size =
        Vector3.new(
            HitboxSize,
            HitboxSize,
            HitboxSize
        )

    Visual.Color3 =
        HitboxColor

    Visual.Transparency =
        HitboxTransparency

    Visual.Visible =
        VisualizeHitbox
end

--============================================================
-- RESTORE HITBOX
--============================================================

local function RestoreHitbox(Player)

    local TargetCharacter =
        Player.Character

    if not TargetCharacter then
        return
    end

    local HRP =
        TargetCharacter:
        FindFirstChild(
            "HumanoidRootPart"
        )

    if not HRP then
        return
    end

    local Original =
        OriginalHitboxes[Player]

    if Original then

        HRP.Size =
            Original.Size

        HRP.Transparency =
            Original.Transparency

        HRP.CanCollide =
            Original.CanCollide

    else

        HRP.Size =
            Vector3.new(
                2,
                2,
                1
            )
    end

    RemoveVisual(HRP)

    OriginalHitboxes[Player] =
        nil
end

--============================================================
-- RESTORE ALL HITBOXES
--============================================================

local function RestoreAllHitboxes()

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do

        if Player ~= LocalPlayer then

            RestoreHitbox(
                Player
            )
        end
    end
end

--============================================================
-- HITBOX UPDATE LOOP
--============================================================

RunService.Heartbeat:
Connect(function()

    if not HitboxEnabled then
        return
    end

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do

        if Player ~= LocalPlayer
            and Player.Character then

            ApplyHitbox(
                Player
            )
        end
    end
end)

--============================================================
-- NEW PLAYERS
--============================================================

Players.PlayerAdded:
Connect(function(Player)

    Player.CharacterAdded:
    Connect(function()

        task.wait(0.25)

        if HitboxEnabled then
            ApplyHitbox(Player)
        end
    end)
end)

Players.PlayerRemoving:
Connect(function(Player)

    OriginalHitboxes[Player] =
        nil
end)

--============================================================
-- COMBAT TAB
--============================================================

local CombatTab =
    Window:CreateTab(
        "Combat",
        4483362458
    )

CombatTab:CreateSection(
    "Hitbox Extender"
)

--============================================================
-- ENABLE HITBOX
--============================================================

local HitboxToggle =
    CombatTab:
    CreateToggle({

        Name =
            "Enable Hitbox",

        CurrentValue =
            false,

        Flag =
            "CoreHitboxEnabled",

        Callback =
            function(Value)

                HitboxEnabled =
                    Value

                if Value then

                    for _, Player in ipairs(
                        Players:GetPlayers()
                    ) do

                        if Player ~=
                            LocalPlayer then

                            ApplyHitbox(
                                Player
                            )
                        end
                    end

                else

                    RestoreAllHitboxes()
                end

                Rayfield:Notify({

                    Title =
                        "Core Hub",

                    Content =
                        Value
                        and "Hitbox Enabled"
                        or "Hitbox Disabled",

                    Duration = 2
                })
            end
    })

--============================================================
-- HITBOX SIZE
--============================================================

local HitboxSlider =
    CombatTab:
    CreateSlider({

        Name =
            "Hitbox Size",

        Range = {
            5,
            30
        },

        Increment = 1,

        Suffix =
            " Studs",

        CurrentValue =
            DEFAULT_HITBOX,

        Flag =
            "CoreHitboxSize",

        Callback =
            function(Value)

                HitboxSize =
                    Value

            end
    })

--============================================================
-- CUSTOM HITBOX SIZE
--============================================================

CombatTab:CreateInput({

    Name =
        "Custom Hitbox Size",

    CurrentValue =
        "",

    PlaceholderText =
        "5 - 30",

    RemoveTextAfterFocusLost =
        true,

    Flag =
        "CoreCustomHitbox",

    Callback =
        function(Text)

            local Number =
                tonumber(Text)

            if not Number then
                return
            end

            Number =
                math.clamp(
                    math.floor(Number),
                    5,
                    30
                )

            HitboxSize =
                Number

            HitboxSlider:Set(
                Number
            )
        end
})

--============================================================
-- VISUALIZE HITBOX
--============================================================

local VisualToggle =
    CombatTab:
    CreateToggle({

        Name =
            "Visualize Hitbox",

        CurrentValue =
            true,

        Flag =
            "CoreVisualHitbox",

        Callback =
            function(Value)

                VisualizeHitbox =
                    Value

                for _, Visual in pairs(
                    VisualCache
                ) do

                    if Visual then
                        Visual.Visible =
                            Value
                    end
                end
            end
    })

--============================================================
-- HITBOX PRESETS
--============================================================

CombatTab:CreateSection(
    "Hitbox Presets"
)

CombatTab:CreateButton({

    Name =
        "Default | 10",

    Callback =
        function()

            HitboxSize = 10
            HitboxSlider:Set(10)
        end
})

CombatTab:CreateButton({

    Name =
        "Medium | 15",

    Callback =
        function()

            HitboxSize = 15
            HitboxSlider:Set(15)
        end
})

CombatTab:CreateButton({

    Name =
        "Large | 20",

    Callback =
        function()

            HitboxSize = 20
            HitboxSlider:Set(20)
        end
})

CombatTab:CreateButton({

    Name =
        "Maximum | 30",

    Callback =
        function()

            HitboxSize = 30
            HitboxSlider:Set(30)
        end
})

CombatTab:CreateButton({

    Name =
        "Reset Hitbox",

    Callback =
        function()

            HitboxEnabled =
                false

            HitboxSize =
                DEFAULT_HITBOX

            HitboxToggle:Set(
                false
            )

            HitboxSlider:Set(
                DEFAULT_HITBOX
            )

            RestoreAllHitboxes()
        end
})

--============================================================
-- MOVEMENT TAB
--============================================================

local MovementTab =
    Window:CreateTab(
        "Movement",
        4483362458
    )

MovementTab:CreateSection(
    "Movement Boosts"
)

--============================================================
-- SPEED TOGGLE
--============================================================

local SpeedToggle =
    MovementTab:
    CreateToggle({

        Name =
            "Enable Speed",

        CurrentValue =
            false,

        Flag =
            "CoreSpeedEnabled",

        Callback =
            function(Value)

                SpeedEnabled =
                    Value

                if not Value
                    and Humanoid then

                    Humanoid.WalkSpeed =
                        DEFAULT_SPEED
                end
            end
    })

--============================================================
-- MOVEMENT SPEED
--============================================================

local SpeedSlider =
    MovementTab:
    CreateSlider({

        Name =
            "Movement Speed",

        Range = {
            16,
            100
        },

        Increment = 1,

        Suffix = "",

        CurrentValue =
            DEFAULT_SPEED,

        Flag =
            "CoreMovementSpeed",

        Callback =
            function(Value)

                MovementSpeed =
                    Value

                if SpeedEnabled
                    and Humanoid then

                    Humanoid.WalkSpeed =
                        Value
                end
            end
    })

--============================================================
-- KEEP SPEED
--============================================================

RunService.Heartbeat:
Connect(function()

    if SpeedEnabled
        and Humanoid
        and Humanoid.Parent then

        Humanoid.WalkSpeed =
            MovementSpeed
    end
end)

--============================================================
-- SPEED PRESETS
--============================================================

MovementTab:CreateSection(
    "Speed Presets"
)

MovementTab:CreateButton({

    Name = "Normal | 16",

    Callback =
        function()

            MovementSpeed = 16
            SpeedSlider:Set(16)
        end
})

MovementTab:CreateButton({

    Name = "Fast | 30",

    Callback =
        function()

            MovementSpeed = 30
            SpeedSlider:Set(30)
        end
})

MovementTab:CreateButton({

    Name = "Very Fast | 50",

    Callback =
        function()

            MovementSpeed = 50
            SpeedSlider:Set(50)
        end
})

MovementTab:CreateButton({

    Name = "Maximum | 100",

    Callback =
        function()

            MovementSpeed = 100
            SpeedSlider:Set(100)
        end
})

--============================================================
-- INFINITE JUMP
--============================================================

MovementTab:CreateSection(
    "Jump"
)

local InfiniteJumpToggle =
    MovementTab:
    CreateToggle({

        Name =
            "Infinite Jump",

        CurrentValue =
            false,

        Flag =
            "CoreInfiniteJump",

        Callback =
            function(Value)

                InfiniteJump =
                    Value
            end
    })

UserInputService.JumpRequest:
Connect(function()

    if not InfiniteJump then
        return
    end

    if Humanoid then

        Humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end
end)

--============================================================
-- RESET MOVEMENT
--============================================================

MovementTab:CreateButton({

    Name =
        "Reset Movement",

    Callback =
        function()

            SpeedEnabled =
                false

            MovementSpeed =
                DEFAULT_SPEED

            InfiniteJump =
                false

            SpeedToggle:Set(
                false
            )

            SpeedSlider:Set(
                DEFAULT_SPEED
            )

            InfiniteJumpToggle:Set(
                false
            )

            if Humanoid then

                Humanoid.WalkSpeed =
                    DEFAULT_SPEED
            end
        end
})

--============================================================
-- RESPAWN SUPPORT
--============================================================

LocalPlayer.CharacterAdded:
Connect(function(NewCharacter)

    Character =
        NewCharacter

    Humanoid =
        NewCharacter:
        WaitForChild(
            "Humanoid"
        )

    task.wait(0.2)

    if SpeedEnabled then

        Humanoid.WalkSpeed =
            MovementSpeed
    end
end)

--============================================================
-- WORLD TAB
-- YOUR SETTINGS / YOUR IDs
--============================================================

local WorldTab =
    Window:CreateTab(
        "World",
        4483362458
    )

WorldTab:CreateSection(
    "Visual Modifications"
)

--============================================================
-- KILL TEXTURES
--============================================================

WorldTab:CreateButton({

    Name =
        "Kill Textures",

    Callback =
        function()

            for _, obj in ipairs(
                workspace:GetDescendants()
            ) do

                if obj:IsA("BasePart")
                    or obj:IsA("MeshPart")
                    or obj:IsA("UnionOperation") then

                    obj.Material =
                        Enum.Material.Plastic

                    obj.Color =
                        Color3.fromRGB(
                            200,
                            200,
                            200
                        )

                elseif obj:IsA("Texture")
                    or obj:IsA("Decal")
                    or obj:IsA("SurfaceAppearance") then

                    obj:Destroy()
                end
            end

            Rayfield:Notify({

                Title =
                    "Core Hub",

                Content =
                    "All unnecessary textures/decals removed.",

                Duration = 4
            })
        end
})

--============================================================
-- NIGHT MODE
--============================================================

local NightToggle =
    WorldTab:
    CreateToggle({

        Name =
            "Night Time",

        CurrentValue =
            false,

        Flag =
            "CoreNightTime",

        Callback =
            function(state)

                nightTimeEnabled =
                    state

                local sky =
                    Lighting:
                    FindFirstChildOfClass(
                        "Sky"
                    )

                if state then

                    if sky
                        and not originalSky then

                        originalSky =
                            sky:Clone()
                    end

                    if sky then

                        sky.SkyboxBk =
                            "rbxassetid://0"

                        sky.SkyboxDn =
                            "rbxassetid://0"

                        sky.SkyboxFt =
                            "rbxassetid://0"

                        sky.SkyboxLf =
                            "rbxassetid://0"

                        sky.SkyboxRt =
                            "rbxassetid://0"

                        sky.SkyboxUp =
                            "rbxassetid://0"

                        sky.StarCount = 0

                        sky.CelestialBodiesShown =
                            false

                        sky.MoonAngularSize = 0
                        sky.SunAngularSize = 0

                    else

                        sky =
                            Instance.new(
                                "Sky"
                            )

                        sky.Parent =
                            Lighting

                        sky.SkyboxBk =
                            "rbxassetid://0"

                        sky.SkyboxDn =
                            "rbxassetid://0"

                        sky.SkyboxFt =
                            "rbxassetid://0"

                        sky.SkyboxLf =
                            "rbxassetid://0"

                        sky.SkyboxRt =
                            "rbxassetid://0"

                        sky.SkyboxUp =
                            "rbxassetid://0"

                        sky.StarCount = 0

                        sky.CelestialBodiesShown =
                            false

                        sky.MoonAngularSize = 0
                        sky.SunAngularSize = 0
                    end

                    Lighting.ClockTime =
                        0

                    Lighting.GlobalShadows =
                        true

                else

                    if originalSky then

                        originalSky.Parent =
                            Lighting

                        if sky then
                            sky:Destroy()
                        end

                        originalSky =
                            nil

                    elseif sky then

                        sky.SkyboxBk =
                            "rbxassetid://600830446"

                        sky.SkyboxDn =
                            "rbxassetid://600831635"

                        sky.SkyboxFt =
                            "rbxassetid://600832720"

                        sky.SkyboxLf =
                            "rbxassetid://600833862"

                        sky.SkyboxRt =
                            "rbxassetid://600835007"

                        sky.SkyboxUp =
                            "rbxassetid://600836181"

                        sky.StarCount =
                            3000

                        sky.CelestialBodiesShown =
                            true

                        sky.MoonAngularSize =
                            11

                        sky.SunAngularSize =
                            21
                    end

                    Lighting.ClockTime =
                        12
                end
            end
    })

--============================================================
-- VISUALS TAB
--============================================================

local VisualsTab =
    Window:CreateTab(
        "Visuals",
        4483362458
    )

VisualsTab:CreateSection(
    "Hitbox Appearance"
)

--============================================================
-- COLOR
--============================================================

local HitboxColorPicker =
    VisualsTab:
    CreateColorPicker({

        Name =
            "Hitbox Color",

        Color =
            COLORS.Element,

        Flag =
            "CoreHitboxColor",

        Callback =
            function(Value)

                HitboxColor =
                    Value

                for _, Visual in pairs(
                    VisualCache
                ) do

                    if Visual then

                        Visual.Color3 =
                            Value
                    end
                end
            end
    })

--============================================================
-- TRANSPARENCY
--============================================================

local TransparencySlider =
    VisualsTab:
    CreateSlider({

        Name =
            "Hitbox Transparency",

        Range = {
            1,
            9
        },

        Increment = 1,

        Suffix =
            "/10",

        CurrentValue =
            7,

        Flag =
            "CoreHitboxTransparency",

        Callback =
            function(Value)

                HitboxTransparency =
                    Value / 10

                for _, Visual in pairs(
                    VisualCache
                ) do

                    if Visual then

                        Visual.Transparency =
                            HitboxTransparency
                    end
                end
            end
    })

--============================================================
-- PURPLE PRESETS
--============================================================

VisualsTab:CreateSection(
    "Purple Presets"
)

VisualsTab:CreateButton({

    Name =
        "UI Purple",

    Callback =
        function()

            HitboxColor =
                COLORS.Element

            HitboxColorPicker:Set(
                COLORS.Element
            )
        end
})

VisualsTab:CreateButton({

    Name =
        "Bright Purple",

    Callback =
        function()

            HitboxColor =
                COLORS.Accent

            HitboxColorPicker:Set(
                COLORS.Accent
            )
        end
})

--============================================================
-- SETTINGS TAB
--============================================================

local SettingsTab =
    Window:CreateTab(
        "Settings",
        4483362458
    )

SettingsTab:CreateSection(
    "Core Hub"
)

SettingsTab:CreateLabel(
    "Core Hub | Slap Duels"
)

SettingsTab:CreateLabel(
    "By V4oyxx"
)

SettingsTab:CreateLabel(
    "Left Ctrl = Hide / Show UI"
)

--============================================================
-- RESET EVERYTHING
--============================================================

SettingsTab:CreateButton({

    Name =
        "Reset Everything",

    Callback =
        function()

            -- HITBOX

            HitboxEnabled =
                false

            HitboxSize =
                DEFAULT_HITBOX

            VisualizeHitbox =
                true

            HitboxToggle:Set(
                false
            )

            HitboxSlider:Set(
                DEFAULT_HITBOX
            )

            VisualToggle:Set(
                true
            )

            RestoreAllHitboxes()

            -- MOVEMENT

            SpeedEnabled =
                false

            MovementSpeed =
                DEFAULT_SPEED

            InfiniteJump =
                false

            SpeedToggle:Set(
                false
            )

            SpeedSlider:Set(
                DEFAULT_SPEED
            )

            InfiniteJumpToggle:Set(
                false
            )

            if Humanoid then

                Humanoid.WalkSpeed =
                    DEFAULT_SPEED
            end

            -- NIGHT

            if nightTimeEnabled then

                NightToggle:Set(
                    false
                )
            end

            Rayfield:Notify({

                Title =
                    "Core Hub",

                Content =
                    "Everything reset.",

                Duration = 3
            })
        end
})

--============================================================
-- STATUS SECTION - LAST
--============================================================

SettingsTab:CreateSection(
    "Status"
)

local HitboxStatus =
    SettingsTab:CreateLabel(
        "Hitbox: OFF"
    )

local VisualStatus =
    SettingsTab:CreateLabel(
        "Hitbox Visual: ON"
    )

local SizeStatus =
    SettingsTab:CreateLabel(
        "Hitbox Size: 10"
    )

local SpeedStatus =
    SettingsTab:CreateLabel(
        "Speed: OFF | 16"
    )

local JumpStatus =
    SettingsTab:CreateLabel(
        "Infinite Jump: OFF"
    )

local NightStatus =
    SettingsTab:CreateLabel(
        "Night Time: OFF"
    )

--============================================================
-- STATUS UPDATE LOOP
--============================================================

task.spawn(function()

    while task.wait(0.25) do

        HitboxStatus:Set(
            "Hitbox: "
            ..
            (
                HitboxEnabled
                and "ON"
                or "OFF"
            )
        )

        VisualStatus:Set(
            "Hitbox Visual: "
            ..
            (
                VisualizeHitbox
                and "ON"
                or "OFF"
            )
        )

        SizeStatus:Set(
            "Hitbox Size: "
            ..
            tostring(
                HitboxSize
            )
        )

        SpeedStatus:Set(
            "Speed: "
            ..
            (
                SpeedEnabled
                and "ON"
                or "OFF"
            )
            ..
            " | "
            ..
            tostring(
                MovementSpeed
            )
        )

        JumpStatus:Set(
            "Infinite Jump: "
            ..
            (
                InfiniteJump
                and "ON"
                or "OFF"
            )
        )

        NightStatus:Set(
            "Night Time: "
            ..
            (
                nightTimeEnabled
                and "ON"
                or "OFF"
            )
        )
    end
end)

--============================================================
-- LOADED
--============================================================

Rayfield:Notify({

    Title =
        "Core Hub | Slap Duels",

    Content =
        "Loaded successfully | By V4oyxx",

    Duration =
        3
})

print(
    "[Core Hub] Slap Duels loaded | By V4oyxx"
)
