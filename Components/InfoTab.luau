return function(Window)
    local LatestChangelog = {
        "2026/7/11",
        "<font color='rgb(0, 255, 0)'>+ 新增 实体 ESP 选择</font>",
		"<font color='rgb(0, 255, 0)'>+ 新增 物品通知器</font>",
		"<font color='rgb(0, 255, 0)'>+ 新增 移除 Surge</font>",
		"<font color='rgb(0, 255, 0)'>+ 新增 死亡刷怪</font>",
		"<font color='rgb(0, 255, 0)'>+ 修复 部分失效功能（绕过视线检测等）</font>",
    }

    local function CloneReference(Object)
        if Abysall and Abysall.Environment.cloneref then
            return Abysall.Environment.cloneref(Object)
        else
            return Object
        end
    end

    local Services = setmetatable({}, {
        __index = function(self, Name)
            return CloneReference(game:GetService(Name))
        end
    })

    local Library = Abysall.Interface.Library
    local SaveManager = Abysall.Interface.SaveManager
    local ThemeManager = Abysall.Interface.ThemeManager

    local Toggles = Library.Toggles
    local Options = Library.Options

    local LocalPlayer = Services.Players.LocalPlayer
    local InfoTab = Window:AddTab("Info", "user")

    local User = InfoTab:AddLeftGroupbox("User Info")

    local ImageSize = Enum.ThumbnailSize.Size420x420
    local ImageType = Enum.ThumbnailType.HeadShot

    local Content = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId, ImageType, ImageSize)

    User:AddImage("UserIcon", {
        Image = Content
    })

    User:AddLabel("ID: " .. LocalPlayer.Name, true)
    User:AddLabel("总执行次数: " .. (Abysall.TotalExecutions and Abysall.TotalExecutions or "N/A"), true)

    local Changelog = InfoTab:AddRightGroupbox("Changelog")
    for Index, Change in pairs(LatestChangelog) do
        Changelog:AddLabel(Change, true)
    end

    local Name, Version = Abysall.Environment.identifyexecutor()
    local Executor = InfoTab:AddRightGroupbox("Executor Info")
    Executor:AddLabel("名称: " .. Name, true)
	Executor:AddLabel("版本: " .. (Version and Version or "N/A"), true)
    Executor:AddDivider()
    Executor:AddLabel("测试结果: ", true)

    for Index, Result in pairs(Abysall.Environment.Results) do
		-- fix for veloshitty 💔
		Result = Result:gsub("<", "(")
		Result = Result:gsub(">", ")")
		
        Executor:AddLabel(Result, true)
    end

    local Community = InfoTab:AddLeftGroupbox("Community")
    Community:AddButton("复制 Discord 邀请链接", function()
	    toclipboard("https://dsc.gg/abysallhub")
	    Library:Notify("Discord 邀请链接已复制。")
    end)
end
