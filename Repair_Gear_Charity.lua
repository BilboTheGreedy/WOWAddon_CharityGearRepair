CGR_SavedVars = {
    	player = "",
	amount = 1,
	xpos = 330,
	ypos = -640,
	hmsg = "Repairs",
	bmsg = "Here's a donation.",
	hidden = true,
	autodonate = true
}

 local button = CreateFrame("Button", nil, mainframe)
    local function OnEnter(self)
        if self.Tooltip then
            GameTooltip:SetOwner(self,"ANCHOR_TOP");
            GameTooltip:AddLine(self.Tooltip,0,1,0.5,1,1,1);
            GameTooltip:Show();
			
        end
    end
    local function OnLeave(self) if GameTooltip:IsOwned(self) then GameTooltip:Hide(); end end
	button:SetPoint("CENTER", mainframe, "CENTER", CGR_SavedVars.ypos, CGR_SavedVars.xpos)
	button:SetSize(50, 30)
	button:Hide()
	button:SetNormalFontObject("GameFontNormalSmall");
    button:SetHighlightFontObject("GameFontHighlightSmall");
    button:SetDisabledFontObject("GameFontDisableSmall");
    button:SetText("Donate");
    button:SetScript("OnEnter",OnEnter);
	button:SetScript("OnLeave",OnLeave);
	button.Tooltip="DONATE AND SAVE THE WORLD!";

	local ntex = button:CreateTexture()
	ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()	
	button:SetNormalTexture(ntex)
	
	local htex = button:CreateTexture()
	htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	button:SetHighlightTexture(htex)
	
	local ptex = button:CreateTexture()
	ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	ptex:SetTexCoord(0, 0.425, 0, 0.4875)
	ptex:SetAllPoints()
	button:SetPushedTexture(ptex)
	
	button:SetScript("OnClick", function(self, arg1)
	    print("donated", CGR_SavedVars.amount, "c to: " .. CGR_SavedVars.player)
		SetSendMailMoney(1);
		SendMail(CGR_SavedVars.player,CGR_SavedVars.hmsg,CGR_SavedVars.bmsg)
	end)

	  button:RegisterEvent("MAIL_SHOW")
	  button:RegisterEvent("MAIL_CLOSED")
	  
	button:SetScript("OnEvent", function(self, event)
	if event == "MAIL_SHOW" then
		button.Tooltip="Donate to " .. CGR_SavedVars.player;	
		button:Show();
		if CGR_SavedVars.autodonate then
		print("Auto donated", CGR_SavedVars.amount, "copper to: " .. CGR_SavedVars.player)
		PlaySound("MapPing", "master");
		SetSendMailMoney(1);
		SendMail(CGR_SavedVars.player,CGR_SavedVars.hmsg,CGR_SavedVars.bmsg)
		end
	end
	
	if event == "MAIL_CLOSED" then
		button:Hide();
	end
	end)



SLASH_CRG1 = '/cgr';
local function handler(msg, editbox)
 local command, rest = msg:match("^(%S*)%s*(.-)$");
 -- Any leading non-whitespace is captured into command;
 -- the rest (minus leading whitespace) is captured into rest.
 if command == "player" and rest ~= "" then
 CGR_SavedVars.player = rest
 button.Tooltip="Donate to " .. CGR_SavedVars.player;
  print(rest)
 elseif command == "amount" and rest ~= "" then
 CGR_SavedVars.amount = tonumber(rest);
  print("Donation amount set: " .. rest .. "c") 
  
  elseif command == "hmsg" and rest ~= "" then
  CGR_SavedVars.hmsg = rest;
	elseif command == "bmsg" and rest ~= "" then
  CGR_SavedVars.bmsg = rest;

  elseif command == "xpos" and rest ~= "" then
  CGR_SavedVars.xpos = tonumber(rest);
	elseif command == "ypos" and rest ~= "" then
  CGR_SavedVars.ypos = tonumber(rest);
  	elseif command == "show" then
	  print(CGR_SavedVars.player);
	   print(CGR_SavedVars.amount);
		print(CGR_SavedVars.hmsg);
		 print(CGR_SavedVars.bmsg);
	
  elseif command == "toggle" then
	  if button:IsVisible() then
		  button:Hide();
		  print("Hidden");
		  CGR_SavedVars.hidden = true;
	  else
		  button:Show();
		  print("Visible")
		  CGR_SavedVars.hidden = false;
  end
  elseif command == "autodonate" then
	  if CGR_SavedVars.autodonate then
		  CGR_SavedVars.autodonate = false
		  print("Auto Donation false")
	  else
		CGR_SavedVars.autodonate = true
		print("Auto Donation true")
end
 else
  -- If not handled above, display some sort of help message
      print(GetAddOnMetadata("Repair_Gear_Charity", "Title"), 'v' .. GetAddOnMetadata("Repair_Gear_Charity", "Version")
	,"\n",
	"/cgr player <name> - send donations to character"
	,"\n",
	"/cgr amount <number> - set amount of copper to donate"
	,"\n",
	"/cgr autodonate - Auto donate when mailbox is clicked"
	,"\n",
	"/cgr hmsg <text> - set message header"
	,"\n",
	"/cgr bmsg <text> - set message body"
	,"\n",
	"/cgr xpos - x-position"
	,"\n",
	"/cgr ypos - y-position"
	,"\n",
	"/cgr toggle - hide/show button"
	,"\n",
	"/cgr show - shows amount, header, message and character settings");
 end
end
SlashCmdList["CRG"] = handler;


