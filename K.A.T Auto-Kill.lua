function nearestPlayerToRay()
    local dist = math.huge
    local ray
    
    for i,v in pairs(game.Players:GetChildren()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Head") and not v.Character:FindFirstChild("ForceField") then
            if v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("Head") then -- needed..
                local newVec = (v.Character.Head.Position - game.Players.LocalPlayer.Character.Head.Position)
                if newVec.magnitude < dist then
                    local toRay = Ray.new(game.Players.LocalPlayer.Character.Head.Position, newVec)
                    if not workspace:FindPartOnRayWithIgnoreList(toRay, {game.Players.LocalPlayer.Character, v.Character, workspace.WorldIgnore, workspace.CurrentCamera}) then
                        dist = newVec.magnitude
                        ray = toRay
                    end
                end
            end
        end
    end
    return ray
end

local ray

function init()
    local knife = game.Players.LocalPlayer.Character:WaitForChild("Knife")
    local scr = getsenv(knife.KnifeServer.KnifeClient)
    if scr then
        local ir = scr.inputReleased
        local u7 = debug.getupvalue(ir, 2)
        local cam = debug.getupvalue(ir, 5)
        debug.setupvalue(ir, 5, setmetatable({}, {
            __index = function(t,k)
                if k == "ScreenPointToRay" then
                    if ray ~= nil then
                        return function() return ray end
                    end
                end
                return cam[k]
            end
        }))
    
        
        while wait(.1) do
            if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then
                break    
            end
            ray = nearestPlayerToRay()
            if ray then
                scr.inputDown()
                u7.ChargeStart = -math.huge
                ir()
            end
        end
    end
end

init()
game.Players.LocalPlayer.CharacterAdded:connect(function()
    print("hi")
    wait()
    init()
end)