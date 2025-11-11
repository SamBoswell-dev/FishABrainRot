local ContextActionService = game:GetService("ContextActionService")
local Manager = {}

local ACTIONS = {
	PRESSRIGHT = "PRESS_RIGHT",
	PRESSLEFT = "PRESS_LEFT",
	PRESSFORWARD = "PRESS_FORWARD",
	PRESSBACKWARD = "PRESS_BACKWARD",
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

return Manager
