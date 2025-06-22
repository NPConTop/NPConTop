-- FPS 1 😮
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

if not _G.Settings then
    _G.Settings = {
        Graphics = {
            FPS = 1, -- ⚠️ FPS 1: Gerakan super lambat
            QualityLevel = 1,
            MeshPartDetail = 1,
            WaterQuality = 0,
            ShadowQuality = 0,
            MaterialQuality = 0,
            RemoveSky = true,
            RemoveAtmosphere = true,
            RemoveClouds = true
        },
        Optimizations = {
            RemoveClothing = false,
            RemoveAccessories = false,
            RemoveParticles = false,
            RemoveEffects = false,
            RemoveTextures = false,
            RemoveMeshes = false,
            RemoveExplosions = false,
            RemovePostEffects = false,
            RemoveLights = false,
            RemoveDecals = false
        },
        Notifications = true
    }
end

local function showNotification(title, text, duration)
    if not _G.Settings.Notifications then return end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5,
            Button1 = "Okay"
        })
    end)
end

local function optimizeGraphics()
    showNotification("FPS Booster", "Menerapkan mode FPS 1...", 2)
    task.wait(0.5)

    local success, err = pcall(function()
        if setfpscap then
            showNotification("FPS Booster", "FPS disetel ke " .. _G.Settings.Graphics.FPS, 2)
            setfpscap(_G.Settings.Graphics.FPS)
        else
            showNotification("FPS Booster", "setfpscap tidak didukung executor.", 3)
        end
    end)
    if not success then
        showNotification("FPS Booster", "Gagal set FPS: " .. tostring(err), 3)
    end
    task.wait(0.5)

    showNotification("FPS Booster", "Optimisasi kualitas rendering...", 2)
    settings().Rendering.QualityLevel = _G.Settings.Graphics.QualityLevel
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    task.wait(0.5)

    showNotification("FPS Booster", "Menonaktifkan bayangan dan kabut...", 2)
    Lighting.GlobalShadows = false
    Lighting.ShadowSoftness = 0
    Lighting.FogEnd = 1e9
    task.wait(0.5)

    if Terrain then
        showNotification("FPS Booster", "Menghapus efek air...", 2)
        Terrain.WaterWaveSize = _G.Settings.Graphics.WaterQuality
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
        pcall(sethiddenproperty, Terrain, "Decoration", false)
        task.wait(0.5)
    end

    if _G.Settings.Graphics.RemoveSky then
        showNotification("FPS Booster", "Menghapus elemen langit...", 2)
        for _, v in ipairs(Lighting:GetDescendants()) do
            if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then
                v:Destroy()
            end
        end
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then
                v:Destroy()
            end
        end
        task.wait(0.5)
    end
end

local function optimizeInstance(instance)
    if not instance then return end

    local opt = _G.Settings.Optimizations

    if opt.RemoveClothing and (instance:IsA("Clothing") or instance:IsA("SurfaceAppearance")) then
        instance:Destroy()
    elseif opt.RemoveParticles and (instance:IsA("ParticleEmitter") or instance:IsA("Trail") or instance:IsA("Smoke") or instance:IsA("Fire") or instance:IsA("Sparkles")) then
        instance.Enabled = false
    elseif opt.RemoveTextures and instance:IsA("Texture") then
        instance.Transparency = 1
    elseif opt.RemoveMeshes and instance:IsA("SpecialMesh") then
        instance.MeshId = ""
    elseif opt.RemoveExplosions and instance:IsA("Explosion") then
        instance.BlastPressure = 1
        instance.BlastRadius = 1
        instance.Visible = false
    elseif opt.RemovePostEffects and instance:IsA("PostEffect") then
        instance.Enabled = false
    elseif opt.RemoveLights and (instance:IsA("SpotLight") or instance:IsA("PointLight") or instance:IsA("SurfaceLight")) then
        instance:Destroy()
    elseif opt.RemoveEffects and instance:IsA("Beam") then
        instance.Enabled = false
    elseif opt.RemoveDecals and instance:IsA("Decal") then
        instance:Destroy()
    elseif instance:IsA("BasePart") then
        instance.Material = Enum.Material.Plastic
        instance.Reflectance = 0
    elseif _G.Settings.Graphics.RemoveSky and (instance:IsA("Sky") or instance:IsA("Atmosphere") or instance:IsA("Clouds")) then
        instance:Destroy()
    end
end

local function initialize()
    showNotification("FPS Booster", "FPS 1 MODE AKTIF BY NPC", math.huge)
    task.wait(2)

    local success, err = pcall(function()
        optimizeGraphics()

        showNotification("FPS Booster", "Mengoptimasi objek...", 2)
        for _, instance in ipairs(game:GetDescendants()) do
            optimizeInstance(instance)
        end
        task.wait(0.5)

        game.DescendantAdded:Connect(optimizeInstance)
        task.wait(0.5)

        showNotification("FPS Booster", "FPS DISETEL KE 1!", 2)
        task.wait(2)

        showNotification("FPS Booster", "FPS BOOSTED TO 1 BY NPC", math.huge)
    end)

    if not success then
        showNotification("FPS Booster", "Gagal: " .. tostring(err), 5)
    end
end

initialize()
