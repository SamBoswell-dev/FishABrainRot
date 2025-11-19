local ContextActionService = game:GetService("ContextActionService")
local Manager = {}

local ACTIONS = {
	PRESSRIGHT = "PRESS_RIGHT",
	PRESSLEFT = "PRESS_LEFT",
	PRESSFORWARD = "PRESS_FORWARD",
	PRESSBACKWARD = "PRESS_BACKWARD",
	TOGGLEROD = "TOGGLE_ROD",
	CLICKROD = "CLICK_ROD",
}

function Manager.BindFishingMiniGame(
	functionForRight: (string, Enum.UserInputState, InputObject) -> Enum.ContextActionResult?,
	functionForLeft: (string, Enum.UserInputState, InputObject) -> Enum.ContextActionResult?
)
	ContextActionService:BindAction(ACTIONS.PRESSRIGHT, functionForRight, false, Enum.KeyCode.D)
	ContextActionService:BindAction(ACTIONS.PRESSLEFT, functionForLeft, false, Enum.KeyCode.A)
	ContextActionService:BindAction(ACTIONS.PRESSFORWARD, function() end, false, Enum.KeyCode.W)
	ContextActionService:BindAction(ACTIONS.PRESSBACKWARD, function() end, false, Enum.KeyCode.S)
end

function Manager.UnbindFishingMiniGame()
	ContextActionService:UnbindAction(ACTIONS.PRESSRIGHT)
	ContextActionService:UnbindAction(ACTIONS.PRESSLEFT)
	ContextActionService:UnbindAction(ACTIONS.PRESSFORWARD)
	ContextActionService:UnbindAction(ACTIONS.PRESSBACKWARD)
end

function Manager.BindRod(functionForRod: (string, Enum.UserInputState, InputObject) -> Enum.ContextActionResult?)
	ContextActionService:BindAction(ACTIONS.TOGGLEROD, functionForRod, false, Enum.KeyCode.F)
end

function Manager.UnBindRod()
	ContextActionService:UnbindAction(ACTIONS.TOGGLEROD)
	ContextActionService:UnbindAction(ACTIONS.CLICKROD)
end

function Manager.BindCast(functionForClick: (string, Enum.UserInputState, InputObject) -> Enum.ContextActionResult?)
	ContextActionService:BindAction(ACTIONS.CLICKROD, functionForClick, false, Enum.UserInputType.MouseButton1)
end

function Manager.UnBindCast()
	ContextActionService:UnbindAction(ACTIONS.CLICKROD)
end

return Manager
