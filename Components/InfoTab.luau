return function(Window)
    local LatestChangelog = {
        "2026/6/22",
        "<font color='rgb(0, 255, 0)'>+ 新增 实验性新物体处理器，开门时减少卡顿</font>",
		"<font color='rgb(0, 255, 0)'>+ 修复 自动心跳小游戏</font>",
		"<font color='rgb(0, 255, 0)'>+ 修复 远程开门在追逐时导致卡虚空的问题</font>",
		"<font color='rgb(0, 255, 0)'>+ 其他错误修复</font>",
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
    local InfoTab = Window:AddTab("信息", "user")

    local User = InfoTab:AddLeftGroupbox("用户信息")

    local ImageSize = Enum.ThumbnailSize.Size420x420
    local ImageType = Enum.ThumbnailType.HeadShot

    local Content = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId, ImageType, ImageSize)

    User:AddImage("UserIcon", {
        Image = Content
    })

    User:AddLabel("ID: " .. LocalPlayer.Name, true)
    User:AddLabel("总执行次数: " .. (Abysall.TotalExecutions and Abysall.TotalExecutions or "无"), true)

    local Changelog = InfoTab:AddRightGroupbox("更新日志")
    for Index, Change in pairs(LatestChangelog) do
        Changelog:AddLabel(Change, true)
    end

    local Name, Version = Abysall.Environment.identifyexecutor()
    local Executor = InfoTab:AddRightGroupbox("执行器信息")
    Executor:AddLabel("名称: " .. Name, true)
	Executor:AddLabel("版本: " .. (Version and Version or "无"), true)
    Executor:AddDivider()
    Executor:AddLabel("测试结果: ", true)

    for Index, Result in pairs(Abysall.Environment.Results) do
		-- 修复 veloshitty 的问题 💔
		Result = Result:gsub("<", "(")
		Result = Result:gsub(">", ")")
		
        Executor:AddLabel(Result, true)
    end

    local Community = InfoTab:AddLeftGroupbox("社区")
    Community:AddButton("复制 Discord 邀请", function()
	    toclipboard("https://dsc.gg/abysallhub")
	    Library:Notify("Discord 邀请已复制")
    end)
end
