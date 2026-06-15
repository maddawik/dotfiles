local M = {}

M.get_quote = function()
  local quotes = require("maddawik.dashboard.quotes")
  math.randomseed(os.time())
  return quotes[math.random(#quotes)]
end

return M
