local Runtime = require(script.Parent.Parent.Runtime)
local create = require(script.Parent.Parent.create)
local Style = require(script.Parent.Parent.Style)
local automaticSize = require(script.Parent.Parent.automaticSize)

--[=[
	@within Plasma
	@function label
	@param text string
	@tag widgets

	Text.
]=]
return Runtime.widget(function(text)

	local changed, setChanged = Runtime.useState(false)
	local refs = Runtime.useInstance(function(ref)
		local style = Style.get()

		create("TextBox", {
			[ref] = "textbox",
			BackgroundTransparency = 1,
			Font = Enum.Font.SourceSans,
			TextColor3 = style.textColor,
			TextSize = 20,
			RichText = true,
		})

		automaticSize(ref.label)

		return ref.label
	end)

	refs.textbox.Text = text
    refs.textbox:GetPropertyChangedSignal('Text'):Connect(function()
        setChanged(true)
    end)

    local handle = {
		changed = function()
			if changed then
				setChanged(false)
				return true
			end

			return false
		end,
	}

    return handle
end)
