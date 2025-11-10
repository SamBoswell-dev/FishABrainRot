local ContextActionService = game:GetService("ContextActionService")
local Manager = {}

local ACTIONS = {
	PRESSRIGHT = "PRESS_RIGHT",
	PRESSLEFT = "PRESS_LEFT",
}

function Manager.BindFishingMiniGame(
	functionForRight: (string, Enum.UserInputState, InputObject) -> Enum.ContextActionResult?,
	functionForLeft: (string, Enum.UserInputState, InputObject) -> Enum.ContextActionResult?
)
	ContextActionService:BindAction(ACTIONS.PRESSRIGHT, functionForRight, false, Enum.KeyCode.D)
	ContextActionService:BindAction(ACTIONS.PRESSLEFT, functionForLeft, false, Enum.KeyCode.A)
end

function Manager.UnbindFishingMiniGame()
	ContextActionService:UnbindAction(ACTIONS.PRESSRIGHT)
	ContextActionService:UnbindAction(ACTIONS.PRESSLEFT)
end

return Manager
