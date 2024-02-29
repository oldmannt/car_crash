local module = {}

local CollectionService = game:GetService("CollectionService")

-- Save the connections so they can be disconnected when the tag is removed
-- This table maps BaseParts with the tag to their Touched connections
local connections = {}


function module.ConnectTag(tag:string, onInsanceAdd)
	
	connections[tag] = {}
	local tagConnections = connections[tag]
	
	local function onInstanceAdded(object)
		local conn = onInsanceAdd(object)
		if conn then
			tagConnections[object] = conn
		end
	end

	local function onInstanceRemoved(object)
		-- If we made a connection on this object, disconnect it (prevent memory leaks)
		if connections[object] then
			tagConnections[object]:Disconnect()
			tagConnections[object] = nil
		end
	end
	
	-- Listen for this tag being applied to objects
	CollectionService:GetInstanceAddedSignal(tag):Connect(onInstanceAdded)
	CollectionService:GetInstanceRemovedSignal(tag):Connect(onInstanceRemoved)
	
	-- Also detect any objects that already have the tag
	for _, object in pairs(CollectionService:GetTagged(tag)) do
		if not object:FindFirstAncestorWhichIsA("Workspace") then
			continue
		end
		onInstanceAdded(object)
	end
	
end

return module
