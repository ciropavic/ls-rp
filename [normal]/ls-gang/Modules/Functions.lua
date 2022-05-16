function isAllowed(source)
  local steam = nil
  local xPlayer = ESX.GetPlayerFromId(source)
  for k,v in ipairs(GetPlayerIdentifiers(source)) do
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
          steam = v
      end
  end
  for k,v in pairs(Config['admins']) do
      if v == steam then
          return true
      end
  end
  for k,v in pairs(Config['groups']) do
      if xPlayer.getGroup() == v then
          return true
      end
  end
  return false
end