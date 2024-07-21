stage = {}

local BG_OPACITY = 0.06

-- local FlashTweener = require("FlashTweener")

local UnityEngine = CS.UnityEngine
local GameObject = UnityEngine.GameObject
local Vector2 = UnityEngine.Vector2
local Vector3 = UnityEngine.Vector3
local ColorRGB = UnityEngine.Color
local Image = UnityEngine.UI.Image
local _JudgeArea = nil
local _Lane = nil
local _BeatBarObjectPool = nil
local _TouchArea = nil
local _ComboView = nil
local _CameraCanvas = nil
local _MusicTimePanel = nil
local _BossBar = nil
local _BGImg = nil
local _BGPattern = nil
local _EnemyCanvas = nil

local SaveSliderY = 0

local Flash = nil
local _CameraCanvasGroup = nil

stage.Setup = function()
    PLAYERSTATS:SetLife(1)
    _JudgeArea = GameObject.Find("JudgeArea")
    _Lane = GameObject.Find("Lane")
    _BeatBarObjectPool = GameObject.Find("BeatBarObjectPool")
    _TouchArea = GameObject.Find("TouchArea")
    _ComboView = GameObject.Find("ComboView")
    _CameraCanvas = GameObject.Find("CameraCanvas")
    _MusicTimePanel = GameObject.Find("MusicTimePanel")

    local _PlayModeImage = GameObject.Find("PlayModeImage")
    if _PlayModeImage then
        _PlayModeImage.transform.pivot = Vector2(4.15, 0.5)
    end

    SaveSliderY = _MusicTimePanel.transform.localPosition.y - 50

    --Building bossbar
    local Slider = _MusicTimePanel.transform:Find("Slider")
    _BossBar = GameObject.Instantiate(Slider)
    _BossBar.transform:SetParent(_CameraCanvas.transform, false)
    _BossBar.transform.localPosition = Vector3(0, 800, 0)
    _BossBarBGFill = _BossBar.transform:Find("Fill Area")
    _BossBarBGFill.transform.localScale = Vector3(1, 1.25, 1)
    _BossBarBGFill:GetComponent(typeof(Image)).color = util.ColorRGB(0, 81, 13, 1)
    _BossBarFill = _BossBarBGFill.transform:Find("Fill")
    _BossBarFill:GetComponent(typeof(Image)).color = util.ColorRGB(0, 201, 33, 1)

    local _uiText = ACTORFACTORY:CreateUIText()
    local _uiTextTransform = _uiText:GetRectTransform()
    _uiText.name = "BossName"
    local textComp = _uiTextTransform.gameObject:GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
    textComp.horizontalAlignment = CS.TMPro.HorizontalAlignmentOptions.Right
    _uiTextTransform.anchorMin = Vector2(-0.3, -1)
    _uiTextTransform:SetParent(_BossBar.transform, false)
    _uiText:SetText(boss.NAME)
    _uiText:SetSize(23)
    _uiTextTransform.anchorMin = Vector2(0, 0)
    _uiTextTransform.anchorMax = Vector2(-1.2, 1)

    --Building background
    local bgTex = UTIL:LoadTexture("danmaku/textures/Background_Danmaku.png")
    _BGImg = GameObject("BackgroundImg")
    local BGImgComp = _BGImg:AddComponent(typeof(UnityEngine.Canvas))
    local BGImgScale = _BGImg:AddComponent(typeof(UnityEngine.UI.CanvasScaler))
    BGImgComp.planeDistance = 10
    BGImgComp.worldCamera = CAMERAMAN:GetCamera()
    BGImgComp.renderMode = UnityEngine.RenderMode.ScreenSpaceCamera
    BGImgScale.uiScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize
    BGImgScale.matchWidthOrHeight = 1
    --And a bit of pattern
    _BGPattern = GameObject("Pattern")
    _BGPattern.transform.localPosition = Vector3(0, 0, 2.2)
    _BGPattern.transform.eulerAngles = Vector3(90, 0, 0)
    _BGPattern.transform.localScale = Vector3(1.8, 1.8, 1.8)
    BGPattern = _BGPattern:AddComponent(typeof(UnityEngine.SpriteRenderer))
    BGPattern.sprite = UTIL:CreateSprite(bgTex)
    BGPattern.color = UnityEngine.Color(1, 1, 1, 0)

    --Building fade top nav when player is on it
    _CameraCanvasGroup = _CameraCanvas:AddComponent(typeof(UnityEngine.CanvasGroup))

    --Building flash component
    local FlashCanvas = GameObject("FlashCanvas")
    local FlashCanvasComp = FlashCanvas:AddComponent(typeof(UnityEngine.Canvas))
    local FlashCanvasScale = FlashCanvas:AddComponent(typeof(UnityEngine.UI.CanvasScaler))
    FlashCanvasComp.sortingOrder = 2
    FlashCanvasComp.planeDistance = 20
    FlashCanvasComp.worldCamera = CAMERAMAN:GetCamera()
    FlashCanvasComp.renderMode = UnityEngine.RenderMode.ScreenSpaceCamera
    FlashCanvasScale.uiScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize
    FlashCanvasScale.referenceResolution = Vector2(1920, 1080)
    FlashCanvasScale.matchWidthOrHeight = 1
    _FlashScreen = FlashCanvas:AddComponent(typeof(UnityEngine.UI.Image))
    _FlashScreen.color = ColorRGB(255, 255, 255, 0)

    danmaku.Setup()
    player.Setup()
    boss.Setup()
end

stage.Start = function()
    DSTAGE:Begin()

    player.Start()
    boss.Start()

    BGPattern.color = UnityEngine.Color(1, 1, 1, BG_OPACITY)

    if _JudgeArea then
        _JudgeArea:SetActive(false)
    end

    if _Lane then
        _Lane:SetActive(false)
    end

    if _ComboView then
        _ComboView:SetActive(false)
    end

    if _TouchArea then
        _TouchArea.transform.localPosition = Vector3(20, 0, 0)
    end

    if _BeatBarObjectPool then
        _BeatBarObjectPool:SetActive(false)
    end

    if _MusicTimePanel then
        _MusicTimePanel.transform:DOLocalMove(Vector3(0, 800, 0), 0.5):SetEase(CS.DG.Tweening.Ease.InOutQuad)
    end
    if _BossBar then
        _BossBar.transform:DOLocalMove(Vector3(0, SaveSliderY, 0), 0.5):SetEase(CS.DG.Tweening.Ease.InOutQuad)
    end

    _EnemyCanvas = GameObject.Find("EnemyCanvas")
    if _EnemyCanvas then
        _EnemyCanvas:SetActive(false)
    end
end

stage.Update = function()
    local playerPos = player.GetPlayer():GetTransform().localPosition

    if _CameraCanvasGroup then
        if playerPos.z >= 3 then
            _CameraCanvasGroup.alpha = 0.4
        else
            _CameraCanvasGroup.alpha = 1
        end
    end

    if _BGPattern then
        _BGPattern.transform.eulerAngles = _BGPattern.transform.eulerAngles + Vector3(0, 0.1, 0)
    end

    boss.Update()
    player.Update()

    if Flash ~= nil then
        Flash:Update()
    end
end

stage.Stop = function()
    DSTAGE:End()

    player.Stop()

    BGPattern.color = UnityEngine.Color(1, 1, 1, 0)

    if _JudgeArea then
        _JudgeArea:SetActive(true)
    end

    if _Lane then
        _Lane:SetActive(true)
    end

    if _ComboView then
        _ComboView:SetActive(true)
    end

    if _TouchArea then
        _TouchArea.transform.localPosition = Vector3(0, 0, 0)
    end

    if _BeatBarObjectPool then
        _BeatBarObjectPool:SetActive(true)
    end

    if _CameraCanvasGroup then
        _CameraCanvasGroup.alpha = 1
    end

    if flash then
        flash.flash_new(_FlashScreen, 1, 0, 0.5)
    end

    boss.Stop()

    if _MusicTimePanel then
        _MusicTimePanel.transform:DOLocalMove(Vector3(0, SaveSliderY, 0), 0.25):SetEase(CS.DG.Tweening.Ease.InOutQuad)
    end

    if _BossBar then
        _BossBar.transform:DOLocalMove(Vector3(0, 800, 0), 0.25):SetEase(CS.DG.Tweening.Ease.InOutQuad)
    end
end

return stage
